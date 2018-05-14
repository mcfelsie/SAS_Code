/* Using NLEVELS option in PROC FREQ*/
ods output nlevels= numdevices_bymonth;
proc freq data=condense_maint nlevels ;
where FACILITY_AIRPORT ne 'NonOp';
by year month;
tables serial_number/noprint;
run;

/* Counting number of distinct EDIPNs */
proc sql;
select distinct count(EDIPN)
from out.lipids_caper;
run;

/* Save number of records to a macro variable */
proc sql noprint;
select count(*)
into :OBSCOUNT
from sasuser.acities;
quit;

%put Count=&OBSCOUNT.;
