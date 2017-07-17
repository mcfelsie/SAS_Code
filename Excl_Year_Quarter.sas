/***********************************************
   From Trends software
   Grabs excl_year from Dashboard, parses out 
   years and quarters for exclusion in 
   regression analysis.
   Q1 = yyyy.125, Q2 = yyyy.375, 
   Q3 = yyyy.625, Q4 = yyyy.875
************************************************/

%macro year_excl_prepare(excl_year) ;
   %global excl_qtr ;
   %let i = 1 ;
   %let excl_qtr = ;
   %do %while (%scan(&excl_year,&i,%str(,)) ne ) ;
       %let ex = %upcase(%scan(&excl_year,&i,%str(,)));
	   %if %index(&ex,Q) ne 0 %then %do ; /* handle quarter case */
	       %let q = %substr(&ex,%eval(%index(&ex,Q)+1),1) ; /*extract quarter */
		   %let y = %substr(&ex,%eval(%index(&ex,Q)-4),4) ; /*extract year */
		   %let e_q = %sysevalf(&y + (&q -1)* 0.25 + 0.125) ;
		%end;
	   %else %do; /* handle year case */
	   		%do q = 1 %to 4 ;
			    %let qtr = %sysevalf(&ex + (&q -1) * 0.25 + 0.125) ;
				%if &q = 1 %then %let e_q = &qtr ;
				%else %let e_q = &e_q,&qtr;
			 %end ; /* end %do */
		%end ; /* end %else %do */
		%if &excl_qtr = %then %let excl_qtr = &e_q ;
		%else %let excl_qtr = &excl_qtr,&e_q ;
		%let i = %eval(&i +1);
	%end ; /* end %do %while */
%mend;

%year_excl_prepare(%str(2005,2006Q2));

%put excl_qtr = &excl_qtr ;


	       
