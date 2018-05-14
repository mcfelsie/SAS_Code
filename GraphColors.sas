/***************************************************
1 light green CX4AA02C
2 d green CX254117 
3 orange CXF87431 
4 brown CXA52A2A 
5 white CXFFFFFF 
6 dark purple CX461B7E 
7 purple CX6C2DC7 
8 light purple CXF433FF 
9 DarkRed CX8B0000
10 Med Viotetred CXC71585
11 hot pink CXFF69B4

******************************************************/

proc registry list startat="COLORNAMES"; run;

proc sort data=africom_sim3 out=africom_sim4;
by subregion cluster;
run;

proc template;
  define style colors;
  parent=styles.default;
  style graphdata1 from graphdata1 / contrastcolor=CX4AA02C;  
  style graphdata2 from graphdata2 / contrastcolor=CXF87431; 
  style graphdata3 from graphdata3 / contrastcolor=CX254117; 
  style graphbackground /contrastcolor = CXFFFFFF;
  end;
run;

ods listing style=colors;
ods graphics on/imagename="AfriCom_CentralAfrica";
ods listing sge=off gpath="H:\Work\NLGCCriteria\ClusterGraphs";
proc sgplot data=Africom_sim4;
where subregion='Central Africa';
scatter y=cap x=coop/group=cluster legendlabel='Cluster Grouping' markerattrs=(symbol=circlefilled);
yaxis values=(0 to 1 by 0.1) label = 'Capability';
xaxis values=(0 to 1 by 0.1) label = 'Cooperation';
title;
label cluster = 'Cluster Grouping';
run;
ods graphics off;

/*************************************************************************************************************/

proc template;
	define style HAcolors;
	parent=styles.statistical;
	style graphdata1 from graphdata1 / contrastcolor=CX003451; /* HA Dark Blue */  
	style graphdata2 from graphdata2 / contrastcolor=CXFDB913; /* HA Gold */
	end;
run;
