@ECHO off
CD C:\xampp\mysql\data\filemaindb\

for /r "C:\xampp\mysql\data\filemaindb" %%a in () do(
	echo %%a
)
PAUSE