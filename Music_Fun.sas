* SAS Music Code! ;

*TEST CALL SOUND;
*Middle C for 2 seconds;
data _null_;
	call sound(261.63,2000);
run;


*TEST CALL SOUND - Beethoven's 5th in C minor ;
data _null_;
	call sound(392, 125);
	call sound(392, 125);
	call sound(392, 125);
	call sound(311.13, 1200);

	call sound(349.23, 125);
	call sound(349.23, 125);
	call sound(349.23, 125);
	call sound(293.66, 1600);
run;
