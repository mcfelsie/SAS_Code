/********************************************************************************
In SAS 9.3 there is a new system option that simplifies this: DLCREATEDIR. 
When this option is in effect, a LIBNAME statement that points to a non-existent 
folder will take matters into its own hands and create that folder.

http://blogs.sas.com/content/sasdummy/2013/07/02/use-dlcreatedir-to-create-folders/

Here's a simple example, along with the log messages:
********************************************************************************/

options dlcreatedir;
libname newdir "/u/sascrh/brand_new_folder"; 

/*
NOTE: Library NEWDIR was created.
NOTE: Libref NEWDIR was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: /u/sascrh/brand_new_folder
*/
