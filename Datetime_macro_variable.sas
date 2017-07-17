/**********************************************************
	Create a macro variable with the current date and time 
    to use for version control in log and output files
***********************************************************/

%let datetime = %sysfunc(compress(%sysfunc(today(),date9.)_%sysfunc(time(),hhmm6.), ': ') );

%put &datetime.;

