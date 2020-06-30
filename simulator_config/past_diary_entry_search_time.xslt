<!-- detects diary searches in the past -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir">
    <xsl:output method="xml" />
	<xsl:template match="/">
		<xsl:variable name="now" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
        <xsl:choose>
			<xsl:when test="/fhir:Parameters/fhir:parameter[fhir:name/@value='includeDiaryEntries']/fhir:part[fhir:name/@value='diaryEntriesSearchDate']/fhir:valueDate/@value &lt; $now">
                <xsl:value-of select="'TRUE'" />
			</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'FALSE'" />
			</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
