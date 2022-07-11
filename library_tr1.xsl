<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><!--List of the books per borrower-->

	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<!--<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>-->
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
			
		<p><strong><xsl:value-of select="LASTNAME"/><xsl:text> </xsl:text><xsl:value-of select="FIRSTNAME"/></strong> has <strong><xsl:value-of select="count(BORROWINGS/BORROWING)" /></strong> books in its card.</p>
		
		<p>This user can still borrow <xsl:value-of select="10 - count(BORROWINGS/BORROWING)"/> books.</p> 

		<!--https://developer.mozilla.org/fr/docs/Web/HTML/Element/td-->
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
		
		<!--<xsl:text>&#13;</xsl:text>  carriage return character -->
		<xsl:text>&#13;</xsl:text>
		<br/>
		<br/>
		<br/>
		<br/>
		<br/>
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

