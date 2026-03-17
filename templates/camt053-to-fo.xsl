<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:camt="urn:iso:std:iso:20022:tech:xsd:camt.053.001.02"
                exclude-result-prefixes="camt">

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="lang" select="'en'"/>
    <xsl:variable name="i18n" select="document(concat('../i18n/', $lang, '.xml'))/translations"/>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin="1cm">
                    <fo:region-body margin-top="2cm" margin-bottom="2cm"/>
                    <fo:region-before extent="2cm"/>
                    <fo:region-after extent="1cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="A4">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="50mm"/>
                        <fo:table-column column-width="140mm"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell display-align="center">
                                    <fo:block>
                                        <fo:external-graphic src="url('../assets/logo.svg')" content-height="15mm" scaling="uniform"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell display-align="center">
                                    <fo:block font-size="18pt" font-weight="bold" text-align="right">
                                        <xsl:value-of select="$i18n/title"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>

                <fo:static-content flow-name="xsl-region-after">
                    <fo:block font-size="8pt" text-align="center">
                        <xsl:value-of select="$i18n/page"/>
                        <xsl:text> </xsl:text>
                        <fo:page-number/>
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates select="//camt:Stmt"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="camt:Stmt">
        <xsl:if test="camt:Acct/camt:Ownr">
            <fo:block font-size="10pt" space-after="5mm">
                <fo:block font-weight="bold"><xsl:value-of select="$i18n/account_holder"/></fo:block>
                <fo:block><xsl:value-of select="camt:Acct/camt:Ownr/camt:Nm"/></fo:block>
                <fo:block>
                    <xsl:value-of select="camt:Acct/camt:Ownr/camt:PstlAdr/camt:StrtNm"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="camt:Acct/camt:Ownr/camt:PstlAdr/camt:BldgNb"/>
                </fo:block>
                <fo:block>
                    <xsl:value-of select="camt:Acct/camt:Ownr/camt:PstlAdr/camt:PstCd"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="camt:Acct/camt:Ownr/camt:PstlAdr/camt:TwnNm"/>
                </fo:block>
            </fo:block>
        </xsl:if>

        <fo:block font-size="12pt" space-after="5mm">
            <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="50%"/>
                <fo:table-column column-width="50%"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-weight="bold"><xsl:value-of select="$i18n/iban"/></fo:block>
                            <fo:block><xsl:value-of select="camt:Acct/camt:Id/camt:IBAN"/></fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block font-weight="bold"><xsl:value-of select="$i18n/currency"/></fo:block>
                            <fo:block><xsl:value-of select="camt:Acct/camt:Ccy"/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>

        <fo:block font-size="10pt" space-after="5mm">
            <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
                <fo:table-column column-width="40%"/>
                <fo:table-column column-width="30%"/>
                <fo:table-column column-width="30%"/>
                <fo:table-header background-color="#f0f0f0">
                    <fo:table-row>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/balance_type"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold"><xsl:value-of select="$i18n/date"/></fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold"><xsl:value-of select="$i18n/amount"/></fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <xsl:for-each select="camt:Bal">
                        <fo:table-row keep-together.within-page="always">
                            <fo:table-cell border="0.5pt solid black" padding="2pt">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="camt:Tp/camt:CdOrPrtry/camt:Cd = 'OPBD'"><xsl:value-of select="$i18n/opening_balance"/></xsl:when>
                                        <xsl:when test="camt:Tp/camt:CdOrPrtry/camt:Cd = 'CLBD'"><xsl:value-of select="$i18n/closing_balance"/></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="camt:Tp/camt:CdOrPrtry/camt:Cd"/></xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="0.5pt solid black" padding="2pt">
                                <fo:block><xsl:value-of select="camt:Dt/camt:Dt"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right">
                                <fo:block><xsl:value-of select="camt:Amt"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </fo:block>

        <fo:block font-size="10pt">
            <fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
                <fo:table-column column-width="15%"/>
                <fo:table-column column-width="15%"/>
                <fo:table-column column-width="40%"/>
                <fo:table-column column-width="15%"/>
                <fo:table-column column-width="15%"/>
                <fo:table-header background-color="#f0f0f0">
                    <fo:table-row>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold">Booking Date</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold">Value Date</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold">Details</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold">Debit</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold">Credit</fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <xsl:for-each select="camt:Ntry">
                        <fo:table-row keep-together.within-page="always">
                            <fo:table-cell border="0.5pt solid black" padding="2pt">
                                <fo:block><xsl:value-of select="camt:BookgDt/camt:Dt"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="0.5pt solid black" padding="2pt">
                                <fo:block><xsl:value-of select="camt:ValDt/camt:Dt"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="0.5pt solid black" padding="2pt">
                                <fo:block font-weight="bold">
                                    <xsl:choose>
                                        <xsl:when test="camt:CdtDbtInd = 'CRDT'">
                                            <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Dbtr/camt:Nm"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:Cdtr/camt:Nm"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                                <fo:block font-size="8pt">
                                    <xsl:choose>
                                        <xsl:when test="camt:CdtDbtInd = 'CRDT'">
                                            <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:DbtrAcct/camt:Id/camt:IBAN"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:RltdPties/camt:CdtrAcct/camt:Id/camt:IBAN"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                                <fo:block font-size="9pt" font-style="italic">
                                    <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:RmtInf/camt:Ustrd"/>
                                </fo:block>
                                <xsl:if test="camt:NtryDtls/camt:TxDtls/camt:Refs/camt:EndToEndId">
                                    <fo:block font-size="8pt" color="#333333">
                                        <xsl:value-of select="$i18n/ref"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:Refs/camt:EndToEndId"/>
                                    </fo:block>
                                </xsl:if>
                                <xsl:if test="camt:NtryDtls/camt:TxDtls/camt:AmtDtls/camt:InstdAmt/camt:Amt">
                                    <fo:block font-size="8pt" color="gray" space-before="1mm">
                                        <xsl:value-of select="$i18n/original_amount"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:AmtDtls/camt:InstdAmt/camt:Amt"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:AmtDtls/camt:InstdAmt/camt:Amt/@Ccy"/>
                                        <xsl:if test="camt:NtryDtls/camt:TxDtls/camt:CcyXchg/camt:XchgRate">
                                            (<xsl:value-of select="$i18n/rate"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:CcyXchg/camt:XchgRate"/>)
                                        </xsl:if>
                                    </fo:block>
                                </xsl:if>
                            </fo:table-cell>
                            <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right">
                                <fo:block>
                                    <xsl:if test="camt:CdtDbtInd = 'DBIT'">
                                        <xsl:value-of select="camt:Amt"/>
                                    </xsl:if>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right">
                                <fo:block>
                                    <xsl:if test="camt:CdtDbtInd = 'CRDT'">
                                        <xsl:value-of select="camt:Amt"/>
                                    </xsl:if>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>
