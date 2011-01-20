#!/bin/sh

DVK_CLIENT_DIR=/home/kasutajad/jaak/dvk_client

DVK_CLASSPATH=$DVK_CLIENT_DIR
for f in $DVK_CLIENT_DIR/lib/*.jar
do
  DVK_CLASSPATH=$DVK_CLASSPATH:$f
done
java -Xmx1024M -classpath $DVK_CLASSPATH dvk.client.TestClient -prop=$DVK_CLIENT_DIR/dvk_client.properties
