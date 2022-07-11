<?xml version="1.0" encoding="UTF-8"?>
<!--
List of the books per author, with the role.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>List of the books available sorted by Author</title>
			</head>
			<body>
				<h1>List of the books available sorted by Author</h1>
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
	
		<p><strong><xsl:value-of select="LASTNAME"/>
		<xsl:text>  </xsl:text>
		<xsl:value-of select="FIRSTNAME"/></strong> is, for the following books:</p>
		
		<xsl:variable name="id_author" select="@idAuthor"/>
		
		<!--and ROLE='Writer' in brackets: it filters but empty lists appear
		Issue when duplicating (Writer, Scriptwriter, Novelist, Illustrator, Colourist: duplicates when an author appears more than once per book-->
		<xsl:apply-templates select="../../BOOKS/BOOK/BOOKAUTHORS/BOOKAUTHOR[@idAuthorRef=$id_author]"> 
			<xsl:with-param name="id_author" select="$id_author" />
			<xsl:sort select="ROLE" order="descending"/> <!--This sort is useless!-->
		</xsl:apply-templates>
		
		<br/>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>


	
	<xsl:template match="BOOKAUTHOR">
	
		<xsl:apply-templates select="ROLE[.='Colourist']"/>
		<xsl:apply-templates select="ROLE[.='Illustrator']"/>
		<xsl:apply-templates select="ROLE[.='Novelist']"/>
		<xsl:apply-templates select="ROLE[.='Scriptwriter']"/>
		<xsl:apply-templates select="ROLE[.='Writer']"/>		
			
	</xsl:template>
	
	<xsl:template match="ROLE">
	<!--<xsl:text>Je suis la</xsl:text>-->
		<p><xsl:value-of select="current()"/> on <xsl:value-of select="../../../TITLE"/></p>
		
	</xsl:template>
	
	
	<!--The three below work but we have one role only in case of several roles per author
	NB: the if in BOOKAUTHOR is useless if we put the author id in the call
	<xsl:template match="BOOKAUTHOR">
	
		<xsl:param name="id_author"/>
		<xsl:if test="@idAuthorRef = $id_author">
			<p><xsl:value-of select="ROLE"/> on <xsl:value-of select="../../TITLE"/> 
			<xsl:apply-templates select="../../COMICBOOKSER[@idCBSRef]"/>
			</p>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="COMICBOOKSER">
		<xsl:variable name="id_cbs" select="@idCBSRef"/>
		
		<xsl:apply-templates select="../../../COMICBOOKSERIES/COMICBOOKSERIE">
			<xsl:with-param name="id_cbs" select="$id_cbs" />
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="COMICBOOKSERIE">
		<xsl:param name="id_cbs"/>
		<xsl:if test="@idCBS = $id_cbs">
			<xsl:text> (Book serie </xsl:text> 
			<xsl:value-of select="TITLE"/>
			<xsl:text> ) . </xsl:text> 
		</xsl:if>
	</xsl:template>
	-->
	

</xsl:stylesheet>

