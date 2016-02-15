@echo off
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.Client -prop="./dvk_client.properties"
