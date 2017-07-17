/****************************************************************************************************************/
/* 		Using PROC IMPORT to import data 										   								*/
/*																												*/
/* 		This code includes the syntax for proc import statement and two examples								*/
/*																												*/
/* 		> libref is the library reference where your data set will be stored. This is typically 'Work' 			*/															
/*																												*/
/*      > If you are using the work library, you don't have to put anything into 								*/
/*				<libref.>, SAS will know to put it in the work library by default								*/
/*																												*/
/* 		> The REPLACE option overwrites an existing SAS data set. I usually add this 							*/
/*			because if I find mistakes in the dataset and then I have to reimport 								*/
/*				the data, this tells SAS to overwrite the old dataset 											*/
/*																												*/
/* 		> This website explains what the options GETNAMES, MIXED, SCANTEXT, etc.: 								*/
/* 			http://support.sas.com/documentation/cdl/en/proc/61895/HTML/default/viewer.htm#a000312413.htm 		*/
/*																												*/
/* 		Written: September 22, 2011 (SER)																		*/
/****************************************************************************************************************/


/* Syntax comes from http://support.sas.com/documentation/cdl/en/proc/61895/HTML/default/viewer.htm#a000308090.htm */

proc import DATAFILE="filename" 
OUT=<libref.>SAS data-set <(SAS data-set-options)> 
<DBMS=identifier><REPLACE> ; 
run;

/* This is a general example of the code  */
/* You should only have to change datafile=, out=, and range= statements*/
/* Entries are case sensitive, so make sure letters are correctly captilized or lower case */
proc import DATAFILE="yourfile.xls"  /* the name of the excel file where your data comes from*/
			OUT= work.dataset      /* what you want to name the dataset */
			DBMS=EXCEL REPLACE ; 
			RANGE="'Sheet_Name$'";   /* this is the name of your excel sheet. You need both " and '. */
			GETNAMES=YES;
     		MIXED=NO;
     		SCANTEXT=YES;
     		USEDATE=YES;
     		SCANTIME=YES;
run;

/* I used this code to import an excel sheet I had */
PROC IMPORT OUT= WORK.mydata 
            DATAFILE= "P:\STATS\QARSC_RSST\RSST_Consulting\TIM_RSST_June 2011\ZAPvsSep\ukupdate.xls" 
            DBMS=EXCEL REPLACE;
     		RANGE="'#LN00018$'";  /* #LN00018$ was the name of the excel sheet that contained my data. Your sheet probably has a real name :p  */
     		GETNAMES=YES;
     		MIXED=NO;
     		SCANTEXT=YES;
     		USEDATE=YES;
    		SCANTIME=YES;
RUN;


