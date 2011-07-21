@echo off
java.exe -Xmx1024M -classpath ".;lib/*" dvk.client.OrgCapabilityChecker -prop="./dvk_client.properties"
