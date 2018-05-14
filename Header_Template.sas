/*********************************************************************************************************
	Project:

	Program: 
 
	Description: 

	Data:
 
	Output:

	Programmer: 

	Run Time:

	Date:
*********************************************************************************************************/

/* Directory for log and output */
%let dir1=%substr(%sysfunc(getoption(sysin)), 1,  %length(%sysfunc(getoption(sysin))) - %length(%scan(%sysfunc(getoption(sysin)), -1, '/')));
%let pgmname= %scan(%scan(%sysfunc(getoption(sysin)), -1, '/'), 1, '.');
%let final1=&dir1.Log/&pgmname._&sysdate._&systime..Log;

proc printto log="&final1";
run; quit;

/* Define sas formats by calling program that stores them */
%include "/navy/nmcphc/SAS_Formats/MDR_Format_Master_ses.sas";

/** Unix Change Permissions – Initial Files **/
X chmod 0770 "&final1." "&dir1.&pgmname..sas" "&dir1.&pgmname..log";

/* Output library for SAS data sets for this project */
libname out "&dir1.Output" ;  

options mlogic mprint formdlim="~" fmtsearch = (out work library);

/******************************************************************************************************************************/



/******************************************************************************************************************************/
/** Unix Change Permissions – Final Files **/
X chmod 0770 "&dir1.&pgmname..lst" "&dir1.Output/name_of_SAS_dataset.sas7bdat" ;

/* Send email when SAS program finishes */
X 'echo "&pgmname..sas has completed" | mailx -s "Check Your Program" sarah.e.roberts52.ctr@mail.mil' ;
