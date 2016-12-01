/***********************************************************************
The DUPOUT= option of PROC SORT specifies a SAS data set that is used 
to store observations eliminated from a sorted data set when the NODUPKEY 
option is employed.  SAS sorts the specified data set and each observation
that has duplicate BY statement variable values is written to the 
DUPOUT= data set as it is eliminated from the sorted data set.  

Here is an example:
***********************************************************************/

proc sort nodupkey
      data=sashelp.class
      out=sorted_class
      dupout=dupkeys
      ;
      by sex age;
run;
