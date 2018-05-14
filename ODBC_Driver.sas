/***********************************************************************
	For the new versions of Microsoft SQL Server they recommend using 
	ODBC drivers as OLEDB has been deprecated. 
	Here are some examples

************************************************************************/

proc sql;
connect to odbc as sdb (noprompt="Trusted_Connection=yes; driver=SQL SErver Native Client 11.0; database=summarydb;server=slbmdb03");
...
;

proc sql;
libname twx odbc
	noprompt="driver=SQL Server Native CLient 11.0;
			  server SLBMDB01 ;
			  database=TWX;
			  Trusted_Connection= yes"
	schema = dbo ;
libname sdb odbc
	noprompt="driver=SQL Server Native CLient 11.0;
			  server SLBMDB03 ;
			  database=SummaryDB;
			  Trusted_Connection= yes"
	schema = dbo ;
quit;

