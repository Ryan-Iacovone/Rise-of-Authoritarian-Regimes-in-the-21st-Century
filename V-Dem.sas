*VARIETIES OF DEMOCRACY DATASET ANALYSIS; 

PROC IMPORT DATAFILE="/home/u49757561/Honors project/datasets/V-Dem-CY-Full+Others-v12.csv" 
		DBMS=csv OUT=VDemAll REPLACE; 
RUN;

*save import to library;

data VDemE;
	set VDemAll;
	where region in(1 2 3 4) and country_text_id not in("MKD" "MLT" "BIH" "MDA" "BLR" "UKR" "XKX" "RUS" "ALB");
	label v2x_libdem="Liberal Democracy Index (0-1)"
    	v2x_polyarchy = "Electoral Democracy Index"
    	year="Year";
run;

proc format;
	value regionr 1 = "Western Europe"
		2 = "Northern Europe"
		3 = "Southern Europe"
		4 = "Eastern Europe";
run;

***********************************MACRO LEVEL ANALYSIS ACROSS THE ENTIRE WORLD AND EUROPE *******************************************

****************ANALYSIS ACROSS THE ENTIRE WORLD*********************************

*part of illustratoin on Huntignton's surges and delcines in democracy;
title "Trends in Liberal Democracy Worldwide";
footnote "Figure 4.1. Liberal democracy scores throughout the world";
proc sgplot data =VDemAll;
    vline Year / response=v2x_libdem stat=mean markers; *group=country_text_id;
    xaxis grid values=(1986 to 2021 by 5);
	yaxis grid values=(.15 to .5 by .05);  
    label v2x_libdem="Liberal Democracy Index"
    	v2x_polyarchy = "Electoral Democracy Index"
    	year="Year"; 
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
run; 

****************ANALYSIS ACROSS EUROPE SORTING OUT TO MATCH THE ESS*********************************;

title "Trends in Liberal Democracy Throughout Europe";
footnote "Figure 4.2. Liberal democracy scores throughout Europe";
proc sgplot data =VDemE;
    vline Year / response=v2x_libdem stat=mean markers; *group=country_text_id;
    xaxis grid values=(1986 to 2021 by 5);
	yaxis grid values=(.5 to .85 by .05);  
    inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
run;   


********************************GROUPED BY THE 4 DIFFERENT REGIONS OF EUROPE************************************************;

******Europe by groups from 2005 onward;

title "Trends in Liberal Democracy Across the Four European Regions from 2006";
footnote "Figure 4.3.  Liberal democracy scores throughout Europe";
proc sgplot data =VDemE;
    vline Year / response=v2x_libdem stat=mean markers group=region; *group=country_text_id;
    xaxis grid values=(2006 to 2021 by 1);
	yaxis grid values=(.45 to .9 by .05);  
  
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
	format region regionr.;
run; 

******Europe by groups from 1950 onward;

title "Trends in Liberal Democracy Across the Four European Regions from 1950";
footnote "Figure 1.8. Liberal democracy scores throughout Europe";
proc sgplot data =VDemE;
    vline Year / response=v2x_libdem stat=mean markers group=region; *group=country_text_id;
    xaxis grid values=(1950 to 2021 by 5);
	yaxis grid values=(0 to .9 by .1);  
  
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
	format region regionr.;
run; 


****************ANALYSIS ACROSS WESTERN EUROPE ******************************; 
data VDemWE;
	set VDemE;
	where region =1;
run;

title "Trends in Liberal Democracy across Western Europe";
footnote "Figure 1.8. Liberal democracy scores throughout Western Europe";
proc sgplot data =VDemWE;
    vline Year / response=v2x_libdem stat=mean markers; *group=country_text_id;
    xaxis grid values=(2006 to 2021 by 1);
	yaxis grid values=(.7 to 1 by .05);  
   
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
run; 

****************ANALYSIS ACROSS NORTHERN EUROPE ******************************; 
data VDemNE;
	set VDemE;
	where region =2;
run;

title "Trends in Liberal Democracy across Northern Europe";
footnote "Figure 1.8.  Liberal democracy scores throughout Northern Europe";
proc sgplot data =VDemNE;
    vline Year / response=v2x_libdem stat=mean markers; *group=country_text_id;
    xaxis grid values=(2006 to 2021 by 1);
	yaxis grid values=(.7 to 1 by .05);  
    
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
run; 

****************ANALYSIS ACROSS SOUTHERN EUROPE ******************************; 
data VDemSE;
	set VDemE;
	where region =3;
run;

title "Trends in Liberal Democracy across Southern Europe";
footnote "Figure 1.8. Liberal democracy scores throughout Southern Europe";
proc sgplot data =VDemSE;
    vline Year / response=v2x_libdem stat=mean markers group=country_text_id;
    xaxis grid values=(2006 to 2021 by 1);
	yaxis grid values=(.2 to .9 by .05);  
    
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
run; 

****************ANALYSIS ACROSS EASTERN EUROPE ******************************; 
proc format;
	value $regionEE "HUN" = "Hungary"
		"POL" = "Poland"
		"ROU" = "Romania"
		"BGR" = "Bulgaria"
		"CZE" = "Czech Republic"
		"SVK" =  "Slovakia";
run;

data VDemEE;
	set VDemE;
	where region =4;
run;

title "Trends in Liberal Democracy Across Eastern Europe";
footnote "Figure 6.1. Liberal democracy scores throughout Eastern Europe by individual countries";
proc sgplot data =VDemEE;
    vline Year / response=v2x_libdem stat=mean markers group=country_text_id;
    xaxis grid values=(2006 to 2021 by 1);
	yaxis grid values=(.30 to .9 by .05);  
	label country_text_id = "Country Abbreviation";
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
	format country_text_id $regionEE.;
run; 




proc print data=VDemE (obs=1000);
	var year country_name country_text_id country_id v2x_libdem region;
	where region in (1 2 ) and year =2019;
	format region regionr.;
run;
	

***********************************INDIVUDAL ANALYSIS ACROSS COUNTRIES OF INTEREST*******************************************;
proc sort data =VDemAll out=VDemSorted;
	by year;
	where country_text_id in ("MEX" "USA" "HUN" "VEN" "POL" "FRA" "BRA" "GRB" "UKR") and year>=1900;
	*where country_name ="Ukraine";
	label v2x_libdem="Liberal Democracy Index"
    	v2x_polyarchy = "Electoral Democracy Index";
run;



%let Country= HUN;

title"Scatterplot for Liberal Democracy and Electoral Democracy index for &Country";
footnote "Figure 1.8. Liberal democracy scores throughout Eastern Europe";
proc sgplot data =VDemSorted noautolegend;
	where country_text_id = "&Country";
	vline Year / response=v2x_libdem stat=mean markers; *group=country_text_id;
    xaxis grid values=(2006 to 2021 by 1);
	yaxis grid values=(.45 to .8 by .05);  
   
	inset "Data obtained from Varieties of Democracy (V-Dem) version 12"/ position=topright border;
run;






