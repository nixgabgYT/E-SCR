@echo off
setlocal enabledelayedexpansion
title Easy Script (.escr) Engine v1.0 - Multi-Command
color 0f

if "%~1" == "" (
    echo [ERROR] Please drag and drop a .escr file onto this interpreter.
    pause
    exit /b
)

if not "%~x1" == ".escr" (
    echo [ERROR] Invalid file extension. Only .escr files are supported.
    pause
    exit /b
)

rem Legge il file .escr riga per riga
for /f "usebackq delims=" %%G in ("%~1") do (
    set "row=%%G"
    
    rem Rileva ed elimina i commenti
    set "start_check=!row:~0,2!"
    
    if "!start_check!" == "//" (
        rem Ignora la riga (è un commento)
    ) else if "!row!" == "clear" (
        cls
    ) else if "!row!" == "pause" (
        pause
    ) else if "!row!" == "end" (
        exit /b
    ) else if "!row!" == "myip" (
        ipconfig | findstr "IPv4"
    ) else if "!row!" == "sysinfo" (
        systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
		) else if "!row!" == "version" (
		echo Easy Script Engine v1.0
    ) else if "!row!" == "beep" (
        echo 
    ) else if "!row!" == "date" (
        echo Current Date: %date%
    ) else if "!row!" == "time" (
        echo Current Time: %time%
	) else if "!row!" == "username" (
		echo %USERNAME%
    ) else if "!row!" == "list files" (
        dir /b /a-d
    ) else if "!row!" == "list folders" (
        dir /b /ad
    ) else if "!row!" == "macaddress" (
        getmac
    ) else if "!row!" == "uptime" (
        net statistics workstation | findstr "since"
    ) else if "!row!" == "ping server" (
        ping 192.168.0.242 -n 2
    ) else if "!row!" == "pc shutdown" (
        shutdown /s /t 60 /c "Easy Script Shutdown Link"
    ) else if "!row!" == "pc abort" (
        shutdown /a
	) else if "!row!" == "sep" (
		echo ----------------------------------------
	) else if "!row!" == "newline" (
    echo.
    ) else (

        rem Comando: theme("orange") o theme("green") o theme("blue")
        echo !row! | findstr /c:"theme(\"orange\")" >nul && color 06
        echo !row! | findstr /c:"theme(\"green\")" >nul && color 0a
        echo !row! | findstr /c:"theme(\"blue\")" >nul && color 09
        echo !row! | findstr /c:"theme(\"white\")" >nul && color 0f
        
        rem Comando: say("...")
        echo !row! | findstr /r "^say(" >nul
        if !errorlevel! == 0 (
            set "clean_msg=!row:*say(=!"
            set "clean_msg=!clean_msg:~1!"
            set "clean_msg=!clean_msg:~0,-2!"
            echo !clean_msg!
        )
		echo !row! | findstr /r "^echo(" >nul
		if !errorlevel! == 0 (
			set "clean_msg=!row:*echo(=!"
			set "clean_msg=!clean_msg:~1!"
			set "clean_msg=!clean_msg:~0,-2!"
			echo !clean_msg!
		)
        rem Comando: create folder("...")
        echo !row! | findstr /r "^create folder(" >nul
        if !errorlevel! == 0 (
            set "f_name=!row:*create folder(=!"
            set "f_name=!f_name:~1!"
            set "f_name=!f_name:~0,-2!"
            mkdir "!f_name!" 2>nul
        )

        rem Comando: delete file("...")
        echo !row! | findstr /r "^delete file(" >nul
        if !errorlevel! == 0 (
            set "f_del=!row:*delete file(=!"
            set "f_del=!f_del:~1!"
            set "f_del=!f_del:~0,-2!"
            del /q /f "!f_del!" 2>nul
        )

        rem Comando: wait[secondi]
        echo !row! | findstr /r "^wait\[" >nul
        if !errorlevel! == 0 (
            set "sec=!row:*wait[=!"
            set "sec=!sec:~0,-1!"
            timeout /t !sec! >nul
        )
        
        rem Controllo speciale: if file[*] number[5]
        echo !row! | findstr /c:"if file[*] number[5]" >nul
        if !errorlevel! == 0 (
            set "file_count=0"
            for /f %%F in ('dir /b /a-d 2^>nul') do set /a file_count+=1
            if "!file_count!" == "5" (
                echo There are 5 files
            ) else (
                echo There are not 5 files :^(
            )
		echo !row! | findstr /r "^title(" >nul
		if !errorlevel! == 0 (
			set "ttl=!row:*title(=!"
			set "ttl=!ttl:~1!"
			set "ttl=!ttl:~0,-2!"
			title !ttl!
		)
		echo !row! | findstr /r "^open(" >nul
		if !errorlevel! == 0 (
			set "url=!row:*open(=!"
			set "url=!url:~1!"
			set "url=!url:~0,-2!"
			start "" "!url!"
		)
		echo !row! | findstr /r "^start(" >nul
		if !errorlevel! == 0 (
			set "app=!row:*start(=!"
			set "app=!app:~1!"
			set "app=!app:~0,-2!"
			start "" "!app!"
		)
		echo !row! | findstr /r "^cmd(" >nul
		if !errorlevel! == 0 (
			set "c=!row:*cmd(=!"
			set "c=!c:~1!"
			set "c=!c:~0,-2!"
			cmd /c "!c!"
		)
		echo !row! | findstr /r "^ps(" >nul
		if !errorlevel! == 0 (
			set "p=!row:*ps(=!"
			set "p=!p:~1!"
			set "p=!p:~0,-2!"
			powershell -NoProfile -Command "!p!"
		)
		echo !row! | findstr /r "^random\[" >nul
		if !errorlevel! == 0 (
			set "r=!row:*random[=!"
			set "r=!r:~0,-1!"
			set /a rand=%random% %% !r!
			echo !rand!
		)
        )
    )
)
echo.
echo [Execution Finished]
pause