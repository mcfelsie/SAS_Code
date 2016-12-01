/************************************************
	Concatenate multiple rows into a single value

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
