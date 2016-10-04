@echo off
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.Client -mode=1 -prop="./dvk_client.properties"
