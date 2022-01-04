@echo off
@title Installing Microsoft Libs and Store

ver
echo+

goto check_admin
:check_admin
 echo Script must Run as Administrator! Detecting permissions...
 net session >nul 2>&1
 if %errorLevel% == 0 (
  echo Success!
  ) else (
  echo Failure. Please, Run script as Administrator!
  echo+
  echo Exiting...
  timeout /t 5 /nobreak >nul
  exit /b
 )

cd /d "%~dp0"
for /f "tokens=6 delims=[]. " %%i in ('ver') do set build=%%i
if "%PROCESSOR_ARCHITECTURE%"=="x86" (set "arch=x86") else (set "arch=x64")

echo+
echo Install Microsoft .Net and VC Libs?
pause
echo+

call :install "NET.Native" "%arch%" "appx"
call :install "VCLibs" "%arch%" "appx"
call :install "Xaml" "%arch%" "appx"

echo+
echo Install Microsoft Store?
echo [!] You can close the script window at this step if you DON'T want to install store!
pause
echo+

call :install "WindowsStore" "neutral" "msixbundle"

echo+
echo Done!
pause

exit /b 

:install
set "name=%~1"
set "arch=%~2"
set "ext=.%~3"
for /f "tokens=1* delims=" %%i in ('dir /b /s "*%name%*%arch%*%ext%" 2^>nul') do (powershell add-appxprovisionedpackage -online -packagepath '%%i' -skiplicense -erroraction silentlycontinue)

exit /b
