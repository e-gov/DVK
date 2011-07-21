@echo off
setlocal
set docLifetime=0
if [%1] neq [] set docLifetime=%1
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.Client -mode=5 -prop="./dvk_client.properties" -docLifetimeDays=%docLifetime%
endlocal