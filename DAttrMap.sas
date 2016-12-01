
/* Need variables "ID", "value", and "linecolor" */
/* East Coast is blue, West Coast is Green, UK is Red */
/* "No corrective action" is blue, "adjustment" is green, "repair" is red, "replacement" is light blue */
/* Can use color names instead of cx numbers */
data library.myattrmap;
input @1 ID $4. @7 value $20. @29 linecolor $8. @39 fillcolor $8.;
datalines;
myid  East Coast  			cx5B6DC7  cx5B6DC7
myid  West Coast  			cx6DC75B  cx6DC75B
myid  UK         			cxC75B6D  cxC75B6D
myid  No Corrective Action	cx5B6DC7  cx5B6DC7
myid  Adjustment		  	cx6DC75B  cx6DC75B
myid  Repair      			cxC75B6D  cxC75B6D
myid  Replacement 			cx1EC5FC  cx1EC5FC
;
run;


/* Create fringe plot of TFRs over time, paneling by coast (East, West, UK) */
/* add the 'dattrmap=' to the proc sgpanel (or sgplot) statement */
/* add 'attrid=' to fringe, scatter, vbar, etc. statment*/
ods  _ALL_  close;
ods listing sge=off style=statistical gpath="&gpathCoast.";
ods graphics on/border=off reset=index imagename="&title." ANTIALIASMAX=1000 width=12in height=5in ;
proc sgpanel data=hardware_TFRs2 dattrmap=library.myattrmap;
title &title. ;
where pn1_first = &pn. ;
panelby coast /novarname columns=1 onepanel sort=data headerattrs=(size=12 weight=bold);
fringe evnt_date / group=actn height=2in attrid=myid; 
label count = "Number of TFRs:" percent2 = "Percent of TFRs:";
format actn $actn.;
inset count percent2 /position=topleft opaque border;
colaxis label='Date Problem was Detected' interval=year grid gridattrs=(color=CXC8CBCC pattern=shortdash) 
		labelattrs=(size=12 weight=bold) valueattrs=(size=10 weight=bold) ;
rowaxis values=(0.8 to 1.2 by 0.1) display=(novalues noticks nolabel) ;
keylegend /title="" position=top sortorder=ascending;
refline '01JUL2006'd /axis=x splitchar='Last Accomplishment Date SPALT 2537' lineattrs=(pattern=1 color=black thickness=3px); 
run;
ods graphics off;
