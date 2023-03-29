#!/bin/bash

# Ask user for the IP and Credentials of the remote computer
echo "Enter the IP address of the remote computer: "
read ip_address

echo "Enter the sudo username of the remote computer: "
read user

echo "Enter the sudo password of the remote computer: "
read password

#Generate an SSH key on the machine where the script is running
ssh-keygen -y -q -t rsa -N "" -f /home/$USER/.ssh/id_rsa 

#Copy the public key to the remote machine
ssh-copy-id -f $user@$ip_address

# Display all disks on the remote computer and the main disk that contains the root partition and the file system partition
ssh $user@$ip_address lsblk 
disk=$(ssh $user@$ip_address lsblk -no PKNAME,MOUNTPOINT,FSTYPE | awk '/\/ /{print $1}' | sort -u)

# Ask user if they want to create an image of the main disk
read -p "Do you want to create an image of the $disk disk? (y/n)" answer

if [ $answer == "y" ]; then

#create the folder for the mountpoint in the remote computer
ssh $user@$ip_address -t "echo $password | sudo -S -c 'mkdir -m 777 /home/$USER/devbitshares/IMG -p'"

# Mount the IMG network folder to the remote computer
ssh $user@$ip_address -t "echo $password | sudo -S -c 'mount.cifs //10.0.231.151/visdom_2d/IMG /home/$USER/devbitshares/IMG -o user=e039211p,pass=2581999Ors,dom=devbit vers=1.0'"

# Create the image using dd, compress it using xz and save it on local disk IMG
ssh $user@$ip_address -t "echo $password | sudo -S su -c 'dd if=/dev/$disk | xz -vT0 > /home/$USER/devbitshares/IMG/$(hostname)-$(date +"%m_%d_%y").img.xz'"

else
  echo "No image was created."
fi
