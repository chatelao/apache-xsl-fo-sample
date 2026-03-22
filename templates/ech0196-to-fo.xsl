<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:ech="http://www.ech.ch/xmlns/eCH-0196/2.2"
                xmlns:bc="http://barcode4j.krysalis.org/ns"
                exclude-result-prefixes="ech bc">

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="lang" select="'en'"/>
    <xsl:variable name="i18n" select="document(concat('../i18n/', $lang, '.xml'))/translations"/>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <!-- Master for Odd pages -->
                <fo:simple-page-master master-name="A4-odd" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="4cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="4cm"/>
                    <fo:region-after extent="1.5cm"/>
                    <fo:region-start region-name="omr-odd" extent="1.5cm"/>
                </fo:simple-page-master>

                <!-- Master for Even pages -->
                <fo:simple-page-master master-name="A4-even" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="4cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="4cm"/>
                    <fo:region-after extent="1.5cm"/>
                    <fo:region-start region-name="omr-even" extent="1.5cm"/>
                </fo:simple-page-master>

                <!-- Master for Last Odd page -->
                <fo:simple-page-master master-name="A4-last-odd" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="4cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="4cm"/>
                    <fo:region-after extent="1.5cm"/>
                    <fo:region-start region-name="omr-last-odd" extent="1.5cm"/>
                </fo:simple-page-master>

                <!-- Master for Last Even page -->
                <fo:simple-page-master master-name="A4-last-even" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="4cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="4cm"/>
                    <fo:region-after extent="1.5cm"/>
                    <fo:region-start region-name="omr-last-even" extent="1.5cm"/>
                </fo:simple-page-master>

                <fo:page-sequence-master master-name="A4-alternating">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="A4-last-odd" page-position="last" odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="A4-last-even" page-position="last" odd-or-even="even"/>
                        <fo:conditional-page-master-reference master-reference="A4-odd" odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="A4-even" odd-or-even="even"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
            </fo:layout-master-set>

            <xsl:apply-templates select="//ech:statement"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="ech:statement">
        <xsl:variable name="stmtId" select="generate-id(.)"/>
        <fo:page-sequence master-reference="A4-alternating">
            <!-- Common region-start for Odd pages -->
            <fo:static-content flow-name="omr-odd">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="112mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
            </fo:static-content>

            <!-- Common region-start for Even pages -->
            <fo:static-content flow-name="omr-even">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
            </fo:static-content>

            <!-- Common region-start for Last Odd page -->
            <fo:static-content flow-name="omr-last-odd">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="112mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="108mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
            </fo:static-content>

            <!-- Common region-start for Last Even page -->
            <fo:static-content flow-name="omr-last-even">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="108mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
            </fo:static-content>

            <fo:static-content flow-name="xsl-region-before">
                <fo:table table-layout="fixed" width="100%" margin-left="1.5cm">
                    <fo:table-column column-width="50mm"/>
                    <fo:table-column column-width="125mm"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell display-align="center">
                                <fo:block>
                                    <fo:external-graphic src="url('../assets/logo.svg')" content-height="15mm" scaling="uniform"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-size="16pt" font-weight="bold" text-align="right" color="#444444">
                                    <xsl:value-of select="$i18n/tax_statement_title"/>
                                </fo:block>
                                <fo:block font-size="12pt" text-align="right" space-before="2mm">
                                    <xsl:value-of select="ech:institution/ech:name"/>
                                </fo:block>
                                <fo:block text-align="right" space-before="2mm">
                                    <fo:instream-foreign-object width="40mm" height="10mm" content-width="40mm" content-height="10mm">
                                        <bc:barcode>
                                            <xsl:attribute name="message">
                                                <xsl:text>19622</xsl:text>
                                                <xsl:text>00000</xsl:text>
                                                <xsl:variable name="pageNum">
                                                    <fo:page-number/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="string-length($pageNum) = 1">00<xsl:value-of select="$pageNum"/></xsl:when>
                                                    <xsl:when test="string-length($pageNum) = 2">0<xsl:value-of select="$pageNum"/></xsl:when>
                                                    <xsl:otherwise><xsl:value-of select="$pageNum"/></xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:text>011</xsl:text>
                                            </xsl:attribute>
                                            <bc:code128>
                                                <bc:height>10mm</bc:height>
                                                <bc:module-width>0.25mm</bc:module-width>
                                            </bc:code128>
                                        </bc:barcode>
                                    </fo:instream-foreign-object>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>

            <fo:static-content flow-name="xsl-region-after">
                <fo:block font-size="8pt" text-align="center" margin-left="1.5cm">
                    <xsl:value-of select="$i18n/page"/>
                    <xsl:text> </xsl:text>
                    <fo:page-number/>
                    <xsl:text> / </xsl:text>
                    <fo:page-number-citation ref-id="{$stmtId}-last-page"/>
                </fo:block>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body">
                <fo:table table-layout="fixed" width="100%" space-after="10mm">
                    <fo:table-column column-width="100mm"/>
                    <fo:table-column column-width="75mm"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block font-size="10pt">
                                    <fo:block font-weight="bold" space-after="2mm"><xsl:value-of select="$i18n/client"/></fo:block>
                                    <fo:block><xsl:value-of select="ech:client/ech:name"/></fo:block>
                                    <fo:block><xsl:value-of select="ech:client/ech:address/ech:street"/></fo:block>
                                    <fo:block>
                                        <xsl:value-of select="ech:client/ech:address/ech:postCode"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ech:client/ech:address/ech:town"/>
                                    </fo:block>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block font-size="10pt">
                                    <fo:block font-weight="bold"><xsl:value-of select="$i18n/tax_period"/></fo:block>
                                    <fo:block space-after="2mm"><xsl:value-of select="ech:taxPeriod"/></fo:block>
                                    <fo:block font-weight="bold"><xsl:value-of select="$i18n/statement_id"/></fo:block>
                                    <fo:block><xsl:value-of select="ech:statementId"/></fo:block>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>

                <xsl:apply-templates select="ech:accountList"/>
                <xsl:apply-templates select="ech:securitiesList"/>

                <fo:block id="{$stmtId}-last-page"/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:template match="ech:accountList">
        <fo:block font-weight="bold" font-size="12pt" space-before="5mm" space-after="2mm">
            <xsl:value-of select="$i18n/list_of_bank_accounts"/>
        </fo:block>
        <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
            <fo:table-column column-width="50%"/>
            <fo:table-column column-width="10%"/>
            <fo:table-column column-width="20%"/>
            <fo:table-column column-width="20%"/>
            <fo:table-header background-color="#f0f0f0">
                <fo:table-row>
                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/account_number"/></fo:block></fo:table-cell>
                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/currency"/></fo:block></fo:table-cell>
                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/balance"/></fo:block></fo:table-cell>
                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/interest"/></fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each select="ech:account">
                    <fo:table-row>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="ech:accountNumber"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="ech:currency"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="format-number(ech:balanceClose, '#,##0.00')"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="format-number(ech:interestGross, '#,##0.00')"/></fo:block></fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="ech:securitiesList">
        <fo:block font-weight="bold" font-size="12pt" space-before="5mm" space-after="2mm">
            <xsl:value-of select="$i18n/list_of_securities"/>
        </fo:block>
        <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
            <fo:table-column column-width="15%"/>
            <fo:table-column column-width="35%"/>
            <fo:table-column column-width="10%"/>
            <fo:table-column column-width="20%"/>
            <fo:table-column column-width="20%"/>
            <fo:table-header background-color="#f0f0f0">
                <fo:table-row>
                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/isin"/></fo:block></fo:table-cell>
                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/description"/></fo:block></fo:table-cell>
                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/quantity"/></fo:block></fo:table-cell>
                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/market_value"/></fo:block></fo:table-cell>
                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/income"/></fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <xsl:for-each select="ech:security">
                    <fo:table-row>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="ech:isin"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="ech:description"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="ech:quantity"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="format-number(ech:marketValue, '#,##0.00')"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="format-number(ech:incomeGross, '#,##0.00')"/></fo:block></fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>
</xsl:stylesheet>
