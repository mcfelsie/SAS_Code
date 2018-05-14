/*************************************
    Logit Model for Adjacent Responses
	Example taken from pg 375 (Agresti 2002)
	Written: 26 March 2014 (SER)
**************************************/

data example;
input party $ ideology $ count xparty score;
interaction = xparty*score;
datalines;
Dem Lib 143 1 1
Dem Mod 156 1 2
Dem Con 100 1 3
Ind Lib 119 2 1
Ind Mod 210 2 2
Ind Con 141 2 3
Rep	Lib 15 3 1
Rep Mod 72 3 2
Rep Con 127 3 3
;
run;

proc genmod data=example order=data;
class party ideology;
model count = party ideology /dist=poi link = log lrci type3 obstats;
title 'Independence Model';
run; 

ods rtf file = "example.rtf";
proc genmod data=example order=data;
class party ideology;
model count = party ideology score*party/link=log dist=poisson lrci type3 ;
title 'Linear by Linear Association Model';
run;
ods rtf close;
