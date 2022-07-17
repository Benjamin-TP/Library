<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:lib="http://www.example.com/PO1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--List of the books per author, with the role(s).-->
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>List of the books available sorted by Author</title>
				<style>
					h1,h2 {text-align: center;}
				</style>
			</head>
			<body>
				<h1>List of the books available sorted by Author</h1>
				<h2>The authors are sorted by last name (ascending), the books are sorted by release date (ascending - not displayed)</h2>
					<xsl:apply-templates select="//lib:AUTHORS"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="lib:AUTHORS">
		<xsl:apply-templates select="lib:AUTHOR">
			<xsl:sort select="lib:LASTNAME" order="ascending"/>
			<xsl:sort select="lib:FIRSTNAME" order="ascending"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="lib:AUTHOR">
	
		<p><strong><xsl:value-of select="lib:FIRSTNAME"/>
		<xsl:text>  </xsl:text>
		<xsl:value-of select="lib:LASTNAME"/></strong> is author for the following books:</p>
		
		<xsl:variable name="id_author" select="@idAuthor"/>
		
		<xsl:apply-templates select="../../lib:BOOKS/lib:BOOK[lib:BOOKAUTHORS/lib:BOOKAUTHOR/@idAuthorRef=$id_author]">
			<xsl:with-param name="id_author" select="$id_author" />
			<xsl:sort select="lib:RELEASEDATE" order="ascending"/>
		</xsl:apply-templates>
		
		<br/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="lib:BOOK">
		<xsl:param name="id_author"/>
		<xsl:variable name="nr_of_roles" select="count(lib:BOOKAUTHORS/lib:BOOKAUTHOR[@idAuthorRef=$id_author]/lib:ROLE)"/>
		
		<xsl:variable name="id_comicserie" select="lib:COMICBOOKSER/@idCBSRef"/>
		<xsl:variable name="id_bookserie" select="lib:BOOKSER/@idBSRef"/>
		
		<ul>
			<li>
				
				<xsl:apply-templates select="../../lib:COMICBOOKSERIES/lib:COMICBOOKSERIE[@idCBS=$id_comicserie]"/>
				<xsl:apply-templates select="../../lib:BOOKSERIES/lib:BOOKSERIE[@idBS=$id_bookserie]"/>
				
				<i><xsl:value-of select="lib:TITLE"/></i>
				
				<xsl:if test="$nr_of_roles = 1">
					 <xsl:text> as a </xsl:text><xsl:value-of select="lib:BOOKAUTHORS/lib:BOOKAUTHOR[@idAuthorRef=$id_author]/lib:ROLE"/>
				</xsl:if>
				
				<xsl:if test="$nr_of_roles &gt; 1">
					<xsl:text> as a: </xsl:text>
					<ul>
					 <xsl:for-each select="lib:BOOKAUTHORS/lib:BOOKAUTHOR[@idAuthorRef=$id_author]/lib:ROLE">
						<xsl:sort select="." order="descending"/>
						<li>
							<xsl:value-of select="."/>
						</li>	
					</xsl:for-each>
					</ul>
				</xsl:if>
			
			</li>
			
		</ul>
	</xsl:template>
	
	<xsl:template match="lib:COMICBOOKSERIE">
		<xsl:if test="lib:NROFVOLUMES &gt; 1">
			<xsl:value-of select="lib:TITLE"/>
			<xsl:text> (serie): </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="lib:BOOKSERIE">
		<xsl:if test="lib:NROFVOLUMES &gt; 1">
			<xsl:value-of select="lib:TITLE"/>
			<xsl:text> (serie): </xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

