<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
>
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:param name="separator" select="','" as="xs:string"/>
	<xsl:param name="columns" as="xs:string*">
		<xsl:perform-sort select="distinct-values(/ArrayList/TicProduct/*/local-name())">
			<xsl:sort select="."/>
		</xsl:perform-sort>
	</xsl:param>

	<xsl:template match="/">
		<xsl:value-of select="string-join($columns, $separator)"/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="ArrayList">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="TicProduct">
		<xsl:variable name="current" select="."/>

		<!-- will only align with columns if there is a single value per column! -->
		<xsl:for-each select="$columns">
			<xsl:apply-templates select="$current/*[local-name() = current()]"/>

			<xsl:choose>
				<xsl:when test="not(position() = last())">
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
						<xsl:text>
</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="TicProduct/*">
		<xsl:choose>
			<xsl:when test=". castable as xs:string">
				<!-- escape with double quotes -->
				<xsl:text>"</xsl:text><xsl:value-of select="replace(., '&quot;', '&quot;&quot;')"/><xsl:text>"</xsl:text>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()"/>

</xsl:stylesheet>