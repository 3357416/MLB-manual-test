@echo off
setlocal enabledelayedexpansion

:: Variables
set STM32_CLI="C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
set BIN_FILE="C:\JabilTest\scripts\MLB\g47_mlb.bin"
set LOG_FILE=flash_log.txt

:: Limpiar log previo
if exist %LOG_FILE% del %LOG_FILE%
echo Flashing log - %date% %time% > %LOG_FILE%
echo Flashing log - %date% %time%

:: Paso 1: Conectar al dispositivo
echo Connecting to device... >> %LOG_FILE%
echo Connecting to device...
%STM32_CLI% -c port=SWD >> %LOG_FILE% 2>&1
if errorlevel 1 (
    echo FAIL: Unable to connect to device. >> %LOG_FILE%
    echo FAIL: Unable to connect to device.
    goto disconnect
) else (
    echo PASS: Connected to device. >> %LOG_FILE%
    echo PASS: Connected to device.
)

:: Paso 2: Validar conexión
echo Validating connection... >> %LOG_FILE%
echo Validating connection...
%STM32_CLI% -c port=SWD >> %LOG_FILE% 2>&1
if errorlevel 1 (
    echo FAIL: Connection validation failed. >> %LOG_FILE%
    echo FAIL: Connection validation failed.
    goto disconnect
) else (
    echo PASS: Connection validated. >> %LOG_FILE%
    echo PASS: Connection validated.
)

:: Paso 3: Cargar el archivo binario
echo Loading binary file... >> %LOG_FILE%
echo Loading binary file...
if not exist %BIN_FILE% (
    echo FAIL: Binary file not found: %BIN_FILE% >> %LOG_FILE%
    echo FAIL: Binary file not found: %BIN_FILE%
    goto disconnect
)
echo PASS: Binary file loaded: %BIN_FILE% >> %LOG_FILE%
echo PASS: Binary file loaded: %BIN_FILE%

:: Paso 4: Descargar y flashear el archivo binario con verificación inmediata
echo Flashing and verifying device... >> %LOG_FILE%
echo Flashing and verifying device...
%STM32_CLI% -c port=SWD -d %BIN_FILE% 0x08000000 -v "%BIN_FILE%" 0x08000000 >> %LOG_FILE% 2>&1
if errorlevel 1 (
    echo FAIL: Flashing or verification failed. >> %LOG_FILE%
    echo FAIL: Flashing or verification failed.
    goto disconnect
) else (
    echo PASS: Flashing and verification successful. >> %LOG_FILE%
    echo PASS: Flashing and verification successful.
)

:: Paso 5: Desconectar
:disconnect
echo Disconnecting device... >> %LOG_FILE%
echo Disconnecting device...
%STM32_CLI% -c port=SWD -rst >> %LOG_FILE% 2>&1
if errorlevel 1 (
    echo FAIL: Disconnection failed. >> %LOG_FILE%
    echo FAIL: Disconnection failed.
    exit /b
) else (
    echo PASS: Disconnected. >> %LOG_FILE%
    echo PASS: Disconnected.
)

:: Finalización
echo All operations completed. >> %LOG_FILE%
echo All operations completed.
exit /b
