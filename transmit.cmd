@echo off
rem
rem
E:
set JAVA_OPTIONS=-Dtks.skipsignlogs=Y
java %JAVA_OPTIONS% -jar ..\..\TKW.jar -transmit tkw.properties

pause
