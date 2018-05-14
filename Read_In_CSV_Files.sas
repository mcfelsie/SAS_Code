/*****************************************************************************
  From Samples & SAS Notes (Sample 41880): Read all files from a directory and 
     create separate SAS® data sets with unique names

  This sample shows how to read all files in a directory and create separate 
  SAS data sets with unique names. Use the PIPE engine in the FILENAME statement 
  to access the directory information. Then, use Macro code with a %DO loop to 
  execute a DATA Step separately to read each of all files in the directory. 

  For this example there are four comma delimited files on the C:\ drive in the 
  directory folder called User. The file names are: file_info1.csv, file_info2.csv, 
  file_info3.csv, and file_info4.csv. 

  The first DATA Step is used to get the directory information to create a data set 
  that contains each full pathname of all files with a .csv extension. 

  The next DATA step uses _NULL_ in the DATA statement to avoid creating a SAS data 
  set since the purpose of this step is to create macro variables. On the SET statement 
  the END= option is used to create a variable that indicates when you have reached the 
  end of a data set. A variable called COUNT is created to increment each time an 
  observation is read to keep track of how many files there are. The first CALL SYMPUT 
  creates macro variables that each will contain the full pathname of each file to read. 
  The COUNT variable is used to create separate macro variables for each pathname. The 
  second CALL SYMPUT creates macro variables that each will contain a portion of the full 
  pathname to be used in the DATA statement to create a unique SAS data set for each file read. 
  The SUBSTR function is used to grab a portion of the file name so the values "info1", "info2", etc. 
  are extracted and will be used as the new SAS data set names. The last macro variable
  is created after all observations of the pathnames have been read in order to place the 
  total count of files that will be read into a macro variable called MAX. 

  The macro is created so that a separate DATA Step will be run for each file to be read
  from the directory. This is controlled by the macro %DO loop. The DATA statement uses 
  the macro variable with the %DO loops index variable i to use each of the separate 
  macro variables created that contain the unique data set names. The INFILE statement 
  uses the %DO loops index variable also except the separate macro variables created 
  contain each pathname. Because this sample is reading comma delimited files, the DSD 
  option and the TRUNCOVER option are used in the INFILE statement. If the input files 
  have records longer than 256 bytes then use the LRECL= option in the INFILE statement 
  to increase the size of the input buffer. 

********************************************************************/

%let root = %str(\\dom1\Core\Dept\GED\SSBA\Group\GSS\STATS\Launcher TFR Data Mining\Analysis_and_Results\);

filename DIRLIST pipe 'dir "&amp;root.\Launcher Data\*.csv" '; 

data dirlist ;                                               
infile dirlist lrecl=200 truncover;                          
input line $200.;                                            
if input(substr(line,1,10), ?? mmddyy10.) = . then delete;   
length file_name $ 150;                                      
file_name="&root.Launcher_Data\"||scan(line,-1," ");                    
keep file_name;
proc sort;
by file_name;
run;

data _null_;                                                 
set dirlist end=end;                                         
count+1;   /* count the number of files in the folder */                                        
call symput('read'||left(count),left(trim(file_name)));     /* 'read' contains the full pathname of each file to read */
call symput('dset'||left(count),substr(file_name,length(file_name)-24,0));    /* contain a portion of the full pathname to be used in the DATA statement to create a unique SAS data set for each file read */
if end then call symput('max',count);                        
run;                                                         

options mprint symbolgen;                                    
%macro readin;                                               
%do i=1 %to &max;                                            
                                                             
 data Part_&i;                                              
 infile "&&read&i" lrecl=1000 runcover dsd;
 run;                                                        
                                                             
%end;                                                        
%mend readin;                                                
                                                             
%readin;           
