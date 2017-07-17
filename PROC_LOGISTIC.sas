 proc sort data=ps_prepare; by & category year ; run;   

 /* add in partial years for graphs (to make 'year' a pseudo-continuous variable    */
data ps_prepare_g (drop=st_year i);
   set ps_prepare ;
   output ;
   st_year = year ;
   do i = 1 to &granular ; /* defines granularity of data between years */
      year = st_year + (i/(&granular + 1)) ; /* for Trends analysis we set granular = 5*/
      failures = . ;
      output ; 
    end ;
run;  

ods results=off;
ods listing close ;
ods select none ;
ods table ParameterEStimates = parm_est;
   proc logistic data=ps_prepare_g alpha=0.05 ; /*Specifies alpha for the  confidence intervals*/
     by category ;
     model failures/tests=year /scale=none covB; 
     output out=log_parms predicted=fit lower=lcl upper=ucl ;
   run;
ods select all ;
ods listing ;
ods results=on;

data plotdata; set log_parms; prob=failures/tests; run;
proc sort data=plotdata; by category year; run ;

ods results=off ; ODS _ALL_ close;
ods listing sge=off style=statistical image_dpi=300 gpath="&gpath" ; 
ods graphics on / border=off reset=index imagename="&new_img_name." ANTIALIASMAX=1000 ;
proc sgplot data=plotdata ;
title1;      
band x=year lower=lcl upper=ucl/legendlabel= "90% Confidence Limits" name="band1" outline fill;
scatter x=year y=prob/markerattrs=circle legendlabel ="Failure Probability" name="probs";
series x=year y=fit /legendlabel="Logistic" name="series";
label prob = "Failure Probability";     
label year="Year";
refline &f_avg /legendlabel="Force Average (&fsl)" name="refline" axis=y lineattrs=(pattern=4 color=black) transparency=0.4 ;
keylegend "series4" "probs4" "band4" "series6" "probs6" "band6" "refline" /across=3; 
xaxis values =(2004 to 2013 by 1);
yaxis values = (0 to &y_max by &y_scl);
run; quit;
ods graphics off ; 
ods listing ;
ods results=on ;
