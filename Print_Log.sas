/**********************************************************
  Method to turn off the log for selected parts of your 
	SAS job. A log file will be created, but it will be very 
	short. 

Note: The first proc printto turns the log off and the 
	second turns it back on. 
***********************************************************/

filename junk dummy;
proc printto  log=junk; run; /* turn off log*/
      
/*INSERT YOUR CODE HERE*/ 

proc printto; run; /* turn on log*/


/***********************************************************************/
/* Assigns directory where this SAS program is located */
%let dir = %qsubstr(%sysget(SAS_EXECFILEPATH), 1, %length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILEname))); 
%let pgmname= %scan(%sysget(SAS_EXECFILENAME), 1, '.');  /* Gets name of this SAS program */
%let datetime = %sysfunc(compress(%sysfunc(today(),date9.)_%sysfunc(time(),hhmm6.), ': ') ); 							  
%let final1 = &dir.Logs\&pgmname._&datetime..log; 

proc printto log = "&final1";
run; 

proc printto; run;
/* Reminder: turn PRINTTO OFF at the end of process! */

