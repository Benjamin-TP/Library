<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" encoding="UTF-8"/>
  
	<xsl:template match="/">
		<xsl:text>{        
		"ComicBookSeries": [
		</xsl:text>
		<xsl:apply-templates select="//COMICBOOKSERIE">
			<xsl:sort select="TITLE" order="ascending"/>
	</xsl:apply-templates>
	<xsl:text>     
		]}
	</xsl:text>
	</xsl:template>


	<xsl:template match="COMICBOOKSERIE">
		<xsl:variable name="id_cbserie" select="@idCBS"/>
		
		<xsl:text>{"Title": "</xsl:text><xsl:value-of select="TITLE"/> <xsl:text>",</xsl:text>
		<xsl:text> "SerieDescription": "</xsl:text><xsl:value-of select="DESCRIPTION"/> <xsl:text>",</xsl:text>
		<xsl:text> "NrOfVolumes": "</xsl:text><xsl:value-of select="NROFVOLUMES"/> <xsl:text>",</xsl:text>
		
		<xsl:text>        
			"Comics": [
		</xsl:text>
		
		<xsl:apply-templates select="../../BOOKS/BOOK">
			<xsl:with-param name="id_cbserie" select="$id_cbserie" />
			<xsl:sort select="RELEASEDATE" order="ascending"/>
		</xsl:apply-templates>
				
		<xsl:text>     
			]
		</xsl:text>
		
		<xsl:choose>
			<!--If the current node is the last one, hence end of list (hence, no comma)-->
			<xsl:when test="position()!=last()">
				<xsl:text>},</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="BOOK">
	
		<xsl:param name="id_cbserie"/>
		
		<xsl:if test="COMICBOOKSER/@idCBSRef = $id_cbserie">
			
			<xsl:text>{"Title": "</xsl:text><xsl:value-of select="TITLE"/> <xsl:text>",</xsl:text>
			<xsl:text> "ISBN": "</xsl:text><xsl:value-of select="ISBN"/> <xsl:text>",</xsl:text>
			<xsl:text> "ReleaseDate": "</xsl:text><xsl:value-of select="RELEASEDATE"/> <xsl:text>",</xsl:text>
			<xsl:text> "Authors": [ </xsl:text>
				
			<xsl:apply-templates select="BOOKAUTHORS/BOOKAUTHOR"/>

			<xsl:text> ] }, </xsl:text>
			
		</xsl:if>
		
	</xsl:template>


	<!--For the AUTHOR and ROLE templates, 
	the opening and closing curling brackets (for BOOKAUTHOR) and square brackets (for ROLE) are managed directly in the below BOOKAUTHOR template.
	Indeed,
	For BOOKAUTHOR: there are several bookauthors per book, but one and only one AUTHOR per BOOKAUTHOR.
	Hence, in order to manage the "the current node the last one generated by the template" case, we have to do it outside the AUTHOR template.
	For ROLE, this is the same principle.
	-->
	<xsl:template match="BOOKAUTHOR">
		
		<xsl:variable name="id_author" select="@idAuthorRef"/>
		

		<xsl:text>{</xsl:text>
		
		<xsl:apply-templates select="//AUTHOR[@idAuthor=$id_author]"/>
		
		<xsl:text>"Roles": [ </xsl:text>
			<xsl:apply-templates select="ROLE"/>
		<xsl:text> ]</xsl:text>
		
		<xsl:choose>
			<xsl:when test="position()!=last()">
				<xsl:text>},</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	

  	<xsl:template match="AUTHOR">
		<xsl:text>"idAuthor": "</xsl:text><xsl:value-of select="@idAuthor"/> <xsl:text>",</xsl:text>
		<xsl:text>"Lastname": "</xsl:text><xsl:value-of select="LASTNAME"/> <xsl:text>",</xsl:text>
		<xsl:text> "Firstname": "</xsl:text><xsl:value-of select="FIRSTNAME"/> <xsl:text>",</xsl:text>		
	</xsl:template>
	
	
  	<xsl:template match="ROLE">
		<xsl:text>"</xsl:text><xsl:value-of select="."/>
		<xsl:choose>
			<xsl:when test="position()!=last()">
				<xsl:text>",</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>"</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
  
</xsl:stylesheet>
