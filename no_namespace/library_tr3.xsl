<?xml version="1.0" encoding="UTF-8"?>
<!-- Books per theme, sorted by popularity (nr of borrows descending)-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="ISO-8859-1" indent="yes"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>List of the books sorted per category and popularity. </title>
				<style>
					h1,h2 {text-align: center;}
				</style>
			</head>
			<body>
				<h1>List of the books sorted per category and popularity. </h1>
				<xsl:apply-templates select="//THEME[not(.=preceding::*)]">
					<xsl:sort select="." order="ascending"/>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="THEME">
		<xsl:variable name="theme_name" select="."/>
		<p>
			<strong>
				<xsl:value-of select="."/>
			</strong>
		</p>
		<xsl:apply-templates select="//BOOK[THEME=$theme_name]">
			<xsl:sort select="NROFBORROWS" order="descending"/>
		</xsl:apply-templates>
		<br/>
	</xsl:template>
	
	<xsl:template match="BOOK">
		<p>
			<i><xsl:value-of select="TITLE"/></i>
			<xsl:text>, borrowed </xsl:text>
			<strong><xsl:value-of select="NROFBORROWS"/></strong>
			<xsl:text> times</xsl:text>
		</p>
	</xsl:template>

</xsl:stylesheet>

