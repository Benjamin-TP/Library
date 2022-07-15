<?xml version="1.0" encoding="UTF-8"?>
<!--List of the books per author, with the role(s).-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
					<xsl:apply-templates select="//AUTHORS"/>
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
	
		<p><strong><xsl:value-of select="FIRSTNAME"/>
		<xsl:text>  </xsl:text>
		<xsl:value-of select="LASTNAME"/></strong> is author for the following books:</p>
		
		<xsl:variable name="id_author" select="@idAuthor"/>
		
		<xsl:apply-templates select="../../BOOKS/BOOK[BOOKAUTHORS/BOOKAUTHOR/@idAuthorRef=$id_author]">
			<xsl:with-param name="id_author" select="$id_author" />
			<xsl:sort select="RELEASEDATE" order="ascending"/>
		</xsl:apply-templates>
		
		<br/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="BOOK">
		<xsl:param name="id_author"/>
		<xsl:variable name="nr_of_roles" select="count(BOOKAUTHORS/BOOKAUTHOR[@idAuthorRef=$id_author]/ROLE)"/>
		
		<xsl:variable name="id_comicserie" select="COMICBOOKSER/@idCBSRef"/>
		<xsl:variable name="id_bookserie" select="BOOKSER/@idBSRef"/>
		
		<ul>
			<li>
				
				<xsl:apply-templates select="../../COMICBOOKSERIES/COMICBOOKSERIE[@idCBS=$id_comicserie]"/>
				<xsl:apply-templates select="../../BOOKSERIES/BOOKSERIE[@idBS=$id_bookserie]"/>
				
				<i><xsl:value-of select="TITLE"/></i>
				
				<xsl:if test="$nr_of_roles = 1">
					 <xsl:text> as a </xsl:text><xsl:value-of select="BOOKAUTHORS/BOOKAUTHOR[@idAuthorRef=$id_author]/ROLE"/>
				</xsl:if>
				
				<xsl:if test="$nr_of_roles &gt; 1">
					<xsl:text> as a: </xsl:text>
					<ul>
					 <xsl:for-each select="BOOKAUTHORS/BOOKAUTHOR[@idAuthorRef=$id_author]/ROLE">
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
	
	<xsl:template match="COMICBOOKSERIE">
		<xsl:if test="NROFVOLUMES &gt; 1">
			<xsl:value-of select="TITLE"/>
			<xsl:text> (serie): </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="BOOKSERIE">
		<xsl:if test="NROFVOLUMES &gt; 1">
			<xsl:value-of select="TITLE"/>
			<xsl:text> (serie): </xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

