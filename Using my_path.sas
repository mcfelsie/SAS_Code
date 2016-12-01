/*******************************************************************
The code may look like jibberish but it figures out the path to your 
working directory no matter where it is. Therefore, if you keep your
program and input data in the same working directory your FILENANE statements can 
look like: 

 FILENAME myfile "&my_path.my_data.dat";

If you move your program and data to another folder (even on a different machine), 
including the "my_path" line in your program will have saved you the trouble of 
typing a messy and changing path name for FILENAMES and for LIBNAMES.
**********************************************************************/

/*Add the following line of SAS code to the top of your program*/
%let my_path = %qsubstr(%sysget(SAS_EXECFILEPATH), 1,
			   %length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILEname)));

/* Test it out */
%put &my_path;

/***************************************************************/
%let test =  %scan(%sysget(SAS_EXECFILEPATH), -2, '\');
%put &test;

%let test2 = %qsubstr(%sysget(SAS_EXECFILEPATH), 1, %length(&my_path)) - %length(&test.));
%put &test2.;

FILENAME PSYCH "&my_path.T5_1_PSYCH.dat"; /* Revised FILENAME; Note the "&" */
DATA SCORES;
  INFILE PSYCH;
  INPUT Sex Test1 Test2 Test3 Test4;
TITLE 'EXAMPLE 8.3';

filename envcmd pipe 'set' lrecl=1024;
data xpset;
infile envcmd dlm='=' missover;
length name $ 32 value $ 1024;
input name $ value $;
run;

%put %sysget(CD);
