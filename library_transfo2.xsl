<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:lib="https://github.com/Benjamin-TP/Library/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<!--List of the books per author, with the role(s).-->

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
					<!--The first template called is AUTHORS.
					We could call AUTHOR directly, but I find this way clearer to sort by lastname, then firstname-->
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
	
	
	<!--AUTHOR template
	Called in the AUTHORS template-->
	<xsl:template match="lib:AUTHOR">
	
		<p><strong><xsl:value-of select="lib:FIRSTNAME"/>
		<xsl:text>  </xsl:text>
		<xsl:value-of select="lib:LASTNAME"/></strong> is author for the following books:</p>
		
		<xsl:variable name="id_author" select="@idAuthor"/>
		<!--
		The above variable is used to map the idAuthor key to the idAuthorRef attribute available in BOOKAUTHOR
		BOOKAUTHOR is a child element of BOOK.
		-->
		
		<xsl:apply-templates select="../../lib:BOOKS/lib:BOOK[lib:BOOKAUTHORS/lib:BOOKAUTHOR/@idAuthorRef=$id_author]">
			<xsl:with-param name="id_author" select="$id_author" />
			<xsl:sort select="lib:RELEASEDATE" order="ascending"/>
		</xsl:apply-templates>
		
		<br/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>
	
	
	<!--Template used to retrieve BOOK information (title, and role of the author
	And also SERIE information.
	Called in the AUTHOR template.
	-->
	<xsl:template match="lib:BOOK">
		<xsl:param name="id_author"/>
		<xsl:variable name="nr_of_roles" select="count(lib:BOOKAUTHORS/lib:BOOKAUTHOR[@idAuthorRef=$id_author]/lib:ROLE)"/>
		<!-- the above variable is used for display purpose		-->
		
		<xsl:variable name="id_comicserie" select="lib:COMICBOOKSER/@idCBSRef"/>
		<xsl:variable name="id_bookserie" select="lib:BOOKSER/@idBSRef"/>
		<!--
		The two above variables are used to retrieve the serie eventually linked to the current book.
		If there is a serie (with more than one book in the serie, see the two last templates of this file,
		Then the title of the serie is added as a prefix.
		example:
		Largo Winch (serie)
		-->
		
		
		<!--The books are displayed as an unordered list-->
		<ul>
			<li>
				
				<!-- 
				SERIE templates applied here to add the title of the serie (if any) as a prefix).
				No risk to have more than one serie, as defined in the XSD file a BOOK can have only one serie.
				-->
				<xsl:apply-templates select="../../lib:COMICBOOKSERIES/lib:COMICBOOKSERIE[@idCBS=$id_comicserie]"/>
				<xsl:apply-templates select="../../lib:BOOKSERIES/lib:BOOKSERIE[@idBS=$id_bookserie]"/>
				
				<i><xsl:value-of select="lib:TITLE"/></i>
				
				<!--if the AUTHOR has only one role on this book, hence the role is displayed at the end of the row -->
				<xsl:if test="$nr_of_roles = 1">
					 <xsl:text> as a </xsl:text><xsl:value-of select="lib:BOOKAUTHORS/lib:BOOKAUTHOR[@idAuthorRef=$id_author]/lib:ROLE"/>
				</xsl:if>
				
				<!--Else the info is displayed as a child list of the current BOOK. -->
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
	
	
	<!--
	COMICBOOKSERIE template
	Called in the BOOK template-->
	<xsl:template match="lib:COMICBOOKSERIE">
		<!--If there is more than one book, then the serie title is added as a prefix-->
		<xsl:if test="lib:NROFVOLUMES &gt; 1">
			<xsl:value-of select="lib:TITLE"/>
			<xsl:text> (serie): </xsl:text>
		</xsl:if>
	</xsl:template>

	
	<!--
	BOOKSERIE template
	Called in the BOOK template-->
	<xsl:template match="lib:BOOKSERIE">
		<xsl:if test="lib:NROFVOLUMES &gt; 1">
			<xsl:value-of select="lib:TITLE"/>
			<xsl:text> (serie): </xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

