@echo off
rem
rem
E:
set JAVA_OPTIONS=-Dtks.skipsignlogs=Y
java %JAVA_OPTIONS% -jar ..\..\TKW-x.jar -transmit tkw-x.properties

pause
