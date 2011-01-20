<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:dhl="http://www.riik.ee/schemas/dhl/2010/2"
	xmlns:ma="http://www.riik.ee/schemas/dhl-meta-automatic"
	xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual/2010/2"
	xmlns:dhl-custom="dhl.xslt.CustomFunctions"
	xmlns:rkel-letter="http://www.riik.ee/schemas/dhl/rkel_letter">
	
  <xsl:output 
  	method="xml" 
  	encoding="UTF-8" 
  	indent="yes"
    xalan:line-separator="&#10;"
    />
  
  <xsl:preserve-space elements="*"/>
  
  <xsl:template match="dhl:dokument">  
  	<dhl:dokument>
  	
  		<!-- Metainfo -->
	  	<xsl:text>&#10;&#9;</xsl:text><dhl:metainfo>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_asutuse_nr><xsl:value-of select="dhl:metainfo/mm:koostaja_asutuse_nr" /></mm:koostaja_asutuse_nr>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saaja_asutuse_nr><xsl:value-of select="dhl:metainfo/mm:saaja_asutuse_nr" /></mm:saaja_asutuse_nr>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_dokumendinimi><xsl:value-of select="dhl:metainfo/mm:koostaja_dokumendinimi" /></mm:koostaja_dokumendinimi>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_dokumendityyp><xsl:value-of select="dhl:metainfo/mm:koostaja_dokumendityyp" /></mm:koostaja_dokumendityyp>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_dokumendinr><xsl:value-of select="dhl:metainfo/mm:koostaja_dokumendinr" /></mm:koostaja_dokumendinr>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_failinimi><xsl:value-of select="dhl:metainfo/mm:koostaja_failinimi" /></mm:koostaja_failinimi>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_kataloog><xsl:value-of select="dhl:metainfo/mm:koostaja_kataloog" /></mm:koostaja_kataloog>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_votmesona><xsl:value-of select="dhl:metainfo/mm:koostaja_votmesona" /></mm:koostaja_votmesona>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_kokkuvote><xsl:value-of select="dhl:metainfo/mm:koostaja_kokkuvote" /></mm:koostaja_kokkuvote>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_kuupaev><xsl:value-of select="dhl:metainfo/mm:koostaja_kuupaev" /></mm:koostaja_kuupaev>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:koostaja_asutuse_nimi><xsl:value-of select="dhl:metainfo/mm:koostaja_asutuse_nimi" /></mm:koostaja_asutuse_nimi>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:autori_osakond><xsl:value-of select="dhl:metainfo/mm:autori_osakond" /></mm:autori_osakond>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:autori_isikukood><xsl:value-of select="dhl:metainfo/mm:autori_isikukood" /></mm:autori_isikukood>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:autori_nimi><xsl:value-of select="dhl:metainfo/mm:koostaja_dokumendityyp" /></mm:autori_nimi>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:autori_kontakt><xsl:value-of select="dhl:metainfo/mm:autori_kontakt" /></mm:autori_kontakt>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:seotud_dokumendinr_koostajal><xsl:value-of select="dhl:metainfo/mm:seotud_dokumendinr_koostajal" /></mm:seotud_dokumendinr_koostajal>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:seotud_dokumendinr_saajal><xsl:value-of select="dhl:metainfo/mm:seotud_dokumendinr_saajal" /></mm:seotud_dokumendinr_saajal>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saatja_dokumendinr><xsl:value-of select="dhl:metainfo/mm:saatja_dokumendinr" /></mm:saatja_dokumendinr>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saatja_kuupaev><xsl:value-of select="dhl:metainfo/mm:saatja_kuupaev" /></mm:saatja_kuupaev>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saatja_asutuse_kontakt><xsl:value-of select="dhl:metainfo/mm:saatja_asutuse_kontakt" /></mm:saatja_asutuse_kontakt>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saaja_isikukood><xsl:value-of select="dhl:metainfo/mm:saaja_isikukood" /></mm:saaja_isikukood>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saaja_nimi><xsl:value-of select="dhl:metainfo/mm:saaja_nimi" /></mm:saaja_nimi>
	  		<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saaja_osakond><xsl:value-of select="dhl:metainfo/mm:saaja_osakond" /></mm:saaja_osakond>
	  		
	  		<!-- mm:kuupaev_saatmine -> mm:saatja_kuupaev -->	  		
			<xsl:text>&#10;&#9;&#9;</xsl:text><mm:saatja_kuupaev><xsl:value-of select="dhl:metainfo/mm:kuupaev_saatmine" /></mm:saatja_kuupaev>
	  			  		
	  		<xsl:for-each select="dhl:metainfo/mm:saatja_defineeritud">
	  			<xsl:text>&#10;&#9;&#9;</xsl:text><xsl:copy-of select="."></xsl:copy-of>
	  		</xsl:for-each>
	  		
	  	<xsl:text>&#10;&#9;</xsl:text></dhl:metainfo>
	  	<!-- //Metainfo -->
	  	
	  	<!-- Transport -->
	  	<xsl:text>&#10;&#9;</xsl:text><dhl:transport>
	  		
	  		<!-- Saatja -->
	  		<xsl:for-each select="dhl:transport/dhl:saatja">
		  		<xsl:text>&#10;&#9;&#9;</xsl:text><dhl:saatja>
		  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:regnr><xsl:value-of select="dhl:regnr" /></dhl:regnr>
		  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:nimi><xsl:value-of select="dhl:nimi" /></dhl:nimi>
		  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:asutuse_nimi><xsl:value-of select="dhl:asutuse_nimi" /></dhl:asutuse_nimi>
		  			
		  			<xsl:if test="dhl:ametikoha_nimetus">
		  				<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:ametikoha_nimetus><xsl:value-of select="dhl:ametikoha_nimetus" /></dhl:ametikoha_nimetus>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:ametikoha_lyhinimetus">
		  				<!-- dhl:ametikoha_lyhinimetus -> dhl:ametikoha_kood -->
		  				<xsl:variable name="senderPositionShortName" select="dhl:ametikoha_lyhinimetus"></xsl:variable>
		  				<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:ametikoha_kood><xsl:value-of select="dhl-custom:getPositionCodeByShortName($senderPositionShortName)" /></dhl:ametikoha_kood>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:allyksuse_nimetus">
		  				<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:allyksuse_nimetus><xsl:value-of select="dhl:allyksuse_nimetus" /></dhl:allyksuse_nimetus>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:allyksuse_lyhinimetus">
		  				<!-- dhl:allyksuse_lyhinimetus -> dhl:allyksuse_kood -->
		  				<xsl:variable name="senderDivisionShortName" select="dhl:allyksuse_lyhinimetus"></xsl:variable>
		  				<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:allyksuse_kood><xsl:value-of select="dhl-custom:getDivisionCodeByShortName($senderDivisionShortName)" /></dhl:allyksuse_kood>
		  			</xsl:if>
		  			
		  		<xsl:text>&#10;&#9;&#9;</xsl:text></dhl:saatja>
	  		</xsl:for-each>
	  		<!-- //Saatja -->
	  		
	  		<!-- Saajad -->
	  		<xsl:for-each select="dhl:transport/dhl:saaja">
		  		<xsl:text>&#10;&#9;&#9;</xsl:text><dhl:saaja>
		  			
		  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:regnr><xsl:value-of select="dhl:regnr" /></dhl:regnr>
		  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:asutuse_nimi><xsl:value-of select="dhl:asutuse_nimi" /></dhl:asutuse_nimi>
		  			
		  			<xsl:if test="dhl:ametikoha_nimetus">
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:ametikoha_nimetus><xsl:value-of select="dhl:ametikoha_nimetus" /></dhl:ametikoha_nimetus>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:ametikoha_lyhinimetus">
		  				<!-- dhl:ametikoha_lyhinimetus -> dhl:ametikoha_kood -->
			  			<xsl:variable name="addresseePositionShortName" select="dhl:ametikoha_lyhinimetus"></xsl:variable>
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:ametikoha_kood><xsl:value-of select="dhl-custom:getPositionCodeByShortName($addresseePositionShortName)" /></dhl:ametikoha_kood>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:allyksuse_nimetus">
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:allyksuse_nimetus><xsl:value-of select="dhl:allyksuse_nimetus" /></dhl:allyksuse_nimetus>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:allyksuse_lyhinimetus">
		  				<!-- dhl:allyksuse_lyhinimetus -> dhl:allyksuse_kood -->
			  			<xsl:variable name="addresseeDivisionShortName" select="dhl:allyksuse_lyhinimetus"></xsl:variable>
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:allyksuse_kood><xsl:value-of select="dhl-custom:getDivisionCodeByShortName($addresseeDivisionShortName)" /></dhl:allyksuse_kood>
		  			</xsl:if>
		  			
		  		<xsl:text>&#10;&#9;&#9;</xsl:text></dhl:saaja>
	  		</xsl:for-each>
	  		<!-- //Saajad -->
	  		
	  		<!-- Vahendaja -->
	  		<xsl:for-each select="dhl:transport/dhl:vahendaja">
		  		<xsl:text>&#10;&#9;&#9;</xsl:text><dhl:vahendaja>
		  			
		  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:regnr><xsl:value-of select="dhl:regnr" /></dhl:regnr>
		  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:asutuse_nimi><xsl:value-of select="dhl:asutuse_nimi" /></dhl:asutuse_nimi>
		  			
		  			<xsl:if test="dhl:ametikoha_nimetus">
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:ametikoha_nimetus><xsl:value-of select="dhl:ametikoha_nimetus" /></dhl:ametikoha_nimetus>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:ametikoha_lyhinimetus">
		  				<!-- dhl:ametikoha_lyhinimetus -> dhl:ametikoha_kood -->
			  			<xsl:variable name="proxyPositionShortName" select="dhl:ametikoha_lyhinimetus"></xsl:variable>
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:ametikoha_kood><xsl:value-of select="dhl-custom:getPositionCodeByShortName($proxyPositionShortName)" /></dhl:ametikoha_kood>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:allyksuse_nimetus">
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:allyksuse_nimetus><xsl:value-of select="dhl:allyksuse_nimetus" /></dhl:allyksuse_nimetus>
		  			</xsl:if>
		  			
		  			<xsl:if test="dhl:allyksuse_lyhinimetus">
		  				<!-- dhl:allyksuse_lyhinimetus -> dhl:allyksuse_kood -->
			  			<xsl:variable name="proxyDivisionShortName" select="dhl:allyksuse_lyhinimetus"></xsl:variable>
			  			<xsl:text>&#10;&#9;&#9;&#9;</xsl:text><dhl:allyksuse_kood><xsl:value-of select="dhl-custom:getDivisionCodeByShortName($proxyDivisionShortName)" /></dhl:allyksuse_kood>
		  			</xsl:if>
		  			
		  		<xsl:text>&#10;&#9;&#9;</xsl:text></dhl:vahendaja>
	  		</xsl:for-each>
	  		<!-- //Vahendaja -->
	  		
	  	<xsl:text>&#10;&#9;</xsl:text></dhl:transport>
	  	<!-- //Transport -->
	  	
	  	<!-- Ajalugu -->
	  	<xsl:if test="dhl:ajalugu">
	  		<xsl:text>&#10;&#9;</xsl:text><xsl:copy-of select="dhl:ajalugu"></xsl:copy-of>
	  	</xsl:if>
	  	<!-- //Ajalugu -->
	  	
	  	<!-- Metaxml -->
	  	<xsl:if test="dhl:metaxml">
	  		<xsl:text>&#10;&#9;</xsl:text><xsl:copy-of select="dhl:metaxml"></xsl:copy-of>
	  	</xsl:if>
	  	<!-- //Metaxml -->
	  	
	  	<!-- failid -->
	  	<xsl:if test="dhl:failid">
	  		<xsl:text>&#10;&#9;</xsl:text><SignedDoc format="DIGIDOC-XML" version="1.3" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
	  				  
	  			<xsl:for-each select="dhl:failid/dhl:fail">
	  				<xsl:variable name="jrknr" select="dhl:jrknr" />
	  				<xsl:variable name="fail_pealkiri" select="dhl:fail_pealkiri" />
	  				<xsl:variable name="fail_suurus" select="dhl:fail_suurus" />
	  				<xsl:variable name="fail_tyyp" select="dhl:fail_tyyp" />
	  				<xsl:variable name="fail_nimi" select="dhl:fail_nimi" />
	  				<xsl:variable name="zip_base64_sisu" select="dhl:zip_base64_sisu" />
	  				<xsl:variable name="krypteering" select="dhl:krypteering" />
	  				<xsl:variable name="pohi_dokument" select="dhl:pohi_dokument" />
	  				<xsl:variable name="pohi_dokument_konteineris" select="dhl:pohi_dokument_konteineris" />
	  				
	  				<xsl:text>&#10;&#9;&#9;</xsl:text>
	  				<xsl:element name="DataFile">
	  					<xsl:attribute name="ContentType">EMBEDDED_BASE64</xsl:attribute>
	  					<xsl:attribute name="Filename"><xsl:value-of select="$fail_nimi" /></xsl:attribute>
	  					<xsl:attribute name="Id"><xsl:value-of select="dhl-custom:getDataFileID($jrknr)" /></xsl:attribute>
	  					<xsl:attribute name="MimeType"><xsl:value-of select="$fail_tyyp" /></xsl:attribute>
	  					<xsl:attribute name="Size"><xsl:value-of select="$fail_suurus" /></xsl:attribute>
	  					<xsl:value-of select="dhl-custom:unzip($zip_base64_sisu)" />
	  					<xsl:text>&#10;&#9;&#9;</xsl:text>
	  				</xsl:element>
	  					
	  			</xsl:for-each>
	  			
	  		<xsl:text>&#10;&#9;</xsl:text></SignedDoc>
	  	</xsl:if>
	  	<!-- //failid -->
	  	
  	</dhl:dokument>
  </xsl:template>
  
</xsl:stylesheet> 