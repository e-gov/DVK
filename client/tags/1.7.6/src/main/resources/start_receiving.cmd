@echo off
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.Client -mode=2 -prop="./dvk_client.properties"
