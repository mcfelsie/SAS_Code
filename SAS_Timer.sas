/*******************************************************************************************
	SAS Timer - The Key to Writing Efficient SAS Code
	From SAS Blog by Leonid Batkhan

*******************************************************************************************/
/* Start timer */
%let _timer_start = %sysfunc(datetime());

*options fullstimer;

%macro test;

%do year = 2013 %to 2016;

data testing&year.;
year = &year.;
output;
run;

proc append data=testing&year. 
            base=allyears1;
run;

%end;

%mend;

%test;
/* Stop timer */
 data _null_;
  dur = datetime() - &_timer_start;
  put 30*'-' / ' TOTAL DURATION:' dur time13.2 / 30*'-';
run;


/* Start timer */
%let _timer_start = %sysfunc(datetime());
%macro test1(year);

data testing1&year.;
year = &year.;
output;
run;

proc append data=testing1&year. 
            base=allyears;
run;

%mend;

%test1(2013);
%test1(2014);
%test1(2015);
%test1(2016);

/* Stop timer */
data _null_;
  dur = datetime() - &_timer_start;
  put 30*'-' / ' TOTAL DURATION:' dur time13.2 / 30*'-';
run;
