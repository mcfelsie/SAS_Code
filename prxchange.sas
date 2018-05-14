/*********************************************************** 
   Code to change &, /, and \ to _ for Excel file names 
   Was used in Trends Automation Code
   Here’s the data step form and macro form. I think the macro should work fine. 
   Sample has ‘&/\’ which it replaces with ‘_’. 
   Written: 6 Feb 2014 (SGM)
***********************************************************/

%let file = %nrstr(test&more\test/.xls) ;

data test ; 
  retain test_str "&file." ;
  newstr = prxchange('s/[&\\\/]/_/',-1,test_str) ;
  put newstr=; 
 run;
%let pattern = %sysfunc(prxParse(s/[&\\\/]/_/)) ;
%let newstr = %sysfunc(prxchange(&pattern ,-1,%str(&file) )) ; %put newstr=&newstr ;


data test ;
 o="aa-aaa";
 n= prxchange('s/\-/_/', -1, o);
 put n =;
run;

/**********************************************************/


/* Want newstr to become '=Reliability!$B$4*Backup!$D9'
      and newstr2 to become '=Reliability!$B$4*Backup!$D25' 
   Only increment the number at the very end 
*/

data test2;
string = '=Reliability!$B$4*Backup!$D8';
string2 = '=Reliability!$B$4*Backup!$D24' ;
test = scan(string2,4,'$D'); put test = ;
t = scan(scan(string2,4,'$'),2,'D'); put t= ;
newstr=scan(string2,1,'$')||'$'||scan(string2,2,'$')||'$'||scan(string2,3,'$')||'$D'||put(input(scan(string2,4,'$D'),2.)+1,2.);
newstr2 = scan(string2,1, , 'bkd');
put newstr = ;
put newstr2 = ;
run;
