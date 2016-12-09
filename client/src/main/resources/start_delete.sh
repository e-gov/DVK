#!/bin/sh

DVK_CLIENT_DIR=.

DVK_CLASSPATH=$DVK_CLIENT_DIR
for f in $DVK_CLIENT_DIR/lib/*.jar
do
  DVK_CLASSPATH=$DVK_CLASSPATH:$f
done

DOC_LIFETIME=0
if [$# -le 0]; then
  DOC_LIFETIME=$1
fi

java -Xmx1024M -classpath $DVK_CLASSPATH dvk.client.Client -mode=5 -prop=$DVK_CLIENT_DIR/dvk_client.properties -docLifetimeDays=$DOC_LIFETIME
