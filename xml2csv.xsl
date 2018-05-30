<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
>
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:param name="separator" select="','" as="xs:string"/>
	<xsl:param name="columns" as="xs:string*">
		<!-- both element and attribute names become columns -->
		<xsl:perform-sort select="distinct-values(('Type', /*/*/*/local-name(), /*/*/@*/local-name()))">
			<xsl:sort select="."/>
		</xsl:perform-sort>
	</xsl:param>

	<xsl:template match="/">
		<!-- output header row and line-break -->
		<xsl:value-of select="string-join($columns, $separator)"/>
		<xsl:text>&#10;</xsl:text>

		<!-- process document by applying templates recursively, starting from the root element -->
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="/*">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="/*/*">
		<xsl:variable name="current" select="."/>

		<!-- iterate columns -->
		<xsl:for-each select="$columns">
			<xsl:choose>
				<xsl:when test="current() = 'Type'">
					<!-- output row element name as type -->
					<xsl:value-of select="$current/local-name()"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- select elements/attributes by matching name - will only align with columns if there is a single value per column! -->
					<xsl:apply-templates select="$current/*[local-name() = current()] | $current/@*[local-name() = current()]"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- output separator between values, line-break after the last value -->
			<xsl:choose>
				<xsl:when test="not(position() = last())">
					<xsl:value-of select="$separator"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&#10;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="/*/*/* | /*/*/@*">
		<xsl:choose>
			<!-- output numeric values as-is -->
			<xsl:when test=". castable as xs:double"><xsl:value-of select="."/></xsl:when>
			<!-- escape non-empty string values with double quotes -->
			<xsl:when test="string(.)"><xsl:text>"</xsl:text><xsl:value-of select="replace(., '&quot;', '&quot;&quot;')"/><xsl:text>"</xsl:text></xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- supress text between elements -->
	<xsl:template match="text()"/>

</xsl:stylesheet>