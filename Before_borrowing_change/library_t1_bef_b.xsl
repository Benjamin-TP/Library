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
	
		<xsl:variable name="id_borrower" select="@idBorrower"/>
		
		<p><strong><xsl:value-of select="LASTNAME"/><xsl:text>  </xsl:text><xsl:value-of select="FIRSTNAME"/></strong>has <strong><xsl:value-of select="count(BORROWINGS/BORROWING)" /></strong> books in its card.</p>
		<p>He can still borrow <xsl:value-of select="10 - count(BORROWINGS/BORROWING)"/> books.</p> 
		<!--If I put here, I get the good result!
		TODO: to check if I can get the good result by calling BORROWINGS inside
		Maybe inside the BOOK template, by checking if exists a BORROWING from the borrower id_borrower with the same book id 
		Until BOOK, it is okay-->
		
		<!--<p><strong><xsl:value-of select="//BORROWING/@idBookRef"/></strong></p>-->
		<xsl:apply-templates select="../../BOOKS/BOOK">
			<xsl:with-param name="id_borrower" select="$id_borrower" />
			<xsl:sort select="RETURNDATE" order="ascending"/>
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
	</xsl:template>-->
	
	<xsl:template match="BOOK">
	
		<xsl:param name="id_borrower"/>
		<xsl:variable name="id_book" select="@idBook"/>
		
		<xsl:if test="../../BORROWERS/BORROWER[@idBorrower=$id_borrower]/BORROWINGS/BORROWING/@idBookRef = $id_book">
			<p><xsl:value-of select="TITLE"/>. Borrow date: <xsl:value-of select="BORROWDATE"/>, 
			Return date: <xsl:value-of select="RETURNDATE"/>
			</p>
		</xsl:if>
		
		
	</xsl:template>
	
	
	<!--Two options for filtering (the one above works too
	TODO: to find a solution for sorting by date. It is not working!
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
	</xsl:template>-->

</xsl:stylesheet>

