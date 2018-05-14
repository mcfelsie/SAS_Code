/* SAS 9.4*/
libname g pcfiles path="P:\STATS\SASCode\filename.xlsx" ;

/* SAS 9.3*/
libname g pcfiles path="P:\STATS\SASCode\filename.xlsx";

/* SAS 9.2*/
libname g excel "P:\STATS\SASCode\filename.xlsx";

libname g;

/* How to save a data set to a sheet in excel */
libname g pcfiles path="P:\STATS\SASCode\filename.xlsx";
data g.sheetname;
	set SASdataset;
run;
libname g;

/* How to read in an excel sheet */
libname g pcfiles path="P:\STATS\SASCode\filename.xlsx";
data SASdataset;
set g.'sheetname$'n;
run;
libname g;
