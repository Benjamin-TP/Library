<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:element name="AUTHORS">
			<xsl:apply-templates select="//AUTHOR">
				<xsl:sort select="LASTNAME"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="AUTHOR">
		<xsl:variable name="id_author" select="@idAuthor"/>
		
		<!--Colourist and Illustrator not included, since they always are coauthors
		<xsl:variable name="is_writer" select="count(//BOOKS/BOOK/BOOKAUTHORS/BOOKAUTHOR[@idAuthorRef=$id_author]/ROLE[.='Scriptwriter'])"/>-->
		<xsl:variable name="is_writer" select="count(//BOOKS/BOOK/BOOKAUTHORS/BOOKAUTHOR[@idAuthorRef=$id_author]/ROLE[.!='Colourist' and .!='Illustrator'])"/>

		<xsl:if test="$is_writer &gt; 0">
			<xsl:element name="AUTHOR">
				<xsl:element name="NAME">
					<xsl:value-of select="FIRSTNAME"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="LASTNAME"/>
				</xsl:element>
				
				<xsl:apply-templates select="//BOOKS/BOOK[BOOKAUTHORS/BOOKAUTHOR/@idAuthorRef=$id_author]">
					<xsl:sort select="SERIE_TITLE" order="ascending"/>
					<xsl:sort select="RELEASEDATE" order="ascending"/>
				</xsl:apply-templates>
					
			</xsl:element>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="BOOK">
	
		<xsl:variable name="id_bookserie" select="BOOKSER/@idBSRef"/>
		<xsl:variable name="id_comicbookserie" select="COMICBOOKSER/@idCBSRef"/>
		
		<xsl:element name="BOOK">
			<xsl:attribute name="isbn"><xsl:value-of select="ISBN"/></xsl:attribute>
			
			<xsl:apply-templates select="//BOOKSERIE[@idBS=$id_bookserie]"/>
			<xsl:apply-templates select="//COMICBOOKSERIE[@idCBS=$id_comicbookserie]"/>
			
			<xsl:element name="TITLE">
				<xsl:value-of select="TITLE"/>
			</xsl:element>
			
			<xsl:element name="RELEASEDATE">
				<xsl:value-of select="RELEASEDATE"/>
			</xsl:element>
			
		</xsl:element>
	</xsl:template>

	<xsl:template match="BOOKSERIE">
		<xsl:if test="NROFVOLUMES &gt; 1">
			<xsl:element name="SERIE_TITLE">
				<xsl:value-of select="TITLE"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="COMICBOOKSERIE">
		<xsl:if test="NROFVOLUMES &gt; 1">
			<xsl:element name="SERIE_TITLE">
				<xsl:value-of select="TITLE"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>