<?xml version="1.0" encoding="UTF-8"?>
<!--
Comic books sorted by series
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="ISO-8859-1" indent="yes"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>List of the comic books sorted by serie</title>
			</head>
			<body>
				<blockquote>
					<xsl:apply-templates select="//COMICBOOKSERIE">
						<xsl:sort select="TITLE" order="ascending"/>
					</xsl:apply-templates>
				</blockquote>
			</body>
		</html>
	</xsl:template>
	
	
	<xsl:template match="COMICBOOKSERIE">
		<xsl:variable name="id_cbserie" select="@idCBS"/>
		
		<p>
			<strong>
			<xsl:value-of select="TITLE"/>
			<xsl:if test="NROFVOLUMES &gt; 1">
			<xsl:text> (Serie)</xsl:text>
			</xsl:if>
			</strong>
		</p>
		
		
			<ul>
				<xsl:apply-templates select="../../BOOKS/BOOK">
					<xsl:with-param name="id_cbserie" select="$id_cbserie" />
					<xsl:sort select="RELEASEDATE" order="ascending"/>
				</xsl:apply-templates>
			</ul>
		
		
		<xsl:text>&#13;&#13;</xsl:text>
		
	</xsl:template>	
	
	<xsl:template match="BOOK">
	
		<xsl:param name="id_cbserie"/>
		
		<xsl:if test="COMICBOOKSER/@idCBSRef = $id_cbserie">
			<li><xsl:value-of select="TITLE"/></li>
				
			<ul>
				<xsl:apply-templates select="BOOKAUTHORS/BOOKAUTHOR"/>
			</ul>
			
		</xsl:if>
		
	</xsl:template>

	<xsl:template match="BOOKAUTHOR">
		
		<xsl:variable name="id_author" select="@idAuthorRef"/>
		
		<li>
			<xsl:apply-templates select="//AUTHOR[@idAuthor=$id_author]"/>

			<xsl:choose>
				<xsl:when test="count(ROLE) &gt; 1">
					<ul>
						<xsl:for-each select="ROLE">
							<li><xsl:value-of select="."/></li>
						</xsl:for-each>
					</ul>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="ROLE"/>
					<xsl:text>) </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</li>

	</xsl:template>
	
	<xsl:template match="AUTHOR">
		
			<xsl:value-of select="FIRSTNAME"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="LASTNAME"/>
					
	</xsl:template>
	
</xsl:stylesheet>

