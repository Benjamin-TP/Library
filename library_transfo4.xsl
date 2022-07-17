<?xml version="1.0" encoding="utf-8"?>
<!--Books by authors (Writer / Scriptwriter / Novelist)-->
<xsl:stylesheet version="1.0" 
	xmlns:lib="http://www.example.com/PO1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:element name="AUTHORS">
			<xsl:apply-templates select="//lib:AUTHOR">
				<xsl:sort select="lib:LASTNAME"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="lib:AUTHOR">
		<xsl:variable name="id_author" select="@idAuthor"/>
		
		<!--Colourist and Illustrator not included, since they always are coauthors -->
		<xsl:variable name="is_writer" select="count(//lib:BOOKS/lib:BOOK/lib:BOOKAUTHORS/lib:BOOKAUTHOR[@idAuthorRef=$id_author]/lib:ROLE[.!='Colourist' and .!='Illustrator'])"/>

		<xsl:if test="$is_writer &gt; 0">
			<xsl:element name="AUTHOR">
				<xsl:element name="NAME">
					<xsl:value-of select="lib:FIRSTNAME"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="lib:LASTNAME"/>
				</xsl:element>
				
				<xsl:apply-templates select="//lib:BOOKS/lib:BOOK[lib:BOOKAUTHORS/lib:BOOKAUTHOR/@idAuthorRef=$id_author]">
					<xsl:sort select="lib:SERIE_TITLE" order="ascending"/>
					<xsl:sort select="lib:RELEASEDATE" order="ascending"/>
				</xsl:apply-templates>
					
			</xsl:element>
			
			<xsl:text>&#13;&#13;</xsl:text>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="lib:BOOK">
	
		<xsl:variable name="id_bookserie" select="lib:BOOKSER/@idBSRef"/>
		<xsl:variable name="id_comicbookserie" select="lib:COMICBOOKSER/@idCBSRef"/>
		
		<xsl:element name="BOOK">
			<xsl:attribute name="isbn"><xsl:value-of select="lib:ISBN"/></xsl:attribute>
			
			<xsl:apply-templates select="//lib:BOOKSERIE[@idBS=$id_bookserie]"/>
			<xsl:apply-templates select="//lib:COMICBOOKSERIE[@idCBS=$id_comicbookserie]"/>
			
			<xsl:element name="TITLE">
				<xsl:value-of select="lib:TITLE"/>
			</xsl:element>
			
			<xsl:element name="RELEASEDATE">
				<xsl:value-of select="lib:RELEASEDATE"/>
			</xsl:element>
			
			
			
		</xsl:element>
	</xsl:template>

	<xsl:template match="lib:BOOKSERIE">
		<xsl:element name="SERIE_TITLE">
			<xsl:value-of select="lib:TITLE"/>
		</xsl:element>
		<xsl:if test="lib:NROFVOLUMES = 1">
			<xsl:element name="ONE_SHOT">
				<xsl:text>true</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
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