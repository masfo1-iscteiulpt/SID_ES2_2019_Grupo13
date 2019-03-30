@ECHO off
set /A "max=0"
set selected=


for /r "C:\xampp\mysql\data\filemaindb\" %%A in (*) do ( 
	for /f "tokens=1,2 delims=_" %%i in ("%%~nxA") do ( 
		if "%%j"=="UtilizadorLog.csv" (
			if "%%i" gtr "%max%" (
				set /A "max=%%i"
				set selected=%%i_%%j
			)
		)
	)
)
if defined selected (
	echo %selected%
	C:\xampp\mysql\bin\mysql.exe -u root -h localhost fileremotedb -e "load data infile 'C:/xampp/mysql/data/filemaindb/%selected%' into table utilizador_log fields terminated by ',' enclosed by '\'' lines terminated by '\n'"
	del C:\xampp\mysql\data\filemaindb\%selected%
) else (
	echo not defined
)

set /A "max=0"
set selected=


PAUSE