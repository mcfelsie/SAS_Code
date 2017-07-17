ods output nlevels= numdevices_bymonth;
proc freq data=condense_maint nlevels ;
where FACILITY_AIRPORT ne 'NonOp';
by year month;
tables serial_number/noprint;
run;
