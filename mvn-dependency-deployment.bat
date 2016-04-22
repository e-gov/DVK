@REM This script is meant to do two things for the DVK project:
@REM 	1) install  3rd party libraries to the local repository
@REM 	2) deploy 3rd party libraries to the required repository


@REM ********************************************
@REM ***** Change the below paths as needed *****
@REM ********************************************
@SET dvkProjectDir=C:\Users\Levan\Projects\RIA\dvk
@SET dvkCoreLibDir=%dvkProjectDir%\core\lib
@SET dvkClientLibDir=%dvkProjectDir%\client\lib
@SET dvkApiLibDir=%dvkProjectDir%\api\lib
@SET dvkServerLibDir=%dvkProjectDir%\server\lib


@REM *******************************************************************************************
@REM ***** If you need to INSTALL uncomment the below TWO LINES (i.e. delete those @REM's). *****
@REM ***** NB! pluginOptions MUST be empty in this case.                                   *****
@REM *******************************************************************************************
@REM @SET plugin=install:install-file
@REM @SET pluginOptions=


@REM *******************************************************************************************
@REM ***** If you need to DEPLOY uncomment the below TWO LINES (i.e. delete those @REM's).  *****            
@REM ***** NB! don't forget to make changes in the pluginOptions as needed.                *****
@REM *******************************************************************************************
@SET plugin=deploy:deploy-file
@SET pluginOptions=-DrepositoryId=ria -Durl=https://artifactory.tt.kit/artifactory/DVK-libs-release-local/



@REM ***********************************
@REM ***** DVK parent dependencies *****
@REM ***********************************

call mvn %plugin%^
 -DgroupId=commons-logging^
 -DartifactId=commons-logging^
 -Dversion=1.1^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/commons-logging-1.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=commons-discovery^
 -DartifactId=commons-discovery^
 -Dversion=0.4^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/commons-discovery-0.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=xerces^
 -DartifactId=xercesImpl^
 -Dversion=2.9.1^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/xercesImpl.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=com.oracle^
 -DartifactId=ojdbc14^
 -Dversion=10.2.0.4.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/ojdbc14.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=com.oracle^
 -DartifactId=orai18n^
 -Dversion=10.2.0.4.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/orai18n.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.logging.log4j^
 -DartifactId=log4j-api^
 -Dversion=2.1^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/log4j-api-2.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.logging.log4j^
 -DartifactId=log4j-core^
 -Dversion=2.1^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/log4j-core-2.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.logging.log4j^
 -DartifactId=log4j-1.2-api^
 -Dversion=2.1^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/log4j-1.2-api-2.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jaxrpc^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/jaxrpc.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=axis^
 -DartifactId=axis^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/axis.jar"^
 %pluginOptions%

call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=mail^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/mail.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=activation^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/activation.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=isorelax^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/isorelax.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=relaxngDatatype^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/relaxngDatatype.jar"^
 %pluginOptions%

call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=xsdlib^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/xsdlib.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=xmlParserAPIs^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/xmlParserAPIs.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=resolver^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/resolver.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=msv^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/msv.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=serializer^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/serializer.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=stax^
 -Dversion=2.3^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/stax2-3.0pr1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=wstx^
 -Dversion=3.9.2^
 -Dpackaging=jar^
 -Dfile="%dvkCoreLibDir%/wstx-lgpl-3.9.2.jar"^
 %pluginOptions%
 


@REM ***********************************
@REM ***** DVK core dependencies *****
@REM ***********************************



@REM ***********************************
@REM ***** DVK client dependencies *****
@REM ***********************************
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jsse^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/jsse.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=postgresql^
 -DartifactId=postgresql^
 -Dversion=8.3-603.jdbc3^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/postgresql-8.3-603.jdbc3.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.codehaus.castor^
 -DartifactId=castor^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/castor-1.3.1.jar"^
 %pluginOptions%

call mvn %plugin%^
 -DgroupId=org.codehaus.castor^
 -DartifactId=castor-core^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/castor-1.3.1-core.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.codehaus.castor^
 -DartifactId=castor-xml^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/castor-1.3.1-xml.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.hibernate^
 -DartifactId=hibernate3^
 -Dversion=3.3.2.GA^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/hibernate3.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=com.microsoft.sqlserver^
 -DartifactId=sqljdbc4^
 -Dversion=2.0^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/sqljdbc4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=com.sybase^
 -DartifactId=jconn3^
 -Dversion=6.0^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/jconn3.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=com.sybase^
 -DartifactId=jdbc3-tds^
 -Dversion=6.0^
 -Dpackaging=jar^
 -Dfile="%dvkClientLibDir%/jconn3.jar"^
 %pluginOptions%
 


@REM ********************************
@REM ***** DVK api dependencies *****
@REM ********************************
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=antlr^
 -Dversion=2.7.6^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/antlr-2.7.6.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=asm^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/asm.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=asm-attrs^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/asm-attrs.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=c3p0^
 -Dversion=0.9.0^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/c3p0-0.9.0.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=castor^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/castor-1.3.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=castor-core^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/castor-1.3.1-core.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=castor-xml^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/castor-1.3.1-xml.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=cglib^
 -Dversion=2.1.3^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/cglib-2.1.3.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=commons-collections^
 -Dversion=3.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/commons-collections-3.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=commons-logging^
 -Dversion=1.0.4^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/commons-logging-1.0.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=dom4j^
 -Dversion=1.6.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/dom4j-1.6.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=hibernate3^
 -Dversion=1.6.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/hibernate3.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=hsqldb^
 -Dversion=1.6.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/hsqldb.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=javassist^
 -Dversion=3.9.0.GA^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/javassist-3.9.0.GA.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jta^
 -Dversion=1.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/jta-1.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.logging.log4j^
 -DartifactId=log4j-api^
 -Dversion=2.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/log4j-api-2.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.logging.log4j^
 -DartifactId=log4j-core^
 -Dversion=2.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/log4j-core-2.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.logging.log4j^
 -DartifactId=log4j-1.2-api^
 -Dversion=2.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/log4j-1.2-api-2.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=ojdbc^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/ojdbc14.jar"^
 %pluginOptions%

call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=simple-jndi^
 -Dversion=0.11.4.1^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/simple-jndi-0.11.4.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.slf4j^
 -DartifactId=slf4j-api^
 -Dversion=1.5.10^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/slf4j-api-1.5.10.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.slf4j^
 -DartifactId=slf4j-log4j12^
 -Dversion=1.5.10^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/slf4j-log4j12-1.5.10.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=velocity-dep^
 -Dversion=1.5^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/velocity-dep-1.5.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=xerces^
 -DartifactId=xercesSamples^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/xercesSamples.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=xml-apis^
 -DartifactId=xml-apis^
 -Dversion=1.3.04^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/xml-apis.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.commons^
 -DartifactId=commons-lang3^
 -Dversion=3.3.2^
 -Dpackaging=jar^
 -Dfile="%dvkApiLibDir%/commons-lang3-3.3.2.jar"^
 %pluginOptions%



@REM ***********************************
@REM ***** DVK server dependencies *****
@REM ***********************************
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=activation^
 -Dversion=1.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/activation-1.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=annogen^
 -Dversion=0.1.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/annogen-0.1.0.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.ws.commons.axiom^
 -DartifactId=axiom-api^
 -Dversion=1.2.7^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axiom-api-1.2.7.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.ws.commons.axiom^
 -DartifactId=axiom-dom^
 -Dversion=1.2.7^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axiom-dom-1.2.7.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.ws.commons.axiom^
 -DartifactId=axiom-impl^
 -Dversion=1.2.7^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axiom-impl-1.2.7.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-adb^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-adb-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-adb-codegen^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-adb-codegen-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-ant-plugin^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-ant-plugin-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-clustering^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-clustering-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-codegen^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-codegen-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-corba^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-corba-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-fastinfoset^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-fastinfoset-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-java2wsdl^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-java2wsdl-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-jaxbri^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-jaxbri-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-jaxws^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-jaxws-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-jaxws-api^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-jaxws-api-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-jibx^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-jibx-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-json^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-json-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-jws-api^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-jws-api-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-kernel^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-kernel-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-metadata^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-metadata-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-mtompolicy^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-mtompolicy-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-saaj^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-saaj-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-saaj-api^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-saaj-api-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-spring^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-spring-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.axis2^
 -DartifactId=axis2-xmlbeans^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/axis2-xmlbeans-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=backport^
 -DartifactId=util-concurrent^
 -Dversion=3.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/backport-util-concurrent-3.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=bcmail-jdk15^
 -Dversion=1.48^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/bcmail-jdk15on-148.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=bcprov-jdk15^
 -Dversion=1.48^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/bcprov-jdk15on-148.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=bcpkix-jdk15on^
 -Dversion=1.48^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/bcpkix-jdk15on-148.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=commons-codec^
 -DartifactId=commons-codec^
 -Dversion=1.6^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/commons-codec-1.6.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=commons-fileupload^
 -DartifactId=commons-fileupload^
 -Dversion=1.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/commons-fileupload-1.2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=commons-httpclient^
 -DartifactId=commons-httpclient^
 -Dversion=3.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/commons-httpclient-3.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=commons-io^
 -DartifactId=commons-io^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/commons-io-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.geronimo.specs^
 -DartifactId=geronimo-annotation_1.0_spec^
 -Dversion=1.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/geronimo-annotation_1.0_spec-1.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.geronimo.specs^
 -DartifactId=geronimo-stax-api_1.0_spec^
 -Dversion=1.0.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/geronimo-stax-api_1.0_spec-1.0.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.httpcomponents^
 -DartifactId=httpcore^
 -Dversion=4.0-beta1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/httpcore-4.0-beta1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.httpcomponents^
 -DartifactId=httpcore-nio^
 -Dversion=4.0-beta1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/httpcore-nio-4.0-beta1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=apache^
 -DartifactId=jalopy^
 -Dversion=1.5rc3^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jalopy-1.5rc3.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=javaee^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/javaee-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jaxb-api^
 -Dversion=2.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jaxb-api-2.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jaxb-impl^
 -Dversion=2.1.6^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jaxb-impl-2.1.6.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=com.sun.codemodel^
 -DartifactId=codemodel^
 -Dversion=2.1-SNAPSHOT^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jaxb-xjc-2.1.6.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jaxen^
 -Dversion=1.1.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jaxen-1.1.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=ee.eesti.id^
 -DartifactId=jdigidoc^
 -Dversion=3.9.0-726^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jdigidoc-3.9.0-726.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.commons^
 -DartifactId=commons-compress^
 -Dversion=1.3^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/commons-compress-1.3.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.codehaus.jettison^
 -DartifactId=jettison^
 -Dversion=1.0-RC2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jettison-1.0-RC2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jibx-bind^
 -Dversion=1.1.5^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jibx-bind-1.1.5.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jibx-run^
 -Dversion=1.1.5^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jibx-run-1.1.5.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=jstl^
 -Dversion=1.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/jstl-1.2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=mail^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/mail-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.neethi^
 -DartifactId=neethi^
 -Dversion=2.0.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/neethi-2.0.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=saaj^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/saaj.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=soapmonitor^
 -Dversion=1.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/soapmonitor-1.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=stax2^
 -Dversion=3.0pr1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/stax2-3.0pr1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.woden^
 -DartifactId=woden-api^
 -Dversion=1.0M8^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/woden-api-1.0M8.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.woden^
 -DartifactId=woden-impl-dom^
 -Dversion=1.0M8^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/woden-impl-dom-1.0M8.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=wsdl4j^
 -Dversion=1.6.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/wsdl4j-1.6.2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=wstx-asl^
 -Dversion=3.2.4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/wstx-asl-3.2.4.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=wstx-lgpl^
 -Dversion=3.9.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/wstx-lgpl-3.9.2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=java^
 -DartifactId=xalan^
 -Dversion=2.7.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/xalan-2.7.0.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=xerces^
 -DartifactId=xercesImpl^
 -Dversion=2.6.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/xercesImpl.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=xml-resolver^
 -DartifactId=xml-resolver^
 -Dversion=1.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/xml-resolver-1.2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.xmlbeans^
 -DartifactId=xmlbeans^
 -Dversion=2.3.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/xmlbeans-2.3.0.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.ws.commons.schema^
 -DartifactId=XmlSchema^
 -Dversion=1.4.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/XmlSchema-1.4.2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=xml-security^
 -DartifactId=xmlsec^
 -Dversion=1.3.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/xmlsec-1.3.0.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.castor^
 -DartifactId=castor^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/castor-1.3.1.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.castor^
 -DartifactId=core^
 -Dversion=1.3.1^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/castor-1.3.1-core.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.apache.commons^
 -DartifactId=commons-lang3^
 -Dversion=3.3.2^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/commons-lang3-3.3.2.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=sunjce_provider^
 -DartifactId=sunjce_provider^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/sunjce_provider.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=sunpkcs11^
 -DartifactId=sunpkcs11^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/sunpkcs11.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=tinyxmlcanonicalizer^
 -DartifactId=tinyxmlcanonicalizer^
 -Dversion=0.9.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/tinyxmlcanonicalizer-0.9.0.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=iaikPkcs11Wrapper^
 -DartifactId=iaikPkcs11Wrapper^
 -Dversion=1.0^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/iaikPkcs11Wrapper.jar"^
 %pluginOptions%
 
call mvn %plugin%^
 -DgroupId=org.postgresql^
 -DartifactId=postgresql^
 -Dversion=postgresql-9.0-801.jdbc4^
 -Dpackaging=jar^
 -Dfile="%dvkServerLibDir%/postgresql-9.0-801.jdbc4.jar"^
 %pluginOptions%