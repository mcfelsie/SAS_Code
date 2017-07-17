/*******************************************
   Using %nrstr() function with call execute 
   See SecretsofSASMacroQuoting.pdf for more details
*********************************************/

/* this macro call works, but doesn't use %nrstr */
data _null_;
  set patrol_info_mod6;
  macCall = '%readindata(cycle=%str('||"'" ||trim(cycle)||"'));" ;
  call execute (macCall);
run;

/* this macro call uses %nrstr() */
data _null_;
  set patrol_info_mod6;
  call execute('%nrstr(%readindata(cycle=%str('||trim(cycle)||')));');
run;

