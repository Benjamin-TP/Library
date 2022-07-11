<?xml version="1.0" encoding="UTF-8"?>
<!--
List of the books per borrower

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="ISO-8859-1" indent="yes"/>

	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<title>List of the books borrowed per borrower</title>
			</head>
			<body>
				<h1>Here is the list of the <xsl:value-of select="count(//BORROWING)"/> books borrowed sorted by borrower</h1>
				<blockquote>
					<xsl:apply-templates select="//BORROWER"> 
						<xsl:sort select="LASTNAME" order="ascending"/>
						<xsl:sort select="FIRSTNAME" order="ascending"/>
					</xsl:apply-templates>
				</blockquote>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="BORROWER">
		<p><strong><xsl:value-of select="LASTNAME"/>,<xsl:value-of select="FIRSTNAME"/></strong></p>
		<!--<p><strong><xsl:value-of select="//BORROWING/@idBookRef"/></strong></p>-->
		<xsl:apply-templates select="BORROWINGS">
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="BORROWINGS">
		<p>This borrower has <xsl:value-of select="count(BORROWING)" /> books in its card</p>
		<xsl:apply-templates select="BORROWING">
		</xsl:apply-templates>
	</xsl:template>
	
	<!--This code is ok: we get the idBook for each BORROWER
	<xsl:template match="BORROWING">
		<p><strong><xsl:value-of select="@idBookRef"/></strong></p>
	</xsl:template>-->
	
	<!--
	<xsl:template match="BORROWING">
		<xsl:variable name="id_book" select="@idBookRef"/>
		<xsl:apply-templates select="../../../../BOOKS/BOOK">
			<xsl:with-param name="id_book" select="$id_book" />
			<xsl:sort select="TITLE" order="descending"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="BOOK">
		<xsl:param name="id_book"/>
		<xsl:if test="@idBook = $id_book">
			<p><xsl:value-of select="TITLE"/>. Borrow date: <xsl:value-of select="BORROWDATE"/>, 
			Return date: <xsl:value-of select="RETURNDATE"/>
			</p>
		</xsl:if>
	</xsl:template>
	-->
	
	<!--Two options for filtering (the one above works too
	TODO: to find a solution for sorting by date. It is not working!-->
	<xsl:template match="BORROWING">
		<xsl:variable name="id_book" select="@idBookRef"/>
		<xsl:apply-templates select="../../../../BOOKS/BOOK[@idBook=$id_book]">
			<xsl:sort select="RETURNDATE" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="BOOK">
			<p><xsl:value-of select="TITLE"/>. Borrow date: <xsl:value-of select="BORROWDATE"/>, 
			Return date: <xsl:value-of select="RETURNDATE"/>
			</p>
	</xsl:template>

</xsl:stylesheet>

