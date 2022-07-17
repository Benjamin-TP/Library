<?xml version="1.0" encoding="UTF-8"?>
<!-- Books per theme, sorted by popularity (nr of borrows descending)-->
<xsl:stylesheet version="1.0" 
	xmlns:lib="https://github.com/Benjamin-TP/Library/"
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
				
				<!--THEME template applied 
				In order to avoid list duplicated (each theme should appear only once),
				the filter not(.=preceding::*) is added
				-->
				<xsl:apply-templates select="//lib:THEME[not(.=preceding::*)]">
					<xsl:sort select="." order="ascending"/>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>


	<!--From the theme, we need to retrieve the BOOK with this theme-->
	<xsl:template match="lib:THEME">
		<xsl:variable name="theme_name" select="."/>
		<!-- current value as a variable to put it as a filter when calling the BOOK template-->
		
		<p>
			<strong>
				<xsl:value-of select="."/>
			</strong>
		</p>
		
		<!--BOOK selected by filtering on the theme_name variable
		The most popular books appear first: they are sorted by number of times borrowed descending
		-->
		<xsl:apply-templates select="//lib:BOOK[lib:THEME=$theme_name]">
			<xsl:sort select="lib:NROFBORROWS" order="descending"/>
		</xsl:apply-templates>
		<br/>
		
	</xsl:template>


	<!--BOOK template
	Called in THEME
	TITLE and NROFBORROWS displayed
	Eventually PERIODSTARTDATE for the newspapers only (in order to distinguish them)
	-->
	<xsl:template match="lib:BOOK">
		<p>
			<i><xsl:value-of select="lib:TITLE"/></i>
			
			<!--If its a Newspaper: display the start date in order to distinguish the newspapers of the same serie-->
			<xsl:if test="lib:BOOKFORMAT = 'Newspaper'">
				<xsl:text> (date: </xsl:text>
				<xsl:value-of select="lib:NEWSPAPERSER/lib:PERIODSTARTDATE"/>
				<xsl:text> )  </xsl:text>
			</xsl:if>
			
			<xsl:text>, borrowed </xsl:text>
			<strong><xsl:value-of select="lib:NROFBORROWS"/></strong>
			<xsl:text> times</xsl:text>
		</p>
	</xsl:template>

</xsl:stylesheet>

