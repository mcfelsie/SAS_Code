/*****************************************************************************************
 From Samples & SAS Notes #58955
    There are a number of procedures that you can use to find the top 1% and bottom 1% of 
	data values, including PROC RANK, PROC SQL, and PROC UNIVARIATE. The example code below
	uses PROC SUMMARY and DATA step logic to create macro variables that contain the 1st 
	and 99th percentile values. These macro variables can be used for further processing to
	subset the original data set.

	If you would like to choose different percentages in place of P1 and P99 below, you can 
	choose any of the percentile statistics that are available in the OUTPUT statement of 
	the MEANS or SUMMARY procedure.
*********************************************************************************************/

/* Create sample data */
data test;                   
   do i=1 to 10000;                                                     
      x=ranuni(i)*12345;                                         
      output;                                                         
   end; 
   drop i; 
run;     

proc sort data=test;
   by x;
run; 
                                                                      
/* Output the 1st and 99th percentile values */                         
proc summary data=test;                                               
   var x;                                                       
   output out=test1 p1= p99= / autoname;                               
run;                                                                 
                                                                      
/* Create macro variables for the 1st and 99th percentile values  */     
data _null_;                                                         
   set test1;                                                         
   call symputx('p1', x_p1);                                     
   call symputx('p99',x_p99);                                     
run;    
%put &p1;
%put &p99; 
                                                                      
data test2;                                                             
   set test;                                                           
/* Use a WHERE statement to subset the data  */                         
   where &p1 le x le &p99;                                       
run;  

proc print;
run; 
