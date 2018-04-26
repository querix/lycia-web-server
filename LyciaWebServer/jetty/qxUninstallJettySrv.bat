@echo off

set SERVICE_NAME=%1
set INST_DIR=%2
set JETTY_BASE=%3

set INST_DIR=%INST_DIR:"=%
set JETTY_BASE=%JETTY_BASE:"=%

rem ################################################################

set JETTY_HOME=%INST_DIR%\jetty

"%JETTY_HOME%\bin\jetty-srv.exe" //DS//%SERVICE_NAME%
echo 
echo The service '%SERVICE_NAME%' has been removed. Exit code %ERRORLEVEL%.
