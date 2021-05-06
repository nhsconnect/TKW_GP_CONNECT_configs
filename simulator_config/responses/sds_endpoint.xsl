<!--
	prints items from xml sds extract file
	this might be better done with group by
	see https://digital.nhs.uk/developer/api-catalogue/spine-directory-service-fhir
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://hl7.org/fhir" xmlns:nhsd="uk.nhs.digital">
	<xsl:output method="xml" omit-xml-declaration="yes"/>

	<xsl:param name="org"/> <!-- sds code or org (m)-->
	<xsl:param name="int"/> <!-- interaction id (c) one or the other or both -->
	<xsl:param name="pk"/> <!-- party key (c)  one or the other or both -->
	<xsl:param name="cp"/>  <!-- html encoded context path -->
	<xsl:param name="ep"/> <!-- endpoint details -->

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
			<xsl:variable name="entries" select="$org_entries[$int=@soapaction or $pk=@partykey]"/>
			<total value="{count($entries)}"/>

		   <link>
		      <relation value="self"/>
			  <url value="{concat($ep, $cp)}"/>
   			</link>

			<xsl:for-each select="$entries">
				<xsl:variable name="entry" select="."/>
						<entry>
							<fullUrl value="{concat($ep, '/Endpoint/', nhsd:getuuid(concat('endpoint',position())))}"/>
							<resource>
								<Endpoint>
									<id value="{nhsd:getuuid(concat('endpoint',position()))}"></id>
									<extension url="https://fhir.nhs.uk/StructureDefinition/Extension-SDS-ReliabilityConfiguration">
									   <extension url="nhsMHSSyncReplyMode">
										  <valueString value="{$entry/@syncReply}"></valueString>
									   </extension>
									   <extension url="nhsMHSRetryInterval">
										  <valueString value="PT1M"></valueString>
									   </extension>
									   <extension url="nhsMHSRetries">
										  <valueInteger value="2"></valueInteger>
									   </extension>
									   <extension url="nhsMHSPersistDuration">
										  <valueString value="PT5M"></valueString>
									   </extension>
									   <extension url="nhsMHSDuplicateElimination">
										   <valueString value="{$entry/@dupElim}"></valueString>
									   </extension>
									   <extension url="nhsMHSAckRequested">
										  <valueString value="{$entry/@ackRq}"></valueString>
									   </extension>
									</extension>
									 <extension url="https://fhir.nhs.uk/StructureDefinition/Extension-SDS-NhsServiceInteractionId">
										 <valueReference>
											 <identifier>
												 <system value="https://fhir.nhs.uk/Id/nhsServiceInteractionId"></system>
												 <value value="{$entry/@soapaction}"></value>
											 </identifier>
										 </valueReference>
									 </extension>
									<identifier>
									   <system value="https://fhir.nhs.uk/Id/nhsMhsFQDN"></system>
									   <value value="{replace($entry/@endpoint,'https://(.*?)/.*$','$1')}"></value>
									</identifier>
									<identifier>
									   <system value="https://fhir.nhs.uk/Id/nhsMhsPartyKey"></system>
									   <value value="{$entry/@partykey}"></value>
									</identifier>
									<identifier>
									   <system value="https://fhir.nhs.uk/Id/nhsMhsCPAId"></system>
									   <value value="{$entry/@cpaid}"></value>
									</identifier>
									<identifier>
									   <system value="https://fhir.nhs.uk/Id/nhsMHSId"></system>
									   <value value="{$entry/@cpaid}"></value>
									</identifier>
									<status value="active"></status>
									<connectionType>
									   <system value="http://terminology.hl7.org/CodeSystem/endpoint-connection-type"></system>
									   <code value="hl7-fhir-msg"></code>
									   <display value="HL7 FHIR Messaging"></display>
									</connectionType>
									<managingOrganization>
									   <identifier>
										  <system value="https://fhir.nhs.uk/Id/ods-organization-code"></system>
										  <value value="true"></value>
									   </identifier>
									</managingOrganization>
									<payloadType>
									   <coding>
										  <system value="http://terminology.hl7.org/CodeSystem/endpoint-payload-type"></system>
										  <code value="any"></code>
										  <display value="Any"></display>
									   </coding>
									</payloadType>
									 <address><xsl:value-of select="$entry/@endpoint"/></address>
								</Endpoint>
							</resource>
							<search>
								<mode value="match"/>
							</search>
						</entry>
			</xsl:for-each>
		</Bundle>
	</xsl:template>

	<!-- ===========================================================================================  -->

</xsl:stylesheet>
