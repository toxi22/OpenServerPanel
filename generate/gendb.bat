:: --------------------------------------------------------------------------------
:: OPEN SERVER PANEL | DB INIT SCRIPT
:: --------------------------------------------------------------------------------
@echo off
set "OSP_ROOT_DIR=%~dp0..\"
if exist "%OSP_ROOT_DIR%bin\ansicon.exe" "%OSP_ROOT_DIR%bin\ansicon.exe" -p >nul 2>nul
chcp 65001 > nul
for /d %%D in ("%OSP_ROOT_DIR%generate\config\*") do robocopy "%%D" "%OSP_ROOT_DIR%config\%%~nxD" /UNICODE /DCOPY:DAT /COPY:DAT /TIMFIX /E /J /ETA /IM /MT:32 /R:3 /W:3 >nul 2>nul
rd    "%OSP_ROOT_DIR%generate\new_data" /s /q 2>nul
mkdir "%OSP_ROOT_DIR%generate\new_data" 2>nul
TITLE DB Generator
start "MariaDB 1 Generator" "%OSP_ROOT_DIR%generate\genmariadb1.bat"
start "MariaDB 2 Generator" "%OSP_ROOT_DIR%generate\genmariadb2.bat"
start "MySQL Generator" "%OSP_ROOT_DIR%generate\genmysql.bat"
call :posgresql PostgreSQL-9.5
call :posgresql PostgreSQL-9.6
call :posgresql PostgreSQL-10
call :posgresql PostgreSQL-11
call :posgresql PostgreSQL-12
call :posgresql PostgreSQL-13
call :posgresql PostgreSQL-14
call :posgresql PostgreSQL-15
goto end
:: --------------------------------------------------------------------------------
:: INIT PostgreSQL
:: --------------------------------------------------------------------------------
:posgresql
call osp off %1
call osp init %1 default
call osp set %1
rd "%OSP_ROOT_DIR%data\%1" /s /q 2>nul
mkdir "%OSP_ROOT_DIR%data\%1"
mkdir "%OSP_ROOT_DIR%generate\new_data\%1"
call initdb --data-checksums --no-locale -U postgres --encoding=UTF8 -D "%OSP_ROOT_DIR%data\%1"
del "%OSP_ROOT_DIR%data\%1\pg_hba.conf" "%OSP_ROOT_DIR%data\%1\postgresql.conf"
robocopy "%OSP_ROOT_DIR%data\%1" "%OSP_ROOT_DIR%generate\new_data\%1" /UNICODE /DCOPY:DAT /COPY:DAT /TIMFIX /MIR /J /ETA /IM /MT:32 /R:3 /W:3 >nul 2>nul
exit /b 0
:end
echo on
@PAUSE
