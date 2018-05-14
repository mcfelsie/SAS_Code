/*Re: Merging two tables by choosing the CLOSEST dates */

data h1;
     infile cards dlm=',';
     input date :ddmmyy10. ticker $;
     format date ddmmyy10.;
     cards;
12/12/2008,ABC
4/6/2008,ABC
25/3/2010,DEF
6/2/2002,DEF
;
run;

data h2;
     infile cards dlm=',';
     input date :ddmmyy10. ticker $;
     format date ddmmyy10.;
     cards;
1/12/2010,ABC
1/12/2009,ABC
1/12/2008,ABC
1/12/2007,ABC
1/12/2006,ABC
1/12/2010,DEF
1/12/2009,DEF
1/12/2008,DEF
1/12/2007,DEF
1/12/2001,DEF
;

proc sql;
  create table want as
    select a.date,a.ticker, b.date as rpt_dt format=ddmmyy10.
      from h1 a
      left join
           h2 b
      on a.ticker=b.ticker
      where b.date <= a.date
      group by a.date,a.ticker
      having abs(a.date-b.date)=min(abs(a.date-b.date))
      order by a.ticker, b.date descending  ;
quit;

/**********************************************
  From 17_Exclude_SADR.sas  (366.00 PCAP)
**********************************************/

*get the earliest date PER FLAG;
proc sql;
create table ex.caper_ccc as
	select distinct EDI_PN, ccc_flag,  min(flag_date) as FLAG_DATE
	from (select distinct EDI_PN, ccc_flag, flag_date from ex.caper_all_flags where ccc_flag = 1) as TEMP
	group by EDI_PN
;
create table ex.caper_pen as
	select distinct EDI_PN,
		pen_flag,
		min(flag_date) as FLAG_DATE
	from (select distinct EDI_PN, pen_flag, flag_date from ex.caper_all_flags where pen_flag = 1) as TEMP
	group by EDI_PN
;
create table ex.caper_other as
	select distinct EDI_PN,
		other_flag,
		min(flag_date) as FLAG_DATE
	from (select distinct EDI_PN, other_flag, flag_date from ex.caper_all_flags where other_flag = 1) as TEMP
	group by EDI_PN
;
quit;
