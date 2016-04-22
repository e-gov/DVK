@echo off
setlocal
set dvk_client_dir=.
java.exe -Xmx1024M -classpath %dvk_client_dir%;%dvk_client_dir%/lib/*;%dvk_client_dir%/dvk-client.jar; dvk.client.Client -mode=1 -prop="%dvk_client_dir%\dvk_client.properties"
endlocal
