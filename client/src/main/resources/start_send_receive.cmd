@echo off
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.Client -mode=3 -prop="./dvk_client.properties"
