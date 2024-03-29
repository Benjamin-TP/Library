<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:lib="https://github.com/Benjamin-TP/Library/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--List of the books per borrower (sorted by lastname), sorted by return date ascending-->
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>List of the books borrowed per borrower.</title>
				<!--Style added for a clearer output (I use table)-->
				<style>
					h1,h2   {text-align: center;}
					table, tr, th, td {border: 2px solid black;
									border-collapse: collapse;}
				</style>
			</head>
			<body>
				<!--Display the total number of books borrowed-->
				<h1>Here is the list of the <xsl:value-of select="count(//lib:BORROWING)"/> books borrowed sorted by borrower</h1>
				<h2>The borrowers are sorted by lastname ascending. For each borrower, the books are sorted by return date ascending.</h2>
				
				<!--The first template is the BORROWER. Indeed, we want to display the books borrowed per borrower.
				The borrowers are sorted by Lastname, then firstname-->
				<xsl:apply-templates select="//lib:BORROWER"> 
					<xsl:sort select="lib:LASTNAME" order="ascending"/>
					<xsl:sort select="lib:FIRSTNAME" order="ascending"/>
				</xsl:apply-templates>
			</body>
		</html>
	</xsl:template>
	
	
	<!--BORROWER template-->
	<xsl:template match="lib:BORROWER">
		<xsl:variable name="nr_of_borrowings" select="count(lib:BORROWINGS/lib:BORROWING)"/>
		<!--The above variabler is used to display the number of books of the current user.
		It is also used to compute the number of books the user can still borrow.
		The max number of books the user can borrow is set to 10 in the xsd file
		e.g:
		John Doe has X books in his/her card. This user can still borrow 10-X books.
		-->
			
		<p>
			<strong>
				<xsl:value-of select="lib:FIRSTNAME"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="lib:LASTNAME"/>
			</strong> 
			<xsl:text> has </xsl:text>
			<strong><xsl:value-of select="$nr_of_borrowings" /></strong>
			
			<!--Peculiar case: only one book borrowed, hence we display "book" instead of "books".-->
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
			
			<!--The table contains the title, the borrow date and the expected return date as columns.
			The books are sorted by return date.
			As the dates are string in YYYY-MM-DD format, it works well.
			-->
			<tr>
				<th>Title</th>
				<th>Borrow date</th>
				<th>Expected return date</th>
			</tr>
	
			<!-- Each book borrow info is in BORROWING-->
			<xsl:apply-templates select="lib:BORROWINGS/lib:BORROWING">
				<xsl:sort select="lib:RETURNDATE" order="ascending"/>
			</xsl:apply-templates>
			
		</table>
		
		<xsl:text>&#13;</xsl:text>
		<br/>
		<xsl:text>&#13;</xsl:text>
		
	</xsl:template>
	
	
	<!--BORROWING template
	Called in the BORROWER template
	-->
	<xsl:template match="lib:BORROWING">
		<xsl:variable name="id_book" select="@idBookRef"/>
		<!--The above variable is used to retrieve the book title from the book.
		the idBookRef attribute of BORROWING refers to th idBook key of the BOOK
		-->

		
		<tr>

			<xsl:apply-templates select="../../../../lib:BOOKS/lib:BOOK[@idBook = $id_book]">
				<xsl:sort select="lib:RELEASEDATE" order="ascending"/>
			</xsl:apply-templates>
			<td><xsl:value-of select="lib:BORROWDATE"/></td>
			<td><xsl:value-of select="lib:RETURNDATE"/></td>
		</tr>
		
	</xsl:template>
	
	
	<!--BOOK template
	Called in the BORROWING template
	-->
	<xsl:template match="lib:BOOK">
		<td><xsl:value-of select="lib:TITLE"/></td>
	</xsl:template>

</xsl:stylesheet>

