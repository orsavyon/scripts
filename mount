#!/bin/bash

# Check if cifs-utils and expect are installed

if ! dpkg -s cifs-utils &> /dev/null; then

   echo "cifs-utils is not installed. Installing..."
   sudo apt-get update
   sudo apt-get install -y cifs-utils

fi

# Check if we are using a GUI or CLI login

if ! [ -z "$DISPLAY" ]; then

# GUI login

echo "Using GUI login"

# Use zenity to display the list of files in a dialog box

chosen=$(zenity --list --title "Devbitshares Folders" --column "Folders" "Aerospace" "Licenses" "sql_quorum" "aerospace_cvai" "Elisra_Devops" "MCWF" "tcvat" "BackupsVeeam11NTNX" "ElisraProjects" "nas_nfs_rt_team" "Training" "BackupsVeeamNTNX" "Elop" "NFS_RT_Team" "VISDOM_2D" "ClearML" "From_Elbit" "Radio_NFS" "vol01" "cnvrg_nfs1" "jira" "Resec" "vol02" "DAITA" "Land" "RoamingProfiles" "vol03" "DAITA2" "Land_C4I" "SCCM_INSTALLS" "vol04" "deployshare" "Land-IMI" "Share" --text="Please choose your folder:" )

# Check if the user selected a file

	if [ -n "$chosen" ]; then

	  # Do something with the selected file

	  echo "You choose: $chosen"

	# Display dialog box with message and one input fields

	response=$(zenity --password --text="Please enter your login password:")
	password=$(echo $response | cut -d'|' -f1)

	# Create the mount folder in the user's home

	mkdir /home/$USER/devbitshares/$chosen -p

	# mount the selected folder

	echo $password | sudo -S mount.cifs //devbitshares/$chosen /home/$USER/devbitshares/$chosen -o user=$USER,pass=$password,dom=devbit vers=1.0

	else

	  # Handle the case where the user did not select a file

	  echo "No folder selected"

	fi

else

# CLI login

echo "Using CLI login"

# show the list of devbitshares folders

echo "

Devbitshares folders:

Aerospace	
Licenses	
sql_quorum	
aerospace_cvai	
Elisra_Devops 	
MCWF	
tcvat 	
Backups 	
Veeam11NTNX 	
Elisra 		
Projects 	
nas_nfs_rt_team 	
Training 	
Backups		
VeeamNTNX 	
Elop 		
NFS_RT_Team 	
VISDOM_2D	
ClearML 	
From_Elbit 	
Radio_NFS 	
vol01 		
cnvrg_nfs1 	
jira 			
Resec 
vol02 		
DAITA 		
Land 		
RoamingProfiles
vol03 		
DAITA2 		
Land_C4I 	
SCCM_INSTALLS 	
vol04 		
deployshare 	
Land-IMI 		
Share
" 

# Prompt for the requested folder in the CLI

   read -p "Enter the requested folder to mount: "  chosen

# Check if the user selected a file

	if [ -n "$chosen" ]; then

	  # Do something with the selected file

	  echo "You choose: $chosen"
	  
	 # Prompt for network password in the CLI

	  read -p "Enter your password: " -s password

	# Create the mount folder in the user's home

	mkdir /home/$USER/devbitshares/$chosen -p

	# mount the selected folder

	echo $password | sudo -S mount.cifs //devbitshares/$chosen /home/$USER/devbitshares/$chosen -o user=$USER,pass=$password,dom=devbit vers=1.0

	else

	  # Handle the case where the user did not select a file

	  echo "No folder selected"

	fi

fi


echo "Network location mounted successfully!"
