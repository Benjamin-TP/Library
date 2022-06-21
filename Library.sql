--Select * from Editor where EditorID < 0 FOR XML AUTO, XMLSCHEMA

--DROP instructions
DROP TABLE IF EXISTS BookBorrowInfo;
DROP TABLE IF EXISTS Borrower;
DROP TABLE IF EXISTS BookFormat;
DROP TABLE IF EXISTS BookAuthor;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS BookSeries;
DROP TABLE IF EXISTS ComicsSeries;
DROP TABLE IF EXISTS Newspapers;
DROP TABLE IF EXISTS Frequency;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS BookType;
DROP TABLE IF EXISTS TargetReader;
DROP TABLE IF EXISTS BookTheme;
DROP TABLE IF EXISTS Editor;


--Editor: OK
create table Editor (
	EditorID INT IDENTITY(1,1) CONSTRAINT Editor_PK PRIMARY KEY,
	EditorName VARCHAR(20)
);

--Category (novel, theatre, history, sport, cuisine, etc...): OK
create table BookTheme (
	ThemeID INT IDENTITY(1,1) CONSTRAINT Theme_PK PRIMARY KEY,
	ThemeName VARCHAR(20)
);

--Target (age): OK
create table TargetReader (
	TargetReaderID INT IDENTITY(1,1) CONSTRAINT TargetReader_PK PRIMARY KEY,
	TargetReaderName VARCHAR(20)
);

--Type (book, BD, newspaper...): OK
create table BookType (
	BookTypeID INT IDENTITY(1,1) CONSTRAINT BookType_PK PRIMARY KEY,
	BookTypeName VARCHAR(20)
);

--Authors: OK
create table Authors (
	AuthorID INT IDENTITY(1,1) CONSTRAINT Authors_PK PRIMARY KEY,
	AuthorFirstName VARCHAR(20),
	AuthorLastName VARCHAR(20),
	AuthorBirthDate DATE
);

--Frequency (For a newspaper): OK
create table Frequency (
	FrequencyID INT IDENTITY(1,1) CONSTRAINT Frequency_PK PRIMARY KEY,
	FrequencyName VARCHAR(20)
);

--Newspaper table: OK
--Used by books as FK
create table Newspapers (
	NewspaperID INT IDENTITY(1,1) CONSTRAINT Newspapers_PK PRIMARY KEY,
	NewspaperName VARCHAR(20),
	NewspaperDesc VARCHAR(100),
	ISSN VARCHAR(20),
	FrequencyID INT CONSTRAINT Newspaper_Frequency_FK FOREIGN KEY REFERENCES Frequency(FrequencyID)
);


--Comics serie table: OK
--Used by books as FK
create table ComicsSeries (
	ComicSeriesID INT IDENTITY(1,1) CONSTRAINT ComicSeries_PK PRIMARY KEY,
	ComicSeriesName VARCHAR(20),
	ComicSerieDesc VARCHAR(100),
	NrOfVolumes INT
);



--Book serie table: OK
--Used by books as FK
create table BookSeries (
	BookSeriesID INT IDENTITY(1,1) CONSTRAINT BookSeries_PK PRIMARY KEY,
	BookSeriesName VARCHAR(20),
	BookSerieDesc VARCHAR(100),
	NrOfVolumes INT
);

