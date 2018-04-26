@echo off

set SERVICE_NAME=%1
set INST_DIR=%2
set JETTY_BASE=%3
set QAS_DIR=%4
set LYCIA_DIR=%5
set AUTH=%6

set INST_DIR=%INST_DIR:"=%
set JETTY_BASE=%JETTY_BASE:"=%
set QAS_DIR=%QAS_DIR:"=%
set LYCIA_DIR=%LYCIA_DIR:"=%

set STOPKEY=secret
set STOPPORT=50001
rem ################################################################

if not "%QAS_DIR%" == "" goto qas_found
set QAS_DIR=%INST_DIR%\AppServer
:qas_found
echo Application Server Dir '%QAS_DIR%'

set PATH=%LYCIA_DIR%\bin;%QAS_DIR%;%PATH%
set JETTY_HOME=%INST_DIR%\jetty
set EXECUTABLE=%JETTY_HOME%\bin\jetty-srv.exe

if exist "%EXECUTABLE%" goto exe_found
echo '%EXECUTABLE%' was not found...
echo The JETTY_HOME environment variable is not defined correctly.
echo This environment variable is needed to run this program
exit 1
:exe_found

echo Installing '%SERVICE_NAME%'
echo JETTY_HOME:       "%JETTY_HOME%"
echo JETTY_BASE:       "%JETTY_BASE%"
echo JAVA_HOME:        "%JAVA_HOME%"
echo JRE_HOME:         "%JRE_HOME%"
echo JDK_HOME:         "%JDK_HOME%"

if not "%AUTH%" == "" goto auth_found
set AUTH=modauthnt.dll
:auth_found
echo Authorization module '%AUTH%'

set PR_DISPLAYNAME=Querix Lycia Web Application Server
set PR_DESCRIPTION=Querix Lycia Web Application Server based on Jetty 9 webserver - https://eclipse.org/jetty/
set PR_INSTALL=%EXECUTABLE%
set PR_LOGPATH=%JETTY_BASE%\logs
set PR_CLASSPATH=%JETTY_HOME%\start.jar

set PR_STARTPARAMS=STOP.KEY="%STOPKEY%";STOP.PORT=%STOPPORT%
set PR_STOPPARAMS=--stop;STOP.KEY="%STOPKEY%";STOP.PORT=%STOPPORT%;STOP.WAIT=10

set PR_JVM=%JAVA_HOME%\jre\bin\server\jvm.dll
if exist "%PR_JVM%" goto found_jvm

set PR_JVM=%JAVA_HOME%\jre\bin\client\jvm.dll
if exist "%PR_JVM%" goto found_jvm

set PR_JVM=%JRE_HOME%\jre\bin\server\jvm.dll
if exist "%PR_JVM%" goto found_jvm

set PR_JVM=%JRE_HOME%\jre\bin\client\jvm.dll
if exist "%PR_JVM%" goto found_jvm

set PR_JVM=%JDK_HOME%\jre\bin\server\jvm.dll
if exist "%PR_JVM%" goto found_jvm

set PR_JVM=%JDK_HOME%\jre\bin\client\jvm.dll
if exist "%PR_JVM%" goto found_jvm

set PR_JVM=auto
:found_jvm
echo JVM:              "%PR_JVM%"

"%EXECUTABLE%" //VS

"%EXECUTABLE%" //IS//%SERVICE_NAME% --StartClass org.eclipse.jetty.start.Main --StopClass org.eclipse.jetty.start.Main --StartParams="%PR_STARTPARAMS%" --StopParams="%PR_STOPPARAMS%"
if errorlevel 1 goto err_installed
if errorlevel 2 goto err_installed
if errorlevel 3 goto err_installed
if errorlevel 4 goto err_installed
if errorlevel 5 goto err_installed
if errorlevel 6 goto err_installed
echo Installing service exit code %ERRORLEVEL%.
goto installed
:err_installed
echo Failed installing service '%SERVICE_NAME%'. Error %ERRORLEVEL%.
exit 2
:installed

set PR_DISPLAYNAME=
set PR_DESCRIPTION=
set PR_INSTALL=
set PR_LOGPATH=
set PR_CLASSPATH=
set PR_JVM=
set PR_STARTPARAMS=
set PR_STOPPARAMS=

"%EXECUTABLE%" //US//%SERVICE_NAME% --JvmOptions "-Djetty.base=%JETTY_BASE%;-Djetty.home=%JETTY_HOME%" --StartMode jvm --StopMode jvm
echo service '%SERVICE_NAME%' update 1 returns %ERRORLEVEL%. 
if not errorlevel 1 goto updated1
exit 3
:updated1

set PR_LOGPATH=%JETTY_BASE%\logs
set PR_STDOUTPUT=auto
set PR_STDERROR=auto
"%EXECUTABLE%" //US//%SERVICE_NAME% ++JvmOptions "-Djava.io.tmpdir=%JETTY_BASE%\temp"
echo service '%SERVICE_NAME%' update 2 returns %ERRORLEVEL%. 
if not errorlevel 1 goto updated2
exit 4
:updated2

"%EXECUTABLE%" //US//%SERVICE_NAME% --Startup=auto --Environment "LA_AUTH_MODULE=%AUTH%#QAS_DIR=%QAS_DIR%#LYCIA_DIR=%LYCIA_DIR%#JETTY_HOME=%JETTY_HOME%#JETTY_BASE=%JETTY_BASE%" --LibraryPath="%LYCIA_DIR%\bin;%QAS_DIR%"
echo service '%SERVICE_NAME%' update 3 returns %ERRORLEVEL%.
if not errorlevel 1 goto updated3
exit 5
:updated3

echo The service '%SERVICE_NAME%' has been installed.


:end

