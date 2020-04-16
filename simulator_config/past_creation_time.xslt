<!-- detects JWT creation timestamps that are in the past -->
<!-- document context is the xml transformed version of the json JWT payload  -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:json="org.warlock.jsonconverter.JsonXmlConverter">
    <xsl:output method="xml" />
	<xsl:template match="/">
		<!-- get the string from the appropriate TKW listener service -->
		<xsl:variable name="epoch" select="document('http://127.0.0.1:8000/getepoch')"/>
		<xsl:if test="not ($epoch)">
			<xsl:message>WARNING: empty epoch (is epoch server running on port 8000?)</xsl:message>
		</xsl:if>
        <xsl:choose>
			<xsl:when test="/json:json/@iat &lt; ($epoch - 5)">
                <xsl:value-of select="'TRUE'" />
			</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'FALSE'" />
			</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
