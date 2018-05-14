/**********************************************************
	Code for naming ods graphics files

    gsfmode=replace; can be used to replace an 
		existing graphics output file with a new graph. 
**********************************************************/

ods  _ALL_  close;
ods listing sge=off style=statistical image_dpi=300 gpath="u:\sasTest" ;
ods graphics on/border=off reset=index imagename="myName" ANTIALIASMAX=1000 ;
proc sgplot data=mydata;
reg x=age1 y=SEP_KE_equivalent/ clm legendlabel="UK ZAP";
reg x=tc_age y=UK_KE/ clm clmtransparency = .8 legendlabel="UK RAFT";
inset "UK RAFT p=0.0381" "UK ZAP p=0.1540" /position=topright; 
xaxis values =(0 to 30 by 10) label="Age";
yaxis values =(80 to 100 by 5) label = "Kinetic Energy";
label tc_age = "TC Age"; 
run;
ods graphics off;


/* to supress titles when using a by statement */
options nobyline; /* this comes before proc */

proc sgplot data=one;
by var1;
option nobyline;  /* or can write it within proc */
etc....;

run;