--Books: main table of the model
--If the same book is available more than once, hence it has another ID
 create table Books (
	BookID INT IDENTITY(1,1) CONSTRAINT Books_PK PRIMARY KEY , --Max size: INT size
	Title VARCHAR(20),
	BookDesc VARCHAR(100),
	ISBN VARCHAR(20), --ISBN, ISSN
	ThemeID INT CONSTRAINT Books_BookTheme_FK FOREIGN KEY REFERENCES BookTheme(ThemeID),
	TargetReaderID INT CONSTRAINT Books_TargetReader_FK FOREIGN KEY REFERENCES TargetReader(TargetReaderID),
	EditorID INT CONSTRAINT Books_Editor_FK FOREIGN KEY REFERENCES Editor(EditorID),
	BookTypeID INT CONSTRAINT Books_BookType_FK FOREIGN KEY REFERENCES BookType(BookTypeID),
	ReleaseDate DATE,
	PurchaseDate DATE,
	NewspaperID INT CONSTRAINT Books_Newspapers_FK FOREIGN KEY REFERENCES Newspapers(NewspaperID),
	ComicSeriesID INT CONSTRAINT Books_ComicsSeries_FK FOREIGN KEY REFERENCES ComicsSeries(ComicSeriesID),
	BookSeriesID INT CONSTRAINT Books_BookSeries_FK FOREIGN KEY REFERENCES BookSeries(BookSeriesID)
);


--Link between books and Authors: OK
create table BookAuthor (
	BookID INT CONSTRAINT BookAuthor_Books_FK FOREIGN KEY REFERENCES Books(BookID),
	AuthorID INT CONSTRAINT BookAuthor_Author_FK FOREIGN KEY REFERENCES Authors(AuthorID)
);


--Book format: size: OK
--NB: "broché, "poche" useless? TODO: to check
create table BookFormat (
	BookFormatID INT IDENTITY(1,1) CONSTRAINT Books_Format_PK PRIMARY KEY,
	BookID INT CONSTRAINT BooksFormat_Books_FK FOREIGN KEY REFERENCES Books(BookID),
	BHeight NUMERIC(3,1),
	BLength NUMERIC(3,1),
	BWidth NUMERIC(3,1),
	BWeight NUMERIC(3,1)
);

--User table: OK
create table Borrower (
	BorrowerID INT IDENTITY(1,1) CONSTRAINT Borrower_PK PRIMARY KEY,
	BorrowerFirstName VARCHAR(20),
	BorrowerLastName VARCHAR(20),
	BorrowerBirthDate DATE,
	NrOfBooks INT DEFAULT 0 CONSTRAINT NrOfBooks_CHK CHECK (NrOfBooks >=0 AND NrOfBooks <=10)
);

--BookBorrow: OK
create table BookBorrowInfo (
	BookID INT CONSTRAINT BookBorrowInfo_Books_FK FOREIGN KEY REFERENCES Books(BookID),
	BorrowerID INT CONSTRAINT BookBorrowInfo_Borrower_FK FOREIGN KEY REFERENCES Borrower(BorrowerID), 
	BorrowDate DATE,
	ReturnDate DATE
);


select * from BOOKS bo
RIGHT JOIN BookTheme bt
on bo.ThemeID = bt.ThemeID
RIGHT JOIN TargetReader ta
on bo.TargetReaderID = ta.TargetReaderID
RIGHT JOIN Editor ed
on bo.EditorID = ed.EditorID
RIGHT JOIN BookType bot
on bo.BookTypeID = bot.BookTypeID
RIGHT JOIN Newspapers ne
on bo.NewspaperID = ne.NewspaperID
RIGHT JOIN ComicsSeries co
on bo.ComicSeriesID = co.ComicSeriesID
RIGHT JOIN BookSeries bos
on bo.BookSeriesID = bos.BookSeriesID
LEFT JOIN BookFormat bf
on bo.BookID = bf.BookID
LEFT JOIN BookAuthor ba
on bo.BookID = ba.BookID
--Author
RIGHT JOIN Authors au
on ba.AuthorID = au.AuthorID
--NEWSPAPER
RIGHT JOIN Frequency fr
on ne.FrequencyID = fr.FrequencyID
--Borrower
LEFT JOIN BookBorrowInfo boi
on bo.BookID = boi.BookID
RIGHT JOIN Borrower borr
on boi.BorrowerID = borr.BorrowerID

FOR XML AUTO, ELEMENTS, XMLSCHEMA;