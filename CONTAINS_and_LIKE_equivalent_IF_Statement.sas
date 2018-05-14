/* Both the IF and WHERE statements can be used to subset data. The LIKE operator in a WHERE clause matches patterns in words. */
data test;
input name $;
datalines; 
John
Diana
Diane
Sally
Doug
David
DIANNA
;
run;

/* This matches patterns that occur at the beginning of a string. */
data test2;
set test;
WHERE name like 'D%' ;
run;

/*To get the equivalent result in an IF statement, the '=:' operator can be used.  */
data test3;
set test;
if name =: 'D';
/*if name not =: 'D';*/  /* the syntax to select observations that do not match the pattern is below */
run;

/* The CONTAINS operator in a WHERE clause checks for a character string within a value. 
   To get the equivalent result in an IF statement, the FIND function can be used with the 'i' argument to ignore case. 
   Another alternative is to use the INDEX and UPCASE functions. */

data test4;
   set test;
   if find(name,'ian','i') ge 1;
   
run;

/* equivalent WHERE clause using the CONTAINS function */
data test5;
set test;
WHERE upcase(name) ? 'IAN' ;
/*where upcase(name) contains 'IAN';*/
run;
