<!--
	prints items from xml sds extract file
	this might be better done with group by
	see https://digital.nhs.uk/developer/api-catalogue/spine-directory-service-fhir
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://hl7.org/fhir" xmlns:nhsd="uk.nhs.digital">
	<xsl:output method="xml" omit-xml-declaration="yes"/>

	<xsl:param name="org"/> <!-- organisation ods code (m) -->
	<xsl:param name="int"/>  <!-- search only for devices that support this interaction (m) -->
	<xsl:param name="partykey"/> <!-- party key (o) -->
	<xsl:param name="morg"/>  <!-- managing (or ufacturing)? org (o) -->
	<xsl:param name="cp"/>  <!-- html encoded context path -->
	<xsl:param name="ep"/> <!-- endpoint details -->

	<xsl:variable name="debug" select="false()"/>

	<!-- =======================================================================================================================  -->
	<!-- Functions -->

	<!-- overcome the cache by making each request different-->
	<xsl:function name="nhsd:getuuid">
		<xsl:param name="s"/>
		<xsl:value-of select="document(concat('http://127.0.0.1:8000/getuuid?',$s))"/>
	</xsl:function>

	<!-- =======================================================================================================================  -->

	<xsl:template match="text()|@*"/>

	<!-- =======================================================================================================================  -->

	<xsl:template match="/">
		<Bundle>
			<!-- the context changes inside a for loop so we have to remember the original context and use that -->
			<xsl:variable name="org_entries" select="/reference/entry[@nacs=$org]"/>

			<id value="{nhsd:getuuid('bundle')}"/>
			<type value="searchset"/>
			<xsl:variable name="asids" select="distinct-values(/reference/entry[@nacs=$org]/@asid)"/>
			<total value="{count($org_entries[$int=@soapaction])}"/>

		   <link>
			  <relation value="self"/>
			  <url value="{concat($ep,$cp)}"/>
		   </link>

			<xsl:for-each select="$asids">
				<xsl:variable name="asid" select="."/>
				<xsl:if test="$debug and not($org_entries[@asid=$asid and $int=@soapaction])">
					<xsl:message>exclude <xsl:value-of select="$asid"/></xsl:message>
				</xsl:if>
				<xsl:if test="$org_entries[@asid=$asid and $int=@soapaction]">
					<xsl:if test="$debug">
						<xsl:message>include <xsl:value-of select="$asid"/></xsl:message>
					</xsl:if>
					<entry>
						<fullUrl value="{concat($ep,'/Device/',nhsd:getuuid(concat('device',position())))}"/>
						<resource>
							<Device>
								<id value="{nhsd:getuuid(concat('device',position()))}"/>
								<extension url="https://fhir.nhs.uk/StructureDefinition/Extension-SDS-ManufacturingOrganisation">
								   <valueReference>
									  <identifier>
										 <system value="https://fhir.nhs.uk/Id/ods-organization-code"></system>
										 <value value="{$org}"></value>
									  </identifier>
								   </valueReference>
								</extension>

								<xsl:apply-templates select="$org_entries[@asid=$asid]"/>

								<identifier>
								   <system value="https://fhir.nhs.uk/Id/nhsSpineASID"></system>
								   <value value="{$asid}"></value>
							   </identifier>

							   <xsl:variable name="pk" select="distinct-values($org_entries/@partykey)"/>

								<identifier>
								  <system value="https://fhir.nhs.uk/Id/nhsMhsPartyKey"></system>
								  <value value="{$pk}"></value>
								</identifier>

								<owner>
								   <identifier>
									  <system value="https://fhir.nhs.uk/Id/ods-organization-code"></system>
									  <value value="{$org}"></value>
								   </identifier>
								</owner>

							</Device>
						</resource>
						<search>
							<mode value="match"/>
						</search>
					</entry>
				</xsl:if>
			</xsl:for-each>
		</Bundle>
	</xsl:template>

	<!-- ===========================================================================================  -->

	<xsl:template  match="/reference/entry">
		 <extension url="https://fhir.nhs.uk/StructureDefinition/Extension-SDS-NhsServiceInteractionId">
			 <valueReference>
				 <identifier>
					 <system value="https://fhir.nhs.uk/Id/nhsServiceInteractionId"></system>
					 <value value="{@soapaction}"></value>
				 </identifier>
			 </valueReference>
		 </extension>
	</xsl:template>

	<!-- ===========================================================================================  -->

</xsl:stylesheet>
