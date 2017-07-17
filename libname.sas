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
	set dataset;
run;
libname g;

