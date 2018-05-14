/*******************************************************
	How to format a macro variable
	October 16, 2017
	by Jim Simon on SAS Learning Post

*******************************************************/

/* create it, like this:*/

%macro format(value,format);
	%if %datatyp(&value)=CHAR
		%then %sysfunc(putc(&value,&format));
		%else %left(%qsysfunc(putn(&value,&format)));
%mend format;
 

/*The %FORMAT function also accepts user-defined formats, like this:*/

proc format;
value $grade
'A' = 'Excellent'
'B' = 'Good'
'C' = 'Fair' ;

value range
0-9 = 'Low'
10-99 = 'Medium'
100-999 = 'High';
run;

%put %format(A, $grade.);
%put %format(50, range.);

/*The PROC SQL step below creates the macro variable HIGHSALARY, which is referenced in the TITLE statement and formatted with the user-defined %FORMAT function.*/

proc sql noprint;
	select 5*avg(salary) into :highsalary
		from orion.staff;
 	reset print;
 	title "Salaries over %format(&highsalary,dollar11.2)";
 	select employee_ID, salary 
		from orion.staff
			where salary > &highsalary
				order by salary desc;
quit;
 
/*Be sure to save your user-defined %FORMAT function in your stored compiled macro or autocall library for convenient re-use */

