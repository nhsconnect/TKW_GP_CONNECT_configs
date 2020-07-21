@echo off
rem
rem
set JAVA_OPTIONS=-Dtks.skipsignlogs=Y

rem set MODE=-simulator
set MODE=-httpinterceptor

E:
if "%1" == "F" (
	set PROPS=tkw-x-forwarding.properties
) else (
	set PROPS=tkw-x.properties
)

java %JAVA_OPTIONS% -jar ..\..\TKW-x.jar %MODE% %PROPS%
