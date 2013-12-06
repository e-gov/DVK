@echo off
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.Client -mode=4 -prop="./dvk_client.properties"
