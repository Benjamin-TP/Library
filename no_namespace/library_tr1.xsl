<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--List of the books per borrower (sorted by lastname), sorted by return date ascending-->

	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>List of the books borrowed per borrower</title>
				<style>
					h1,h2   {text-align: center;}
					table, tr, th, td {border: 2px solid black;
									border-collapse: collapse;}
				</style>
			</head>
			<body>
				<h1>Here is the list of the <xsl:value-of select="count(//BORROWING)"/> books borrowed sorted by borrower</h1>
				<h2>The borrowers are sorted by lastname ascending. For each borrower, the books are sorted by return date ascending.</h2>
				<xsl:apply-templates select="//BORROWER"> 
					<xsl:sort select="LASTNAME" order="ascending"/>
					<xsl:sort select="FIRSTNAME" order="ascending"/>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="BORROWER">

		<xsl:variable name="nr_of_borrowings" select="count(BORROWINGS/BORROWING)"/>
			
		<p>
			<strong>
				<xsl:value-of select="FIRSTNAME"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="LASTNAME"/>
			</strong> 
			<xsl:text> has </xsl:text>
			<strong><xsl:value-of select="$nr_of_borrowings" /></strong>
			<xsl:choose>
				<xsl:when test="$nr_of_borrowings = 1">
					<xsl:text> book</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> books</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> in his/her card. </xsl:text>
		</p>
		
		<p>This user can still borrow <xsl:value-of select="10 - $nr_of_borrowings"/> books.</p> 

		<table>
		
			<tr>
				<th>Title</th>
				<th>Borrow date</th>
				<th>Expected return date</th>
			</tr>
	
			<xsl:apply-templates select="BORROWINGS/BORROWING">
				<xsl:sort select="RETURNDATE" order="ascending"/>
			</xsl:apply-templates>
			
		</table>
		
		<xsl:text>&#13;</xsl:text>
		<br/>
		<xsl:text>&#13;</xsl:text>
		
	</xsl:template>
	
	<xsl:template match="BORROWING">
		<xsl:variable name="id_book" select="@idBookRef"/>
		
		<tr>
			<xsl:apply-templates select="../../../../BOOKS/BOOK[@idBook = $id_book]">
				<xsl:sort select="RELEASEDATE" order="ascending"/>
			</xsl:apply-templates>
			<td><xsl:value-of select="BORROWDATE"/></td>
			<td><xsl:value-of select="RETURNDATE"/></td>
		</tr>
		
	</xsl:template>
	
	<xsl:template match="BOOK">
		<td><xsl:value-of select="TITLE"/></td>
	</xsl:template>

</xsl:stylesheet>

