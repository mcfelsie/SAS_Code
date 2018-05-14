/************************************************
	Concatenate multiple rows into a single value
	- Using DATA step
	- Using PROC SQL 
*************************************************/

data inTable;
input letter $ number $;
datalines;
a 1
a 2
a 3
b 4
b 5
b 6
c 7
d 8
e 9
e 10
f 11
;
run;

data want;
length letter $8. cat $20.;
   do until (last.letter);
      set intable;
        by letter notsorted;
      cat=catx(',',cat,number);
   end;
   drop number;
run;

/* concatenate multiple rows into one row using SQL */

data have;
infile cards expandtabs truncover;
input ID	Num	Date : $20.	Result $	Type;
cards;
1	1	1/1/2013	words	1
2	10	1/10/2013	words	3
2	2	6/1/2014	words	4
2	5	7/1/2015	words	2
3	23	3/1/2014	words	1
3	4	6/2/2015	words	2
4	2	4/1/2013	words	1
;
run;


proc sql noprint;
 select max(n) into : n 
  from (select count(*) as n from have group by id);
quit;
proc summary data=have nway;
class id;
output out=want(drop=_:) idgroup(out[&n] (Num Date Result Type)=);
run;
