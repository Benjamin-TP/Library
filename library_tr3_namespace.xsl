<?xml version="1.0" encoding="UTF-8"?>
<!-- Books per theme, sorted by popularity (nr of borrows descending)-->
<xsl:stylesheet version="1.0" 
	xmlns:lib="http://www.example.com/PO1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="ISO-8859-1" indent="yes"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>List of the books sorted per category and popularity</title>
				<style>
					h1,h2 {text-align: center;}
				</style>
			</head>
			<body>
				<h1>List of the books sorted per category and popularity</h1>
				<xsl:apply-templates select="//lib:THEME[not(.=preceding::*)]">
					<xsl:sort select="." order="ascending"/>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="lib:THEME">
		<xsl:variable name="theme_name" select="."/>
		<p>
			<strong>
				<xsl:value-of select="."/>
			</strong>
		</p>
		<xsl:apply-templates select="//lib:BOOK[lib:THEME=$theme_name]">
			<xsl:sort select="lib:NROFBORROWS" order="descending"/>
		</xsl:apply-templates>
		<br/>
	</xsl:template>

	<xsl:template match="lib:BOOK">
		<p>
			<i><xsl:value-of select="lib:TITLE"/></i>
			<xsl:text>, borrowed </xsl:text>
			<strong><xsl:value-of select="lib:NROFBORROWS"/></strong>
			<xsl:text> times</xsl:text>
		</p>
	</xsl:template>

</xsl:stylesheet>

