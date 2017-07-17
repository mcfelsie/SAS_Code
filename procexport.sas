proc export data=dataset outfile="P:\STATS\SASCode\outfile.xls"
	dbms=excel replace; /* can take out replace. do need the semicolon before sheet=*/
	sheet=sheetname;
run;
