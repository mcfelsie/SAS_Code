/*************************************************
	Calculate number of days in a month 
*************************************************/

data _null_;
date2 = mdy(01,01, 2013);
date3 = date();
format date2 date3 date9.;
put date2= date3=;
days3 = day(intnx('month', date2, 0,'end'));
days2 = day(intnx('month', date2, 0,'end'));
put days2 =  days3 =;
run;
