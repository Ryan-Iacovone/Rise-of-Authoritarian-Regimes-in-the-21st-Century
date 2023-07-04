
*					FREEDOM HOUSE DATASET ANALYSIS; 

libname FHouse xlsx "/home/u49757561/Honors project/datasets/All_data_FIW_2013-2022.xlsx";
/*
title "Freedom House Dataset for Specific Countries";
footnote PoliticRights is the Sum of ELECTORAL PROCESS, POLITICAL PLURALISM AND PARTICIPATION, 
	and FUNCTIONING OF GOVERNMENT;
footnote2 CivilLiberties is the Sum of FREEDOM OF EXPRESSION AND BELIEF, ASSOCIATIONAL AND ORGANIZATIONAL RIGHTS,
	RULE OF LAW, and PERSONAL AUTONOMY AND INDIVIDUAL RIGHTS;
*/

data labFHouse;
	set Fhouse.fiwall;
	label A = "ELECTORAL PROCESS"
		B = "POLITICAL PLURALISM AND PARTICIPATION"
		C = "FUNCTIONING OF GOVERNMENT"
		D = "FREEDOM OF EXPRESSION AND BELIEF"
		E = "ASSOCIATIONAL AND ORGANIZATIONAL RIGHTS"
		F = "RULE OF LAW"
		G = "PERSONAL AUTONOMY AND INDIVIDUAL RIGHTS"
		PR = "Political Rights"
		CL = "Civil Liberties";
	*not needed because FH includes these in dataset already (pr & cl) and because 
		pr cateogry takes into account 'additional question' that summing can't account for
	PoliticRights = Sum(A, B, C);
	*CivilLiberties = Sum(D, E, F, G);
	run;


proc print data = labFHouse label;
	var country region edition Status a b c pr d e f g cl total;
	where status = "F" and edition = 2013;
		
	*where edition in (2016 2022) and country in ("Brazil" "France" "Hungary" "Poland" "Sudan" "United Kingdom" 
		"United States" "Venezuela" "South Africa" "Tunisia");
run; 

/*
title "Civil Liberties Scores for Various countries in 2020";
proc sgplot data=NewVars;
	where country in ("Brazil" "Kenya" "Hungary" "France" "Ireland" "Canada" "China" "Russia") and edition = 2020;
    vbar country/response= CL barwidth=.50;
run; 
title; 
footnote; */

*FIGURE 1.1 CODE AND OUTPUT BELOW********************************************;

*might wanna code status as a dummy varaible for bar chart; 

ods trace on;
ods output crosslist=Freqstat;
proc freq data=labFHouse order=freq;
	tables edition*status / crosslist out=FreqStatus;
	*where edition = 2022;
run;

proc format;
	value $statlab F = "Free"
		PF = "Partly Free"
		NF = "Not Free";
run;
		

proc sort data=Freqstat;
	by status edition ;
run;

proc print data =Freqstat;	
	var Edition status RowPercent;
run;

title "Caterogies of Freedom Around the World";
footnote "Figure 1.2.  Percentage of countries with various levels of freedom from 2013 to 2022.";
footnote2 "Freedom house measures countries based on data from 195 countries and 15 territories";
proc sgplot data =Freqstat;
	where status is not missing;
    series x=edition y=rowpercent /group=Status;
    xaxis grid values=(2013 to 2022 by 1)
    	label= "Year";
	yaxis grid values=(20 to 50 by 5)
		label= "Percentage of Countries"; 
	inset "Data obtained from FreedomHouse"/ position=topright border;
	format status $statlab.;
run;


/*proc means data=NewVars;
	var A B C D E F G;
	class region country;
	ways 2;
run; */
	
	
   