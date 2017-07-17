/* Also see pdf called 'Format_CNTLIN' to create a format from
	raw data or a SAS dataset
*/


/* numeric format */
/*  dataset contains variable called 'group' that is either 1, 2, or 3 */
proc format;
value levels 
1="Control"
2="Thiouracil"
3="Thyroxin";
run;

data stats2;
set stats;
keep mean time group group_name;
where group ne .;
mean=week0_Mean; time=0; group=group; group_name=put(group, levels.); output;
mean=week1_Mean; time=1; group=group; group_name=put(group, levels.); output;
mean=week2_Mean; time=2; group=group; group_name=put(group, levels.); output;
mean=week3_Mean; time=3; group=group; group_name=put(group, levels.); output;
mean=week4_Mean; time=4; group=group; group_name=put(group, levels.); output;
run;

/************************************************************************/
/* Character format */
/* dataset contains variable called 'ra_body' that is either 'fitted' or 'processe'*/
proc format;
value $rabody
'fitted'="Fitted"
'processe'="Processed"
;
run;

ods graphics on/imagename="UKP1b_RAbody";
ods listing sge=on style=statistical gpath="P:\STATS\QARSC_RSST\RSST_Consulting\TIM_RSST_June2011\ZAPvsSep\RABody_Plots";
proc boxplot data=ukrabody;
title 'Distribution of US SEP Test P1b by Release Assembly Body Type';
plot p1b*ra_body / vref=0.10 ;
insetgroup min mean med max n/  position=top header="Summary Statistics" ;
label p1b="P1b";
label ra_body = "Release Assembly Body Type";
format ra_body $rabody.;
run;
ods graphics off;
ods listing close;

/************************************************************************/
/* Another numeric example */
proc format;
value status 
1="Single"
2="Married"
3="Not Living Together"
4="Divorced"
5="Widowed";
run;

/* using format function in sgplot*/
proc sgplot data=combine2;
where happiness2=1;
series x=year y=prop/group=marital_status;
xaxis values = (1989, 1992, 1995, 1997, 1999, 2001, 2003) label="Year";
yaxis values= (0.5 to 1.0 by 0.05) label= "Proportion";
label happiness2="Happiness";
label marital_status="Marital Status";
label prop="Proportion";
format marital_status status.;
run;

/* Can define two formats in same proc */
proc format;
value gender 0='male' 1='female';
value insert 1='first' 2='second';
run;

format fender gender. insert insert.;
/*************************************************************/

proc format;
 value year
 	.2004 -< .2005 = '2004'
	.2005 -< .2006 = '2005'
	.2006 -< .2007 = '2006'
	.2007 -< .2008 = '2007'
	;
 value pct
 	.94 -< .95 = '94'
 	.95 -< .96 = '95'
 	.96 -< .97 = '96'
 	.97 -< .98 = '97'
 	.98 -< .99 = '98'
 	.99 -< 1.0 = '99'
	1.0 -< 1.1 = '100'
	;
run;

