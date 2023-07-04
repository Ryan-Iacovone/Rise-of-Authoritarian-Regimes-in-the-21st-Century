*CHES data analysis; 

PROC IMPORT DATAFILE="/home/u49757561/Honors project/datasets/1999-2019_CHES_dataset_meansv3.csv" 
		DBMS=csv OUT=CHES REPLACE;
RUN;

data CHESReal;
	set CHES;
	where year >=2006 ;
run;

Proc print data = CHES (obs=500)label; 
	where country = 23 and year >= 2014 and family in (1 2);
	var country year party_id party vote seat electionyear family ;
run;

Proc print data = CHESReal (obs=500)label; 
	var country year party_id party vote seat electionyear family MULTICULTURALISM;
	where MULTICULTURALISM is not missing;
run;

proc univariate data=CHESReal;
	var vote;
run;

proc sort data=CHESReal out= CHESRealSorted;	
	by family MULTICULTURALISM;
run;

proc sgplot data=CHESRealSorted;
   scatter x=MULTICULTURALISM y= vote/ group=family; 
run;





