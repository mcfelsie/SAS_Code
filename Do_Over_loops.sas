/* As stated before, ARRAYs and DO loops can be used for a variety of data manipulation needs from assigning or
reassigning values, renaming variables, creating new variables from existing variables, simulating data, creating
randomization schemes, and changing the data structure. */

data list;
set in.list1;
array aquest q1-q20;
do over aquest;
if aquest=. then aquest=0;
end;
run;
