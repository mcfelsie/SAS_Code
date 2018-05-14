data one;                  
  input id $ fruit $;      
datalines;                 
a apple                    
a apple                    
b banana                   
c coconut                  
c coconut                  
c coconut                  
;                          
                           
data two;                  
  input id $ color $;      
datalines;                 
a amber                    
b brown                    
b black                    
c cocoa                    
c cream                    
;               
 
data every_combination;

  /* Set one of your data sets, usually the larger data set */
  set one;
  do i=1 to n;

    /* For every observation in the first data set,    */
    /* read in each observation in the second data set */ 
    set two point=i nobs=n;
    output;
  end;
run;
/* N = 30 */

proc sql;
create table sql_combos as
select *
  from one, two;
quit;
/* N = 30 */
/* note: the order of the records is different */
