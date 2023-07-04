*WORLD BANK DATASET ANALYSIS (Classifying countries);

PROC IMPORT DATAFILE="/home/u49757561/Honors project/datasets/OGHIST.xlsx" 
		DBMS=xlsx OUT=bank REPLACE;
	sheet=one;
RUN;

proc sort data = bank out = sortedbank;
	by FY21;
run;

title "Table of all High and Upper Middle Income Countries in Fiscal Year 2021";
title2 "Data From World Bank";
proc print data= sortedbank noobs label;
	var country FY21; 
	where FY21 is not missing and FY21 = 'H' or FY21 = 'UM';
run;   

title "Frequency Table of Each Economic Cateogry ";
proc freq data=sortedbank;
	tables FY21;
	where FY21 is not missing;
run;  

*WORLD BANK DATASET GNI Per capita PPP ANALYSIS; 

libname WBgni xlsx "/home/u49757561/Honors project/datasets/Data_Extract_From_World_Development_Indicators.xlsx";

proc print data=wbgni.data;
	var country yr1999;
	format yr1999 comma.2;
run;

title"";
proc sgplot data =wbgni.data;
	where country = "Brazil";
	vbar country/response= yr1999 barwidth=.50;
run;