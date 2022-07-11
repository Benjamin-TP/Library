<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
List of the books per author, with the role.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="ISO-8859-1" indent="yes"/>

	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<title>List of the books available sorted by Author</title>
			</head>
			<body>
				<blockquote>
				<h1>List of the books available sorted by Author</h1>
					<xsl:apply-templates select="//AUTHORS"/>
				</blockquote>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="AUTHORS">
		<xsl:apply-templates select="AUTHOR">
			<xsl:sort select="LASTNAME" order="ascending"/>
			<xsl:sort select="FIRSTNAME" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="AUTHOR">
		<p><strong><xsl:value-of select="LASTNAME"/>
		<xsl:text>  </xsl:text>
		<xsl:value-of select="FIRSTNAME"/></strong> is, for the following books:</p>
		<xsl:variable name="id_author" select="@idAuthor"/>
		<xsl:apply-templates select="../../BOOKS/BOOK/BOOKAUTHORS/BOOKAUTHOR">
			<xsl:with-param name="id_author" select="$id_author" />
			<xsl:sort select="RELEASEDATE" order="descending"/>
		</xsl:apply-templates>
		<br/>
	</xsl:template>

	
	<xsl:template match="BOOKAUTHOR">
		<xsl:param name="id_author"/>
		<xsl:if test="@idAuthorRef = $id_author">
			<p><xsl:value-of select="ROLE"/> on <xsl:value-of select="../../TITLE"/> 
			<xsl:apply-templates select="../../COMICBOOKSER[@idCBSRef]"/>
			</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="COMICBOOKSER">
		<xsl:text> (Book serie) </xsl:text>
		<xsl:variable name="id_cbs" select="@idCBSRef"/>
		<xsl:apply-templates select="../../../COMICBOOKSERIES/COMICBOOKSERIE">
			<xsl:with-param name="id_cbs" select="$id_cbs" />
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="COMICBOOKSERIE">
		<xsl:param name="id_cbs"/>
		<xsl:if test="@idCBSRef = $id_cbs">
			<xsl:text> (Book serie) '$id_cbs' </xsl:text> <xsl:value-of select="TITLE"/>
		</xsl:if>
	</xsl:template>
	

</xsl:stylesheet>

