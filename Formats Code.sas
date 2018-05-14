/* Also see pdf called 'Format_CNTLIN' to create a format from raw data or a SAS dataset */

* Read in permanent format stored on MDR ;
options fmtsearch = (work library pcap);

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
/* Format using ranges and lists */
proc format ;
value $grade
'A' = 'Good'
'B' - 'D' = 'Fair'
'F' = 'Poor'
'I', 'U' = 'See Instructor';
run;

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
 	2004 - <2005 = '2004'
	2005 - <2006 = '2005'
	2006 - <2007 = '2006'
	2007 - <2008 = '2007'
	;

/* can use LOW and HIGH to specify lower and upper limits 
   can use OTHER to label missing values */
 value pct
    low  - <0.94 = 'low'
 	0.94 - <0.95 = '94'
 	0.95 - <0.96 = '95'
 	0.96 - <0.97 = '96'
 	0.97 - <0.98 = '97'
 	0.98 - <0.99 = '98'
 	0.99 - <1.0 = '99'
	1.0 - high = '100'
	other = 'unknown'
	;
run;

proc format;
value dtfmt   
'14may2015'd - '14jul2015'd = "first 3 months"
'15jul2015'd - '15oct2015'd = "middle"
'16oct2015'd - '16dec2015'd = "last 3 months"
'17dec2015'd - '26jan2016'd = "wrap-up"
other = [mmddyy10.];
run;


/* Code used in P:\STATS\SeaStateStudy\SeaState.sas */
/* SSintervals contain the start and end times of sea states*/
/* timeObs contains the observed times*/
/* use the intervals in SSintervals to assign sea states to times in timeobs */

data SSintervals ;
format startI endI datetime16. ;
  input ss $2. +1 startI datetime16. +1 endI datetime16. ;
  datalines;
1H 01jan12:00:00:00 01jan12:23:23:59
2L 02jan12:00:00:00 02jan12:23:23:59
2H 03jan12:00:00:00 03jan12:23:23:59
3L 04jan12:00:00:00 04jan12:23:23:59
;
run;

data timeObs ;
  format timeObs datetime16. ;
  input timeObs datetime16. ;
  datalines ;
01jan12:00:23:59
03jan12:00:23:59
02jan12:00:23:59
04jan12:00:00:59
01jan12:00:11:59
;
run;

data intervalFmt ;
  length fmtname $8 type $1 start end $16 label $40 ;
  retain fmtname 'ssTI' type 'N' ;
  set ssIntervals ;
  label = ss ;
  start = put(startI,16.) ;
  end = put(endI,16.) ;
run;

proc format library=work cntlin=intervalFmt ; run;

data test ;
  length seaState $2. ;
  set timeObs ;
  seaState = put(timeObs,ssti.) ;
run;

/********************************************/
/* "mutilevel" format */

/* The goal is to assign an airport code based on a serial number and event date 
   One format was created for each serial number since some devices moved to another airport 
   So this data step is creating like 200+ formats because there are 200+ devices
*/
data intervalFmt (keep=fmtname type start end label );
  length fmtname $8 type $1 start end $40 label $40 ;
  retain fmtname 'ssTI' type 'N' ;  /* ssTI gets overwritten, so doesn't matter */
  /* Since start is numeric, need to put type 'N' */
  set deployment_dtls ; /* this data set contained the serial number, start and end dates of deployment, and the airport code*/
  fmtname = 's'||put(serial_number,6.)||'n';  /* ex: S181497n .  Needs to start and end with a character so added the 's' and 'n'*/
  label = facility_airport ;  /* this is the airport code, like BWI*/
  start = datepart(start_date); /* this assigns the start of the interval, taking just the date part */
  if end_Date eq . then end = '31Dec2015'd; /* some devices did not move, so assigned the end date to end of Q4 */
  else end = datepart(end_date);  /* if a device moved, then assign the end of the interval*/
run;

proc format library=work cntlin=intervalFmt ; run; quit;

/* Applying format to add airports */
data warning_dtls_downtimes2 ;
  set warning_dtls_downtimes ;
  facility_airport = putn(datepart(full_event_date),'s'||put(serial_number,6.)||'n.');
run;



/********************************************************************/
/* Create and apply a format where the label is a date */

data date_of_birth;
retain type 'C' fmtname '$dob_roster';
start = '234'; label = '09jan2018'd ; output;
start = '123'; label = '07jan2018'd ; output;
start = '789'; label = '03jan2018'd ; output;
run;

** Create format of birthdates **;
proc format cntlin = date_of_birth library=work; run;

data test;
edipn = '234' ; patdob = input(put(edipn, $dob_roster.), 5.); output;
edipn = '123' ; patdob = input(put(edipn, $dob_roster.), 5.); output;
edipn = '789' ; patdob = input(put(edipn, $dob_roster.), 5.); output;
format patdob date9.;
run;

/*******************/
/* Another way to apply a format with a date as a label */
proc format ;
value $ birthdate
'E00001' = '01JAN1963'
'E00002' = '08AUG1946'	
'E00003' = '23MAR1950'
'E00004' = '17JUN1973'
'E00005' = '18JUN1979'
other = '01JAN2019'
;
run;

data test;
set sasuser.empdata;
birthdate = input(put(EmpId, $birthdate.), date9.);
format birthdate date9.;
run;
