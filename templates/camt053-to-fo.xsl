<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:camt="urn:iso:std:iso:20022:tech:xsd:camt.053.001.02"
                exclude-result-prefixes="camt">

    <xsl:output method="xml" indent="yes"/>

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
                    <fo:block font-size="18pt" font-weight="bold" text-align="center">
                        Account Statement (camt.053)
                    </fo:block>
                </fo:static-content>

                <fo:static-content flow-name="xsl-region-after">
                    <fo:block font-size="8pt" text-align="center">
                        Page <fo:page-number/>
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
                <fo:block font-weight="bold">Account Holder:</fo:block>
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
                            <fo:block font-weight="bold">IBAN:</fo:block>
                            <fo:block><xsl:value-of select="camt:Acct/camt:Id/camt:IBAN"/></fo:block>
                        </fo:table-cell>
                        <fo:table-cell text-align="right">
                            <fo:block font-weight="bold">Currency:</fo:block>
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
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold">Balance Type</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold">Date</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold">Amount</fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <xsl:for-each select="camt:Bal">
                        <fo:table-row keep-together.within-page="always">
                            <fo:table-cell border="0.5pt solid black" padding="2pt">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="camt:Tp/camt:CdOrPrtry/camt:Cd = 'OPBD'">Opening Balance</xsl:when>
                                        <xsl:when test="camt:Tp/camt:CdOrPrtry/camt:Cd = 'CLBD'">Closing Balance</xsl:when>
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
                <fo:table-column column-width="20%"/>
                <fo:table-column column-width="40%"/>
                <fo:table-column column-width="20%"/>
                <fo:table-column column-width="20%"/>
                <fo:table-header background-color="#f0f0f0">
                    <fo:table-row>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold">Status</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt"><fo:block font-weight="bold">Details</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold">Debit</fo:block></fo:table-cell>
                        <fo:table-cell border="0.5pt solid black" padding="2pt" text-align="right"><fo:block font-weight="bold">Credit</fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <xsl:for-each select="camt:Ntry">
                        <fo:table-row keep-together.within-page="always">
                            <fo:table-cell border="0.5pt solid black" padding="2pt">
                                <fo:block><xsl:value-of select="camt:Sts"/></fo:block>
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
                                        Ref: <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:Refs/camt:EndToEndId"/>
                                    </fo:block>
                                </xsl:if>
                                <xsl:if test="camt:NtryDtls/camt:TxDtls/camt:AmtDtls/camt:InstdAmt/camt:Amt">
                                    <fo:block font-size="8pt" color="gray" space-before="1mm">
                                        Original Amount: <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:AmtDtls/camt:InstdAmt/camt:Amt"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:AmtDtls/camt:InstdAmt/camt:Amt/@Ccy"/>
                                        <xsl:if test="camt:NtryDtls/camt:TxDtls/camt:CcyXchg/camt:XchgRate">
                                            (Rate: <xsl:value-of select="camt:NtryDtls/camt:TxDtls/camt:CcyXchg/camt:XchgRate"/>)
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
