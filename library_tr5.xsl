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
		<xsl:text>{"@idCBS": "</xsl:text><xsl:value-of select="@idCBS"/> <xsl:text>",</xsl:text>
		<xsl:text> "Title": "</xsl:text><xsl:value-of select="TITLE"/> 
		<xsl:choose>
			<!--If the current node is the last one, hence end of list (hence, no comma)-->
			<xsl:when test="position()!=last()">
				<xsl:text>"},</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>"}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:text>{"@idAuthor": "</xsl:text><xsl:value-of select="@idAuthor"/> <xsl:text>",</xsl:text>
		<xsl:text>"Lastname": "</xsl:text><xsl:value-of select="LASTNAME"/> <xsl:text>",</xsl:text>
		<xsl:text> "Firstname": "</xsl:text><xsl:value-of select="FIRSTNAME"/>
		<xsl:choose>
			<!--If the current node is the last one, hence end of list (hence, no comma)-->
			<xsl:when test="position()!=last()">
				<xsl:text>"},</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>"}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
  
</xsl:stylesheet>
