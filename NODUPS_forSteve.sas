data yourdata;
format date date9.;
input @1 name $ @7 location $ @17 date date9. ;
datalines;
Steve Norfolk   16JUL1985 
Steve Norfolk   16JUL1990 
Steve Baltimore 12AUG1997
Elise Baltimore 22NOV1986 
Elise Columbia  16JUL1990 
Elise Baltimore 12AUG1997
;
run;

proc sort data= yourdata;
by name location;
run;

data yourdata2;
set yourdata;
by name location;
if first.name or first.location then output;
run;
