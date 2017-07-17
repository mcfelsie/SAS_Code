data _null_;
date2 = mdy(01,01, 2013);
format date2 date9.;
put date2=;
days = day(intnx('month', date2, 0,'end'));
put days = ;
run;
