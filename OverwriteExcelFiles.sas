/*********************************************
   Code to overwrite existing Excel sheets
   Written: 5 Feb 2014 (SER)
*********************************************/

/*Code to overwrite existing Excel sheets*/
proc datasets lib=work nolist; 
  delete sheetname sheetname2 /*<-- you can list multple sheets to delete */;
run;
quit;


