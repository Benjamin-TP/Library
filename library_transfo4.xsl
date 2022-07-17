<?xml version="1.0" encoding="utf-8"?>
<!--Books by authors (Writer / Scriptwriter / Novelist)
Colourist and Illustrator not included, since they always are coauthors
-->
<xsl:stylesheet version="1.0" 
	xmlns:lib="https://github.com/Benjamin-TP/Library/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:element name="AUTHORS">
			<xsl:apply-templates select="//lib:AUTHOR">
				<xsl:sort select="lib:LASTNAME"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="lib:AUTHOR">
		<xsl:variable name="id_author" select="@idAuthor"/>
		<!--Above variable used to retrieve the BOOKs linked to the current AUTHOR
		BOOK has (one or more) child node BOOKAUTHOR with attribute idAuthorRef which refers to the idAuthor key of the AUTHOR
		-->
		
		<!--Colourist and Illustrator not included, since they always are coauthors -->
		<xsl:variable name="is_writer" select="count(//lib:BOOKS/lib:BOOK/lib:BOOKAUTHORS/lib:BOOKAUTHOR[@idAuthorRef=$id_author]/lib:ROLE[.!='Colourist' and .!='Illustrator'])"/>
		<!--Above variable to check if the AUTHOR is Scriptwriter / Writer / Novelist on at leas one book
		If it's not the case, hence the AUTHOR info will not be desplayed, according to the below IF statement
		-->

		<!--see above comment-->
		<xsl:if test="$is_writer &gt; 0">
			<xsl:element name="AUTHOR">
				<xsl:element name="NAME">
					<xsl:value-of select="lib:FIRSTNAME"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="lib:LASTNAME"/>
				</xsl:element>
				
				<!-- The current author is Scriptwriter / Writer / Novelist: hence BOOK template called to retrieve
				all the BOOKs with the current AUTHOR (idAuthor) as and author
				
				BOOK sorted by serie title (if any) and release date
				-->
				<xsl:apply-templates select="//lib:BOOKS/lib:BOOK[lib:BOOKAUTHORS/lib:BOOKAUTHOR/@idAuthorRef=$id_author]">
					<xsl:sort select="lib:SERIE_TITLE" order="ascending"/>
					<xsl:sort select="lib:RELEASEDATE" order="ascending"/>
				</xsl:apply-templates>
					
			</xsl:element>
			
			<xsl:text>&#13;&#13;</xsl:text>
			
		</xsl:if>
		
	</xsl:template>
	
	
	<!--
	BOOK template
	Called in the AUTHOR template
	-->
	<xsl:template match="lib:BOOK">
	
		<xsl:variable name="id_bookserie" select="lib:BOOKSER/@idBSRef"/>
		<xsl:variable name="id_comicbookserie" select="lib:COMICBOOKSER/@idCBSRef"/>
		<!--The two above variables are used to get the serie info (in case the BOOK is linked to one serie)
		idBSRef of BOOKSER (child element of BOOK) refers to the idBS key of the BOOKSERIE
		same principle with idCBSRef of COMICBOOKSER, idCBS and COMICBOOKSERIE
		-->
		
		
		<xsl:element name="BOOK">
			<xsl:attribute name="isbn"><xsl:value-of select="lib:ISBN"/></xsl:attribute>
			
			<!--"serie" templates called to add the serie info as tags (if any)-->
			<xsl:apply-templates select="//lib:BOOKSERIE[@idBS=$id_bookserie]"/>
			<xsl:apply-templates select="//lib:COMICBOOKSERIE[@idCBS=$id_comicbookserie]"/>
			
			<!--TITLE of the book-->
			<xsl:element name="TITLE">
				<xsl:value-of select="lib:TITLE"/>
			</xsl:element>
			
			<!--RELEASEDATE of the book-->
			<xsl:element name="RELEASEDATE">
				<xsl:value-of select="lib:RELEASEDATE"/>
			</xsl:element>
	
		</xsl:element>
	</xsl:template>


	<!--BOOKSERIE template
	Called in the BOOK template-->
	<xsl:template match="lib:BOOKSERIE">
		<xsl:element name="SERIE_TITLE">
			<xsl:value-of select="lib:TITLE"/>
		</xsl:element>
		<!--If the serie contains only one BOOK, we then add a boolean: ONE_SHOT. The serie contains one book only. -->
		<xsl:if test="lib:NROFVOLUMES = 1">
			<xsl:element name="ONE_SHOT">
				<xsl:text>true</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	
	<!--COMICBOOKSERIE: same principle as the above template
	Called in the BOOK template-->
	<xsl:template match="lib:COMICBOOKSERIE">
		<xsl:element name="SERIE_TITLE">
			<xsl:value-of select="lib:TITLE"/>
		</xsl:element>
		<xsl:if test="lib:NROFVOLUMES = 1">
			<xsl:element name="ONE_SHOT">
				<xsl:text>true</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>