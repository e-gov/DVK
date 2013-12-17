@echo off
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.TestClient -prop="./dvk_client.properties"
