/* Homework #1 */
/* Problem 2 */

/* creating matrix of possible group assignments*/
proc factex;
factors f1-f12;
output out=malaria;
run;

/* subset of the 924 possible assignments that are balanced*/
data subset;
set malaria;
if sum(of f1-f12)=0;
run;

/* matrix c contains all possible outcomes. 
   matrix is stored in dataset 'out' */
proc iml;
use work.subset;
read all into mat;
print mat;
v={8.62 0.06 1.48 1.72 8.93 2.19 9.57 7.32 2.65 7.53 7.3 7.62};
w=t(v);
c=(mat*w)/6;
print c;
create out from c;
append from c;
quit;

/* out2 contains the statistics more extreme than the observed statistic = 2.01833*/
/* there are 248 more extreme statistics*/
data out2;
set out;
if COL1 > 2.01833 or COL1 < -2.01833;
proc sort;
by col1;
run;

/* b. 1000 times */

proc surveyselect data=out out=sample method=urs n=1000 seed =1986; run;

data sampleout;
set sample;
if COL1 > 12.11 or COL1 < -12.11;
run;

/*c. t-test */
data parasite;
input measure group;
datalines;
8.62 1
0.06 2
1.48 1
1.72 2
8.93 1
2.19 2
9.57 1
7.32 2
2.65 1
7.53 2
7.3 1
7.62 2
;
run;

proc sort;
by group;
proc ttest data=parasite;
class group;
var measure;
run;


/* Problem 3 */
/* a. */

proc factex;
factors f1-f6;
output out=malaria2;
run;

data two (drop= f1-f6);
set malaria2;
if f1= -1 then do; g1=1; g2=-1; end; 
else if f1= 1 then do; g1=-1; g2= 1; end;
if f2= -1 then do; g3=1; g4=-1; end; 
else if f2= 1 then do; g3=-1; g4= 1; end;
if f3= -1 then do; g5=1; g6=-1; end; 
else if f3= 1 then do; g5=-1; g6= 1; end;
if f4= -1 then do; g7=1; g8=-1; end;
else if f4= 1 then do; g7=-1; g8= 1; end;
if f5= -1 then do; g9=1; g10=-1; end;
else if f5= 1 then do; g9=-1; g10= 1; end;
if f6= -1 then do; g11=1; g12=-1; end;
else if f6= 1 then do; g11=-1; g12= 1; end;
run;

proc iml;
use work.two;
read all into mat2;
v={8.62 0.06 1.48 1.72 8.93 2.19 9.57 7.32 2.65 7.53 7.3 7.62};
w=t(v);
d=(mat2*w)/6;
create two2 from d;
append from d;
quit;

/* out2 contains the statistics more extreme than the observed statistic = 2.01833*/
/* there are 22 more extreme statistics (out of 64)*/
data two3;
set two2;
if COL1 > 2.01833 or COL1 < -2.01833;
proc sort;
by col1;
run;

/* b. 1000 times */
proc surveyselect data=two2 out=sample method=urs n=1000 seed =1986 outhits; run;

data sampleout;
set sample;
if COL1 > 2.01833 or COL1 < -2.01833;
run;

/* c. ttest*/
data parasite2;
input pair placebo vitamin;
datalines;
1 8.62 0.06 
2 1.48 1.72 
3 8.93 2.19
4 9.57 7.32
5 2.65 7.53
6 7.3 7.62
;
run;

ods rtf;
proc ttest data=parasite2;
paired placebo*vitamin;
run;
ods rtf close;
