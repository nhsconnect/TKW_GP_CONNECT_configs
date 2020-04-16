@echo off
rem
rem
set JAVA_OPTIONS=-Dtks.skipsignlogs=Y

rem set MODE=-simulator
set MODE=-httpinterceptor

E:
if "%1" == "F" (
	set PROPS=tkw_forward_all.properties
) else (
	set PROPS=tkw.properties
)

java %JAVA_OPTIONS% -jar ..\..\TKW.jar %MODE% %PROPS%
