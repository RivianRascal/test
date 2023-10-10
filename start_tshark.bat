REM This script has been created by the Authentix SOC
REM Please do not alter or delete it
REM Make sure to set the interface name to the correct one and specify tshark arguments

@echo off

REM Makes the variables work as they should in the loop
setlocal enabledelayedexpansion

REM Generate a random number and construct the output filename
set /a "RANDOM_NUM=%RANDOM% * %RANDOM%"
set OUTPUT_FILE=C:\Temp\capture_%RANDOM_NUM%.pcap

REM Set the path to tshark.exe
set TSHARK="C:\Program Files\Wireshark\tshark.exe"

REM Get the list of interfaces
for /f "tokens=1,* delims=." %%a in ('%TSHARK% -D') do (
    REM Check if the interface name contains the unique characteristic of the LAN interface
    echo %%b | findstr /C:"Ethernet" >nul
    if !errorlevel! == 0 (
        set interfaceIndex=%%a
        goto :startCapture
    )
)

:startCapture
if defined interfaceIndex (
    REM Start tshark with desired parameters
    %TSHARK% -i !interfaceIndex! -f "port 445" -w %OUTPUT_FILE%
) else (
    REM If needed, you can log an error message to a file here
    echo LAN Interface not found. >> C:\Temp\error_log.txt
)
