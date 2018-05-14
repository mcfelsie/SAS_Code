/*****************************

Using the FCMP procedure

*****************************/

proc fcmp outlib = sasuser.mymacs.cytofy;
function CYtoFY(date);
  
/* Convert calendar year of date to fiscal year */
 if month(date) in (10, 11, 12) then fydate = year(date) + 1; 
 else fydate = year(date); 

/* Convert calendar month of date to fiscal month using SAS <mod> function */
 fmdate = mod(month(date) + 2, 12) + 1;
 fdate = mdy(fmdate, day(date), fydate);
 return (fdate);
endsub;
quit;

proc fcmp outlib = sasuser.mymacs.fytocy;
function FYtoCY(date);
  
/* Convert fiscal year of date to calendar year */
 if month(date) in (1, 2, 3) then cydate = year(date) - 1; 
 else cydate = year(date); 

/* Convert fiscal month of date to fiscal month using SAS <mod> function */
 cmdate = mod(month(date) + 8, 12) + 1;
 cdate = mdy(cmdate, day(date), cydate);
 return (cdate);
endsub;
quit;

options cmplib = (sasuser.mymacs);

data test;
  date = today();
  fy_date = CYtoFY(date);
  cy_date = FYtoCY(fy_date);
  output;
format date fy_date cy_date mmddyy10.;
run;
