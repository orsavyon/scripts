@echo off

::echo
set /p address=Enter hostname or ip address:
query session /server:%address%
set /p session_id=Enter session ID:
mstsc.exe /v:%address% /shadow:%session_id% /control /noconsentprompt
