@echo off
set SERVICE_NAME=qxweb_7
set INST_DIR=C:\Program Files\Querix\LyciaWebServer
set JETTY_BASE=C:\ProgramData\Querix\Lycia\jetty
set JETTY_HOME=%INST_DIR%\jetty
echo Start service 'qxweb_7' ...
"%JETTY_HOME%\bin\jetty-srv.exe" //TS//%SERVICE_NAME%
echo Service '%SERVICE_NAME%' running exit code %ERRORLEVEL%.
