<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:src="http://www.riik.ee/schemas/deccontainer/vers_2_1/"
                xmlns:dhl="http://www.riik.ee/schemas/dhl"
                xmlns:rkel="http://www.riik.ee/schemas/dhl/rkel_letter"
                xmlns:mm="http://www.riik.ee/schemas/dhl-meta-manual"
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:dhl-custom="dhl.xslt.CustomFunctions"
                exclude-result-prefixes="src xalan dhl-custom">

    <xsl:output
            method="xml"
            encoding="UTF-8"
            indent="yes"/>


    <xsl:template match="src:DecContainer">
        <dhl:dokument>

            <!-- Metainfo -->
            <dhl:metainfo>
                <mm:koostaja_asutuse_nr>
                    <xsl:call-template name="alternative">
                        <xsl:with-param name="primeValue" select="src:RecordCreator/src:Organisation/src:OrganisationCode"/>
                        <xsl:with-param name="value1" select="src:RecordSenderToDec/src:Organisation/src:OrganisationCode"/>
                        <xsl:with-param name="value2" select="src:RecordCreator/src:Organisation/src:Name"/>
                    </xsl:call-template>
                </mm:koostaja_asutuse_nr>
                <mm:saaja_asutuse_nr>
                    <xsl:value-of select="src:Recipient/src:Organisation/src:OrganisationCode"/>
                </mm:saaja_asutuse_nr>
                <mm:koostaja_dokumendinimi>
                    <xsl:value-of select="src:RecordMetadata/src:RecordTitle"/>
                </mm:koostaja_dokumendinimi>
                <mm:koostaja_dokumendityyp>
                    <xsl:value-of select="src:RecordMetadata/src:RecordType"/>
                </mm:koostaja_dokumendityyp>
                <mm:koostaja_dokumendinr>
                    <xsl:value-of select="src:RecordMetadata/src:RecordOriginalIdentifier"/>
                </mm:koostaja_dokumendinr>
                <mm:koostaja_kokkuvote>
                    <xsl:call-template name="alternative">
                        <xsl:with-param name="primeValue" select="src:Recipient/src:MessageForRecipient"/>
                        <xsl:with-param name="value1" select="src:RecordMetadata/src:RecordAbstract"/>
                    </xsl:call-template>
                </mm:koostaja_kokkuvote>
                <mm:koostaja_kuupaev>
                    <xsl:value-of select="src:RecordMetadata/src:RecordDateRegistered"/>
                </mm:koostaja_kuupaev>
                <mm:koostaja_asutuse_nimi>
                    <xsl:call-template name="alternative">
                        <xsl:with-param name="primeValue" select="src:RecordCreator/src:Organisation/src:Name"/>
                        <xsl:with-param name="value1" select="src:RecordSenderToDec/src:Organisation/src:Name"/>
                    </xsl:call-template>
                </mm:koostaja_asutuse_nimi>
                <mm:autori_osakond>
                    <xsl:call-template name="alternative">
                        <xsl:with-param name="primeValue"
                                        select="src:RecordCreator/src:Organisation/src:StructuralUnit"/>
                        <xsl:with-param name="value1"
                                        select="src:RecordSenderToDec/src:Organisation/src:StructuralUnit"/>
                    </xsl:call-template>
                </mm:autori_osakond>
                <mm:autori_isikukood>
                    <xsl:call-template name="alternative">
                        <xsl:with-param name="primeValue" select="src:RecordCreator/src:Person/src:PersonalIdCode"/>
                        <xsl:with-param name="value1" select="src:RecordSenderToDec/src:Person/src:PersonalIdCode"/>
                    </xsl:call-template>
                </mm:autori_isikukood>
                <mm:autori_nimi>
                    <xsl:call-template name="alternative">
                        <xsl:with-param name="primeValue" select="src:RecordCreator/src:Person/src:Name"/>
                        <xsl:with-param name="value1" select="src:RecordSenderToDec/src:Person/src:Name"/>
                    </xsl:call-template>
                </mm:autori_nimi>
                <mm:seotud_dokumendinr_koostajal>
                    <xsl:value-of select="src:RecordMetadata/src:RecordOriginalIdentifier"/>
                </mm:seotud_dokumendinr_koostajal>
                <mm:seotud_dokumendinr_saajal>
                    <xsl:value-of select="src:Recipient/src:RecipientRecordOriginalIdentifier"/>
                </mm:seotud_dokumendinr_saajal>
                <mm:saaja_isikukood>
                    <xsl:value-of select="src:Recipient/src:Person/src:PersonalIdCode"/>
                </mm:saaja_isikukood>
                <mm:saaja_nimi>
                    <xsl:value-of select="src:Recipient/src:Person/src:Name"/>
                </mm:saaja_nimi>
                <mm:saaja_osakond>
                    <xsl:value-of select="src:Recipient/src:Organisation/src:StructuralUnit"/>
                </mm:saaja_osakond>
            </dhl:metainfo>
            <!-- //Metainfo -->

            <!-- Transport -->
            <xsl:apply-templates select="src:Transport"/>
            <!-- //Transport -->

            <!-- Metaxml -->
            <dhl:metaxml>
                <xsl:apply-templates select="src:RecordCreator"/>
                <xsl:apply-templates select="src:Recipient"/>
                <xsl:apply-templates select="src:RecordMetadata"/>
                <xsl:apply-templates select="src:SignatureMetadata"/>
            </dhl:metaxml>
            <!-- //Metaxml -->

             <SignedDoc xmlns="http://www.sk.ee/DigiDoc/v1.3.0#" format="DIGIDOC-XML" version="1.3">
                 <xsl:apply-templates select="src:File"/>
             </SignedDoc>

        </dhl:dokument>
    </xsl:template>


    <xsl:template name="alternative">
        <xsl:param name="primeValue"/>
        <xsl:param name="value1"/>
        <xsl:param name="value2" select="''"/>
        <xsl:choose>
            <xsl:when test="$primeValue">
                <xsl:value-of select="$primeValue"/>
            </xsl:when>
            <xsl:when test="$value1">
                <xsl:value-of select="$value1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="src:Transport">
        <dhl:transport>
            <xsl:apply-templates select="*"/>
        </dhl:transport>
    </xsl:template>

    <xsl:template match="src:DecSender">
        <dhl:saatja>
            <xsl:call-template name="aadressType"/>
        </dhl:saatja>
    </xsl:template>

    <xsl:template match="src:DecRecipient">
        <dhl:saaja>
            <xsl:call-template name="aadressType"/>
        </dhl:saaja>
    </xsl:template>

    <xsl:template name="aadressType">
        <dhl:regnr>
            <xsl:value-of select="src:OrganisationCode"/>
        </dhl:regnr>
        <dhl:allyksuse_nimetus>
            <xsl:value-of select="src:StructuralUnit"/>
        </dhl:allyksuse_nimetus>
        <dhl:isikukood>
            <xsl:value-of select="src:PersonalIdCode"/>
        </dhl:isikukood>
    </xsl:template>

    <xsl:template match="src:RecordCreator">
        <rkel:Author>
            <xsl:choose>
                <xsl:when test="src:Organisation">
                    <xsl:apply-templates select="src:Organisation"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="../src:RecordSenderToDec/src:Organisation"/>
                </xsl:otherwise>
            </xsl:choose>
        </rkel:Author>
        <xsl:choose>
            <xsl:when test="src:Person">
                <xsl:apply-templates select="src:Person">
                    <xsl:with-param name="person" select="'Compilator'"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="../src:RecordSenderToDec/src:Person">
                    <xsl:with-param name="person" select="'Compilator'"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="src:Organisation">
        <rkel:Organisation>
            <rkel:organisationName>
                <xsl:apply-templates select="src:Name"/>
            </rkel:organisationName>
            <rkel:departmentName>
                <xsl:apply-templates select="src:StructuralUnit"/>
            </rkel:departmentName>
        </rkel:Organisation>
    </xsl:template>

    <xsl:template match="src:RecordCreator/*/*">
        <xsl:variable name="nodeName" select="name()"/>
        <xsl:choose>
            <xsl:when test=".">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="//src:RecordSenderToDec//*[name()=$nodeName]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="src:Recipient/*/* |src:RecordSenderToDec/*/*">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="src:Person">
        <xsl:param name="person"/>
        <xsl:element name="rkel:{$person}">
            <rkel:jobtitle>
                <xsl:apply-templates select="../src:Organisation/src:PositionTitle"/>
            </rkel:jobtitle>
            <xsl:element name="rkel:firstname">
                <xsl:apply-templates select="src:GivenName"/>
            </xsl:element>
            <xsl:element name="rkel:surname">
                <xsl:apply-templates select="src:Surname"/>
            </xsl:element>
            <xsl:element name="rkel:telephone">
                <xsl:apply-templates select="../src:ContactData/src:Phone"/>
            </xsl:element>
            <xsl:element name="rkel:email">
                <xsl:apply-templates select="../src:ContactData/src:Email"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="src:Recipient">
        <rkel:Addressees>
            <rkel:Addressee>
                <xsl:apply-templates select="src:Organisation"/>
                <xsl:apply-templates select="src:Person">
                    <xsl:with-param name="person" select="'Person'"/>
                </xsl:apply-templates>
            </rkel:Addressee>
        </rkel:Addressees>
    </xsl:template>

    <xsl:template match="src:RecordMetadata">
        <rkel:LetterMetaData>
            <rkel:OriginalIdentifier>
                <xsl:value-of select="../src:Recipient/src:RecipientRecordOriginalIdentifier"/>
            </rkel:OriginalIdentifier>
            <rkel:Type>
                <xsl:value-of select="src:RecordType"/>
            </rkel:Type>
            <rkel:SenderIdentifier>
                <xsl:value-of select="src:RecordOriginalIdentifier"/>
            </rkel:SenderIdentifier>
            <rkel:SignDate>
                <xsl:value-of select="src:RecordDateRegistered"/>
            </rkel:SignDate>
            <rkel:Title>
                <xsl:value-of select="src:RecordTitle"/>
            </rkel:Title>
            <rkel:Language>
                <xsl:value-of select="src:RecordLanguage"/>
            </rkel:Language>
            <rkel:Deadline>
                <xsl:value-of select="src:ReplyDueDate"/>
            </rkel:Deadline>
            <xsl:apply-templates select="../src:Access"/>
        </rkel:LetterMetaData>
    </xsl:template>

    <xsl:template match="src:Access">
        <rkel:AccessRights>
            <rkel:Restriction>
                <xsl:value-of select="src:AccessConditionsCode"/>
            </rkel:Restriction>
            <rkel:BeginDate>
                <xsl:value-of select="src:RestrictionBeginDate"/>
            </rkel:BeginDate>
            <rkel:EndDate>
                <xsl:value-of select="src:RestrictionEndDate"/>
            </rkel:EndDate>
            <rkel:Reason>
                <xsl:value-of select="src:RestrictionBasis"/>
            </rkel:Reason>
        </rkel:AccessRights>
    </xsl:template>

    <xsl:template match="src:SignatureMetadata">
        <rkel:Signatures>
            <rkel:SignatureData>
                <rkel:SignatureDate>
                    <xsl:value-of select="src:SignatureVerificationDate"/>
                </rkel:SignatureDate>
                <rkel:SignatureTime>
                    <xsl:value-of select="src:SignatureVerificationDate"/>
                </rkel:SignatureTime>
            </rkel:SignatureData>
        </rkel:Signatures>
    </xsl:template>

    <xsl:template match="src:File" xmlns="http://www.sk.ee/DigiDoc/v1.3.0#">
        <xsl:variable name="zip_base64_sisu" select="src:ZipBase64Content" />
        <xsl:element name="DataFile">
            <xsl:attribute name="ContentType">EMBEDDED_BASE64</xsl:attribute>
            <xsl:attribute name="Filename">
                <xsl:value-of select="src:FileName"/>
            </xsl:attribute>
            <xsl:attribute name="Id">
                <xsl:value-of select="concat('D',(position() - 1))"/>
            </xsl:attribute>
            <xsl:attribute name="MimeType">
                <xsl:value-of select="src:MimeType"/>
            </xsl:attribute>
            <xsl:attribute name="Size">
                <xsl:value-of select="src:FileSize"/>
            </xsl:attribute>
            <xsl:value-of select="dhl-custom:unzip($zip_base64_sisu)" />
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>