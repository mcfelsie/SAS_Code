/* Long format from normaltrunc.sas*/

data testscores (keep = score group);
set normtrunc;
score = posttest; group="Posttest"; output;
score = pretest; group= "Pretest"; output;
run;


proc sort data=testscores;
by descending group;
run;

/* histogram of pre and post test scores*/
ods graphics on/imagename="TestScores_44";
ods listing sge=on style=statistical gpath="P:\STATS\SIRIUS";
proc univariate data=testscores noprint;
   title;
   class group (order=data) ;
   histogram score / normal notabcontents nrows = 2 endpoints = (0 to 1 by 0.1)  vaxis = (0 to 1 by 0.20);
   label score="Test Score";
run;
ods graphics off;
