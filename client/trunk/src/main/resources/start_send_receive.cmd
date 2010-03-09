@echo off
setlocal

set dvk_client_dir=C:\dvk_client

java.exe -Xmx1024M -classpath "%dvk_client_dir%;%dvk_client_dir%\lib\activation.jar;%dvk_client_dir%\lib\axis.jar;%dvk_client_dir%\lib\commons-discovery-0.2.jar;%dvk_client_dir%\lib\commons-logging-1.0.4.jar;%dvk_client_dir%\lib\isorelax.jar;%dvk_client_dir%\lib\jaxrpc.jar;%dvk_client_dir%\lib\mail.jar;%dvk_client_dir%\lib\msv.jar;%dvk_client_dir%\lib\ojdbc14.jar;%dvk_client_dir%\lib\orai18n.jar;%dvk_client_dir%\lib\relaxingDatatype.jar;%dvk_client_dir%\lib\resolver.jar;%dvk_client_dir%\lib\serializer.jar;%dvk_client_dir%\lib\stax2.jar;%dvk_client_dir%\lib\wstx-lgpl-3.9.2.jar;%dvk_client_dir%\lib\xercesImpl.jar;%dvk_client_dir%\lib\xml-apis.jar;%dvk_client_dir%\lib\xmlParserAPIs.jar;%dvk_client_dir%\lib\xsdlib.jar;%dvk_client_dir%\lib\postgresql-8.3-603.jdbc3.jar;%dvk_client_dir%\lib\sqljdbc.jar" dvk.client.Client -mode=3 -prop="%dvk_client_dir%\dvk_client.properties"

endlocal