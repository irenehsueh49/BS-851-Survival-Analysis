proc format; 
	value $trt_fmt "N"="New Treatment" "A"="Treatment A" "B"="Treatment B";
	value remiss_fmt 0="No" 1="Yes";
	value death_fmt 1="Died" 0="Lost to Follow-Up";
run;

data depression; 
	input trt $ agegrp $ days remiss death; 
	attrib
		trt 		label="Treatment"			format=$trt_fmt.
		agegrp		label="Age Group"			
		days		label="Days to Remission"	
		remiss		label="Remission Status"	format=remiss_fmt.
		death		label="Death"				format=death_fmt.
		;
datalines;
N Young 78.00 .00 1
N Young 80.00 .00 1
N Young 82.00 .00 1
N Young 71.00 .00 1
N Young 51.00 1.00 0
N Young 60.00 1.00 0
N Young 81.00 1.00 0
N Young 50.00 1.00 0
N Young 88.00 1.00 0
N Young 93.00 1.00 0
N Young 86.00 1.00 0
N Young 63.00 1.00 0
N Young 65.00 1.00 0
N Young 67.00 1.00 0
N Young 68.00 1.00 0
N Old 54.00 .00 1
N Old 30.00 .00 0
N Old 52.00 .00 0
N Old 68.00 .00 1
N Old 66.00 .00 0
N Old 75.00 .00 1
N Old 85.00 .00 0
N Old 55.00 .00 1
N Old 62.00 1.00 0
N Old 62.00 1.00 0
N Old 76.00 1.00 0
N Old 63.00 1.00 0
N Old 78.00 1.00 0
N Old 77.00 1.00 0
N Old 77.00 1.00 0
N Old 67.00 1.00 1
N Old 73.00 1.00 0
N Old 50.00 1.00 0
N Old 60.00 1.00 0
A Young 73.00 .00 1
A Young 79.00 .00 1
A Young 78.00 .00 1
A Young 81.00 .00 1
A Young 85.00 .00 1
A Young 80.00 1.00 0
A Young 88.00 1.00 0
A Young 76.00 1.00 0
A Young 71.00 1.00 0
A Young 70.00 1.00 0
A Young 71.00 1.00 0
A Young 77.00 1.00 0
A Young 75.00 1.00 0
A Young 62.00 1.00 0
A Young 64.00 1.00 0
A Young 69.00 1.00 0
A Young 66.00 1.00 0
A Young 84.00 1.00 0
A Young 60.00 1.00 0
A Old 65.00 .00 0
A Old 68.00 .00 1
A Old 66.00 .00 0
A Old 67.00 .00 0
A Old 62.00 .00 0
A Old 67.00 .00 0
A Old 61.00 .00 0
A Old 68.00 .00 1
A Old 65.00 .00 1
A Old 72.00 .00 1
A Old 65.00 .00 0
A Old 65.00 .00 0
A Old 52.00 .00 0
A Old 70.00 .00 1
A Old 70.00 .00 1
A Old 66.00 .00 0
A Old 68.00 .00 1
A Old 59.00 .00 0
A Old 65.00 .00 0
A Old 75.00 .00 1
A Old 63.00 .00 0
A Old 74.00 1.00 0
A Old 86.00 1.00 0
A Old 82.00 1.00 0
A Old 74.00 1.00 0
A Old 64.00 1.00 0
A Old 33.00 1.00 0
B Young 55.00 .00 0
B Young 88.00 .00 1
B Young 67.00 .00 1
B Young 88.00 .00 1
B Young 75.00 .00 0
B Young 55.00 .00 1
B Young 67.00 .00 1
B Young 85.00 .00 1
B Young 78.00 1.00 0
B Young 73.00 1.00 0
B Young 90.00 1.00 0
B Young 95.00 1.00 0
B Young 93.00 1.00 0
B Young 75.00 1.00 0
B Young 65.00 1.00 0
B Young 65.00 1.00 0
B Young 76.00 1.00 0
B Young 70.00 1.00 0
B Young 80.00 1.00 0
B Old 90.00 .00 0
B Old 98.00 .00 0
B Old 73.00 .00 1
B Old 63.00 .00 1
B Old 95.00 .00 0
B Old 83.00 .00 1
B Old 75.00 .00 1
B Old 81.00 .00 0
B Old 82.00 .00 0
B Old 95.00 .00 0
B Old 92.00 .00 0
B Old 80.00 1.00 0
B Old 81.00 1.00 0
B Old 79.00 1.00 0
B Old 75.00 1.00 0
B Old 80.00 1.00 0
B Old 91.00 1.00 0
B Old 60.00 1.00 0
;
run;

title "Depression Remission Dataset";
proc print data=depression (obs=25) label;
run;
title;



title "Survival Analysis of all Three Treatments";
proc lifetest data=depression plots=(loglogs);
	time days*remiss(0);
	strata trt;
run;
title;

title "Surivival Analysis Comparing New Treatment vs Treatment A";
proc lifetest data=depression plots=(loglogs);
	where trt in ("N","A");
	time days*remiss(0);
	strata trt;
run;
title;

title "Survival Analysis of New Treatment vs Treatment B";
proc lifetest data=depression plots=(loglogs);
	where trt in ("N","B");
	time days*remiss(0);
	strata trt;
run;
title;



title "Cox Proportional Hazards Regression Analysis";
proc phreg data=depression;
	class trt (ref="N") / param=ref;
	model days*remiss(0) = trt / risklimits;
run;
title;



title "Proportion of Death in all Three Treatments";
proc freq data=depression;
	format death death_fmt.;
	tables trt*death / nocol nopercent chisq;
run;
title;



ODS HTML CLOSE;
ODS HTML;
