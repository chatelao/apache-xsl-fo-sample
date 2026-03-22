<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:eCH-0196="http://www.ech.ch/xmlns/eCH-0196/2"
                xmlns:bc="http://barcode4j.krysalis.org/ns"
                exclude-result-prefixes="eCH-0196 bc">

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="lang" select="'en'"/>
    <xsl:variable name="i18n" select="document(concat('../i18n/', $lang, '.xml'))/translations"/>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <!-- Master for Odd pages -->
                <fo:simple-page-master master-name="A4-odd" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="2.5cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="2.5cm"/>
                    <fo:region-after extent="1.5cm"/>
                    <fo:region-start region-name="omr-odd" extent="1.5cm"/>
                </fo:simple-page-master>

                <!-- Master for Even pages -->
                <fo:simple-page-master master-name="A4-even" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="2.5cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="2.5cm"/>
                    <fo:region-after extent="1.5cm"/>
                    <fo:region-start region-name="omr-even" extent="1.5cm"/>
                </fo:simple-page-master>

                <!-- Master for Last Odd page -->
                <fo:simple-page-master master-name="A4-last-odd" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="2.5cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="2.5cm"/>
                    <fo:region-after extent="1.5cm"/>
                    <fo:region-start region-name="omr-last-odd" extent="1.5cm"/>
                </fo:simple-page-master>

                <!-- Master for Last Even page -->
                <fo:simple-page-master master-name="A4-last-even" page-height="29.7cm" page-width="21cm" margin="0.5cm">
                    <fo:region-body margin-top="2.5cm" margin-bottom="2cm" margin-left="1.5cm"/>
                    <fo:region-before extent="2.5cm"/>
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

            <xsl:apply-templates select="//eCH-0196:taxStatement"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="eCH-0196:taxStatement">
        <xsl:variable name="stmtId" select="generate-id(.)"/>
        <fo:page-sequence master-reference="A4-alternating">
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
                                <fo:block text-align="right">
                                    <fo:instream-foreign-object width="20mm" height="20mm" content-width="20mm" content-height="20mm">
                                        <bc:barcode>
                                            <bc:datamatrix>
                                                <bc:module-width>0.5mm</bc:module-width>
                                                <bc:message>
                                                    <xsl:value-of select="@id"/>
                                                </bc:message>
                                            </bc:datamatrix>
                                        </bc:barcode>
                                    </fo:instream-foreign-object>
                                </fo:block>
                                <fo:block font-size="18pt" font-weight="bold" text-align="right">
                                    <xsl:value-of select="$i18n/tax_statement_title"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>

            <!-- OMR marks -->
            <fo:static-content flow-name="omr-odd">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="112mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
            </fo:static-content>
            <fo:static-content flow-name="omr-even">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
            </fo:static-content>
            <fo:static-content flow-name="omr-last-odd">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="112mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="108mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
            </fo:static-content>
            <fo:static-content flow-name="omr-last-even">
                <fo:block-container absolute-position="absolute" left="5mm" top="100mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="104mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
                <fo:block-container absolute-position="absolute" left="5mm" top="108mm" width="5mm" height="0.5mm" background-color="black"><fo:block/></fo:block-container>
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
                <fo:block id="{$stmtId}-start"/>

                <!-- Header Information -->
                <fo:block font-size="10pt" space-after="5mm">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="50%"/>
                        <fo:table-column column-width="50%"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block font-weight="bold"><xsl:value-of select="$i18n/institution"/></fo:block>
                                    <fo:block><xsl:value-of select="eCH-0196:institution/@name"/></fo:block>
                                    <xsl:if test="eCH-0196:institution/@lei">
                                        <fo:block font-size="8pt">LEI: <xsl:value-of select="eCH-0196:institution/@lei"/></fo:block>
                                    </xsl:if>
                                </fo:table-cell>
                                <fo:table-cell text-align="right">
                                    <fo:block font-weight="bold"><xsl:value-of select="$i18n/tax_period"/></fo:block>
                                    <fo:block><xsl:value-of select="@taxPeriod"/></fo:block>
                                    <fo:block font-size="8pt">(<xsl:value-of select="@periodFrom"/> - <xsl:value-of select="@periodTo"/>)</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:block>

                <!-- Client Information -->
                <fo:block font-size="10pt" space-after="5mm">
                    <fo:block font-weight="bold"><xsl:value-of select="$i18n/client"/></fo:block>
                    <xsl:for-each select="eCH-0196:client">
                        <fo:block>
                            <xsl:value-of select="@firstName"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@lastName"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="$i18n/client_number"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@clientNumber"/>
                            <xsl:text>)</xsl:text>
                        </fo:block>
                    </xsl:for-each>
                </fo:block>

                <!-- Accompanying Letter -->
                <xsl:if test="eCH-0196:accompanyingLetter">
                    <fo:block font-size="10pt" space-after="5mm" border="0.5pt solid gray" padding="2pt">
                        <fo:block font-style="italic">Accompanying letter: <xsl:value-of select="eCH-0196:accompanyingLetter/@fileName"/></fo:block>
                    </fo:block>
                </xsl:if>

                <!-- List of Bank Accounts -->
                <xsl:if test="eCH-0196:listOfBankAccounts">
                    <fo:block font-size="12pt" font-weight="bold" space-after="2mm"><xsl:value-of select="$i18n/list_of_bank_accounts"/></fo:block>
                    <fo:block font-size="9pt" space-after="5mm">
                        <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
                            <fo:table-column column-width="40%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-header background-color="#f0f0f0">
                                <fo:table-row>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/account_name"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/tax_value"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/gross_revenue_a"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/gross_revenue_b"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/withholding_tax_claim"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                            <fo:table-body>
                                <xsl:for-each select="eCH-0196:listOfBankAccounts/eCH-0196:bankAccount">
                                    <fo:table-row>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="@bankAccountName"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="@totalTaxValue"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="@totalGrossRevenueA"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="@totalGrossRevenueB"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="@totalWithHoldingTaxClaim"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                </xsl:for-each>
                                <fo:table-row font-weight="bold" background-color="#eeeeee">
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="$i18n/total"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfBankAccounts/@totalTaxValue"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfBankAccounts/@totalGrossRevenueA"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfBankAccounts/@totalGrossRevenueB"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfBankAccounts/@totalWithHoldingTaxClaim"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block>
                </xsl:if>

                <!-- List of Liabilities -->
                <xsl:if test="eCH-0196:listOfLiabilities">
                    <fo:block font-size="12pt" font-weight="bold" space-after="2mm" space-before="5mm"><xsl:value-of select="$i18n/list_of_liabilities"/></fo:block>
                    <fo:block font-size="9pt" space-after="5mm">
                        <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
                            <fo:table-column column-width="55%"/>
                            <fo:table-column column-width="22.5%"/>
                            <fo:table-column column-width="22.5%"/>
                            <fo:table-header background-color="#f0f0f0">
                                <fo:table-row>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/account_name"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/tax_value"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/gross_revenue_b"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                            <fo:table-body>
                                <xsl:for-each select="eCH-0196:listOfLiabilities/eCH-0196:liabilityAccount">
                                    <fo:table-row>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="@bankAccountName"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="@totalTaxValue"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="@totalGrossRevenueB"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                </xsl:for-each>
                                <fo:table-row font-weight="bold" background-color="#eeeeee">
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="$i18n/total"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfLiabilities/@totalTaxValue"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfLiabilities/@totalGrossRevenueB"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block>
                </xsl:if>

                <!-- List of Expenses -->
                <xsl:if test="eCH-0196:listOfExpenses">
                    <fo:block font-size="12pt" font-weight="bold" space-after="2mm" space-before="5mm"><xsl:value-of select="$i18n/list_of_expenses"/></fo:block>
                    <fo:block font-size="9pt" space-after="5mm">
                        <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
                            <fo:table-column column-width="70%"/>
                            <fo:table-column column-width="30%"/>
                            <fo:table-header background-color="#f0f0f0">
                                <fo:table-row>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/description"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/amount"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                            <fo:table-body>
                                <xsl:for-each select="eCH-0196:listOfExpenses/eCH-0196:expense">
                                    <fo:table-row>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="@name"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="@expenses"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                </xsl:for-each>
                                <fo:table-row font-weight="bold" background-color="#eeeeee">
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="$i18n/total"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfExpenses/@totalExpenses"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block>
                </xsl:if>

                <!-- List of Securities -->
                <xsl:if test="eCH-0196:listOfSecurities">
                    <fo:block font-size="12pt" font-weight="bold" space-after="2mm" space-before="5mm"><xsl:value-of select="$i18n/list_of_securities"/></fo:block>
                    <fo:block font-size="9pt" space-after="5mm">
                        <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
                            <fo:table-column column-width="40%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-column column-width="15%"/>
                            <fo:table-header background-color="#f0f0f0">
                                <fo:table-row>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/security_name"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/tax_value"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/gross_revenue_a"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/gross_revenue_b"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/withholding_tax_claim"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                            <fo:table-body>
                                <xsl:for-each select="eCH-0196:listOfSecurities/eCH-0196:depot/eCH-0196:security">
                                    <fo:table-row>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="@securityName"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:taxValue/@value"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="sum(eCH-0196:payment/@grossRevenueA)"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="sum(eCH-0196:payment/@grossRevenueB)"/></fo:block></fo:table-cell>
                                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="sum(eCH-0196:payment/@withHoldingTaxClaim)"/></fo:block></fo:table-cell>
                                    </fo:table-row>
                                </xsl:for-each>
                                <fo:table-row font-weight="bold" background-color="#eeeeee">
                                    <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block><xsl:value-of select="$i18n/total"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfSecurities/@totalTaxValue"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfSecurities/@totalGrossRevenueA"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfSecurities/@totalGrossRevenueB"/></fo:block></fo:table-cell>
                                    <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block><xsl:value-of select="eCH-0196:listOfSecurities/@totalWithHoldingTaxClaim"/></fo:block></fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block>
                </xsl:if>

                <fo:block id="{$stmtId}-last-page"/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
</xsl:stylesheet>
