/****************************************************
  Convert "wide" formatted data into "long" formated data data

  Written: 23 May 2012
  Updated: 17 April 2018
*****************************************************/

data testscores (keep = score group);
set normtrunc;
score = posttest; group = "Posttest"; output;
score = pretest;  group = "Pretest"; output;
run;

data tmp;
input col1 col2 col3 col4;
cards;
1 2 3 4
1 2 3 4
;

data want;
set tmp;
array all_cols col1-col4;
  do over all_cols;
	dx = all_cols;
	output;
  end;
keep dx;
run;

proc sql noprint;
create table unique_codes as 
	select distinct(dx) from want;
quit;

proc print data=unique_codes;
run;
