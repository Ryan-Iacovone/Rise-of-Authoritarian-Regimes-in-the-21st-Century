*ESS DATA ANAYLSIS SECTION;

PROC IMPORT DATAFILE="/home/u49757561/Honors project/datasets/ESS1-9e01_1.csv" 
		DBMS=csv OUT=ESSO REPLACE;
RUN;


data ESS;
	set ESSO;
	
	if trstprt = ' ' then 
		trstprt1= input(trstprt, 2.);
		else trstprt1 = trstprt;
	
	
	*keep the array statements together;
	array Sch{*} impsafe ipfrule ipbhprp ipstrgv imptrad;
	array Pop{*} trstplt trstplc trstprt1 trstprl trstlgl;
	array Imm{*} imbgeco imueclt imwbcnt;
	*array Mat{*} wmcpwrk mnrgtjb freehms euftf imwbcnt rlgdgr;
	
	
	*Schwartz scale;
	do s=1 to 5;
		if Sch{s} >=7 then Sch{s} =. ;
	end;
	if nmiss(of Sch{*}) <=2 then
		SchwartzScale = mean(impsafe, ipfrule, ipbhprp, ipstrgv, imptrad);
		
	*populist scale - Trust in politicans, parties, and parliament (Sum);
	do p=1 to 5;
		if Pop{p} >=11 then Pop{p} =. ;
	end;
	if nmiss(of Pop{*}) <=2 then
		PopulistScale = mean(trstplt, trstplc, trstprt1, trstprl, trstlgl);
		*/
		
	*Immigration Scale;
	do i=1 to 3;
		if Imm{i} >=11 then Imm{i} =. ;
	end;
	if nmiss(of Imm{*}) <=1 then
		ImmigrationScale = mean(imbgeco, imueclt, imwbcnt);
	
	*Post-materialism Scale;
/*	do m=1 to 3;
		if Imm{i} >=6 then Imm{i} =. ;
	end;
	do m=4 to 6;
		if Imm{i} >=11 then Imm{i} =. ;
	end;
	if nmiss(of Imm{*}) <=2 then
		SocialLibValues = mean(wmcpwrk, mnrgtjb, freehms, euftf, imwbcnt, rlgdgr);
		
		varaibles that are character: euftf wmcpwrk mnrgtjb
		
	*/
	
	SocialLibValues = mean(wmcpwrk, mnrgtjb, freehms, euftf, imwbcnt, rlgdgr);
	where rlgdgr <11;
	
	*create dummy varaibles here and then use that to create formats;
	
	AgeCohort1 = (yrborn<1900);
	AgeCohort2 = (1946 <= yrbrn <= 1964);
	
	length AgeCohort $23;
	if 1900 <= yrbrn <= 1945 then AgeCohort="Traditionalists";
	else if 1946 <= yrbrn <= 1964 then AgeCohort = "Boomers"; 
	else if 1965 <= yrbrn <= 1979 then AgeCohort = "Gen X";
	else AgeCohort = "Milennials and Younger" ;
run;


/*
proc sort data=ESS out=RESS;
	by descending ImmigrationScale;
	where SchwartzScale and ImmigrationScale is not missing and populistscale <=11;
run; */

/*
proc sort data = ess out=essorteie;
	by descending PopulistScale; 
run;

title "European Social Survey Intro Dataset";
proc print data = essorteie (obs=500) label ;
	*var cntry essround agea yrbrn AgeCohort SchwartzScale ImmigrationScale PopulistScale;
	var cntry essround prtvtfhu trstplt trstplc  trstprt1 trstprl trstlgl PopulistScale;
		*var cntry essround impsafe ipfrule ipbhprp ipstrgv imptrad SchwartzScale;
		*var imbgeco imueclt imwbcnt ImmigrationScale;
		*var wmcpwrk mnrgtjb freehms euftf imwbcnt rlgdgr SocialLibValues;
	where essround = 9 and cntry = "HU";
run; */


proc format;
	value Yearright 1 = "2002"
		2 = "2004"
		3 = "2006"
		4 = "2008"
		5 = "2010"
		6 = "2012"
		7 = "2014"
		8 = "2016"
		9 = "2018";
run;

proc univariate data = ESS;
	*where cntry="HU";
	var SchwartzScale ImmigrationScale PopulistScale;
run;

******************************SCHWARTZ SCALE GRAPHICAL ANALYSIS**********************************************************;
			**Lower SchwartzScale means higher levels of authoritarian values 
************************MACRO ANALYSIS****************************;
proc sort data=ESS out=ESSsch;
	by essround SchwartzScale;
	where SchwartzScale is not missing;
run;

title "Values of Authoritarianism Across Europe";
footnote "Figure 5.4. Schwartz scale values over time across Europe";
proc sgplot data =ESSsch;
    vline essround / response=SchwartzScale stat=mean markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round";
	yaxis grid values=(2 to 3.5 by .5)
		label = "Schwartz Score (1-6)";
    inset "Data obtained from ESS Rounds 1-9"/ position=topright border;
    format essround Yearright.;
run;

*******************INDIVIDUAL COUNTRY ANALYSIS***********************;

%let Country= HU;
%let CountryF= Hungary;

title "Values of Authoritarianism in &CountryF";
footnote "Figure 7.4. Schwartz index values over time in &CountryF";
proc sgplot data =ESSsch;
	where cntry = "&Country";
    vline essround / response=SchwartzScale stat=mean markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round" ;
	yaxis grid values=(1.5 to 3.5 by .5)
		label = "Schwartz Score (1-6)";
    inset "Data obtained from ESS Rounds 1-9"/ position=topright border;
    format essround Yearright.;
run;


****************************IMMIGRATION SCALE GRAPHICAL ANALYSIS**********************************************************;
				*Lower ImmigrationScale scores mean higher anti-immigration vlaues 
*****************MACRO ANALYSIS**********************************;
proc sort data=ESS out=ESSimm;
	by essround ImmigrationScale;
	where ImmigrationScale is not missing;
run;

title "Views on Immigration Across Europe";
footnote "Figure 5.3. Immigration index values over time across Europe";
proc sgplot data =ESSimm;
    vline essround / response=ImmigrationScale stat=mean  markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round" ;
	yaxis grid values=(4 to 6 by .5)
		label = "Immigration Index Score (0-10)";  
    inset "Data obtained from ESS Rounds 1-9"/ position=topright border;
    format essround Yearright.;
run;


******************INDIVIDUAL COUNTRY ANALYSIS************************;

%let Country= HU;
%let CountryF= Hungary;

title "Views on Immigration in &CountryF";
footnote "Figure 7.6. Immigration index values over time in &CountryF";
proc sgplot data =ESSimm;
	where cntry="&Country";
    vline essround / response=ImmigrationScale stat=mean  markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round" ;
	yaxis grid values=(3 to 5 by .5)
		label = "Immigration Index Score (0-10)";  
    inset "Data obtained from ESS Rounds 1-9"/ position=topright border;
    format essround Yearright.;
run;




****************************POPULIST SCALE GRAPHICAL ANALYSIS**********************************************************;
						**Lower PopulistScale scores means greater degree of populism by way of less trust of institutions**
***********MACRO ANALYSIS***************;
proc sort data=ESS out=ESSpop;
	by essround PopulistScale;
	where PopulistScale is not missing;
run;

title "Populist Values Across Europe";
footnote "Figure 5.5. Populist values index over time across Europe";
proc sgplot data =ESSpop;
    vline essround / response=PopulistScale stat=mean markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round" ;
	yaxis grid values=(3.5 to 6 by .5)  
    	label = "Populist Index Score (0-10)"; 
    inset "Data obtained from ESS Rounds 1-9"/ position=topright border;
    format essround Yearright.;
run;



***********INDIVIDUAL COUNTRY ANALYSIS***************;

%let Country= HU;
%let CountryF= Hungary;

title "Populist Values in &CountryF";
footnote "Figure 7.5. Populist index values over time in &CountryF";
proc sgplot data =ESSpop;
	where cntry = "&Country";
    vline essround / response=PopulistScale stat=mean markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round" ;
	yaxis grid values=(2.5 to 5 by .5)  
    	label = "Populist Index Score (0-10)"; 
    inset "Data obtained from ESS Rounds 1-9"/ position=topright border;
    format essround Yearright.;
run;



****************************POST-MATERIALISM GRAPHICAL ANALYSIS**********************************************************;

***********MACRO ANALYSIS***************;
proc sort data=ESS out=ESSmat;
	by essround descending SocialLibValues;
	where SocialLibValues <=11 and essround in(3 4 5 6 7 8 9) 
		and imwbcnt is not missing; *and euftf is not missing all of 5 this one is missing;
run;
* 3 6 7 9eh;
/*
proc print data =ESSmat (obs=500);
	var essround wmcpwrk mnrgtjb freehms euftf imwbcnt rlgdgr SocialLibValues;
	where essround=5;
run;  */

title "Post-Materialist values Across Europe";
footnote "Figure 4.4. Socially liberal values over time across Europe as a proxy for post-materialism";
proc sgplot data =ESSmat;
    vline essround / response=SocialLibValues stat=mean group=AgeCohort markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round" ;
	yaxis grid values=(3.5 to 4.5 by .5)  
    	label = "Socially Liberal Values Index (0-9)"; 
    inset "Data obtained from ESS Rounds 1-9"/ position=topright border;
    format essround Yearright.;
run;


***********INDIVIDUAL COUNTRY ANALYSIS***************;	

%let Country= HU;
%let CountryF= Hungary;

title "Post-Materialist values in &CountryF";
footnote "Figure 7.3. Socially liberal values over time in &CountryF as a proxy for post-materialism";
proc sgplot data =ESSmat;
	where cntry = "&country";
    vline essround / response=SocialLibValues stat=mean group=AgeCohort markers; *group=country_text_id;
    xaxis grid label = "European Social Survey Round" ;
	yaxis grid values=(3 to 5 by .5)  
    	label = "Socially Liberal Values Index (0-9)"; 
    inset "Data obtained from ESS Rounds 2-9"/ position=topright border;
    format essround Yearright.;
run;



***************************LOGISTIC REGRESSION ANALYSIS FOR HUNGARY 2010****************************
			*ONLY CAN MEASURE FIDESZ and JOBBIK PARTY;
data ESSMLRHU;
	set ESS;
	keep essround cntry prtvtfhu edlvdhu rlgdnhu rlgdgr HunVote yrbrn ImmigrationScale 
		PopulistScale SchwartzScale agea PopParty agesq SocialLibValues;
	*Don't need the where statement because proc reg takes out all missing variables anyways ;
	*SchwartzScale is not missing and ImmigrationScale is not missing and PopulistScale is not missing;
	where essround = 9 and rlgdgr <11 and cntry = "HU";
	
	if prtvtfhu = ' ' then 
		HunVote= input(prtvtfhu, 2.);
		else HunVote = prtvtfhu;
		

	
	PopParty = (HunVote in (3,4));
	agesq = agea**2;
run; 


proc print data = ESSMLRHU (obs=400) label;
	var essround agea agesq HunVote SchwartzScale PopulistScale rlgdgr;
run;


proc freq data=ESSMLRHU  order = freq;
	tables  HunVote rlgdgr/nocum ;
	*where edition = 2022;
	format HunVote partyh.;
run;

PROC CORR data=ESSMLRHU;
	VAR PopParty hunvote SchwartzScale PopulistScale ImmigrationScale agea rlgdgr; 
		*WITH ImmigrationScale PopulistScale;
RUN;


********LOOKING AT THE EFFECT OF AGE (DIVIDING IT INTO 10 CATEGORIES) ON VOTING FOR A POPULIST PARTY**********
								ONLY TO REALIZE AGE IS CURVLINEAR SO ADDED AGE^2 TERMS;
proc sgplot data =ESSMLRHU;
	loess x= agea y=PopParty;
run;


proc hpbin data=ESSMLRHU output= ESSMLRHU2;
	input agea / numbin= 10;
	code file= "/home/u49757561/Honors project/agebin.sas" ;
run;

data ESSMLRHU2	;
	set ESSMLRHU;
	%include "/home/u49757561/Honors project/agebin.sas";
run;

proc freq data=ESSMLRHU2 ;
	tables Bin_agea*PopParty/ nocol nopercent nofreq  plots=freqplot;
	*where edition = 2022;
run;

ods output crosslist=Freqstat;
proc freq data=ESSMLRHU2 ;
	tables Bin_agea*PopParty / crosslist ;
	*where edition = 2022;
run;

title "Voting for Authoritarian-populist Parties by Age";
footnote "Figure 7.7. Participants were grouped by into 10 catergories where lower numbered groups correspond to lower age and higher numbered 
	with higher ages";
proc sgplot data=Freqstat;
	where popparty=1;
	vline Bin_agea / response=rowpercent  markers    ; *x = Bin_agea y = rowpercent ;
	xaxis grid values=(1 to 10 by 1);
	yaxis grid values = (10 to 50 by 5);
	label Bin_agea = "Grouped Ages - Lower to Higher"
		rowpercent = "Percent of People Voting for an Authoritarian-populist Party";
	inset "Data obtained from ESS Round 9"/ position=topright border;
run;

proc format ;
	value partyh 1,11 = "Populist"
			other  = "All other parties"; 
run;

****ACTUAL CODE FOR LOGISTICAL REGRESSION******;

title "This is title ";
proc logistic data=ESSMLRHU;
	class HunVote;
	model HunVote (event="Populist") = SchwartzScale PopulistScale ImmigrationScale rlgdgr agea agesq / rsquare rsq;
	 
	*Still want to include education for post-materialism religion 
											feelings about income?;
	format HunVote partyh.;
run;


***************************LOGISTIC REGRESSION ANALYSIS FOR HUNGARY 2006****************************;

data esshun;
	set "/home/u49757561/Honors project/datasets/ess3e03_7.sas7bdat";
	
	if trstprt = ' ' then 
		trstprt1= input(trstprt, 2.);
		else trstprt1 = trstprt;
		
	if prtvtahu = ' ' then 
		HunVote= input(prtvtahu, 2.);
		else HunVote = prtvtahu;
	*keep the array statements together;
	array Sch{*} impsafe ipfrule ipbhprp ipstrgv imptrad;
	array Pop{*} trstplt trstplc trstprt1 trstprl trstlgl;
	array Imm{*} imbgeco imueclt imwbcnt;
	
	*Schwartz scale;
	do s=1 to 5;
		if Sch{s} >=7 then Sch{s} =. ;
	end;
	if nmiss(of Sch{*}) <=2 then
		SchwartzScale = mean(impsafe, ipfrule, ipbhprp, ipstrgv, imptrad);	
	*populist scale - Trust in politicans, parties, and parliament (Sum);
	do p=1 to 5;
		if Pop{p} >=11 then Pop{p} =. ;
	end;
	if nmiss(of Pop{*}) <=2 then
		PopulistScale = mean(trstplt, trstplc, trstprt1, trstprl, trstlgl);
		*/	
	*Immigration Scale;
	do i=1 to 3;
		if Imm{i} >=11 then Imm{i} =. ;
	end;
	if nmiss(of Imm{*}) <=1 then
		ImmigrationScale = mean(imbgeco, imueclt, imwbcnt);
	
	SocialLibValues = mean(wmcpwrk, mnrgtjb, freehms, euftf, imwbcnt, rlgdgr);
	agesq = agea**2;
	where rlgdgr <11 and cntry = "HU" and prtvtahu <=8;
run;


proc freq data=esshun  order = freq;
	tables HunVote rlgdgr/nocum ;
	*where edition = 2022;
	format HunVote partyh.;
run;

PROC CORR data=esshun;
	VAR hunvote SocialLibValues SchwartzScale PopulistScale ImmigrationScale agea rlgdgr; 
		*WITH ImmigrationScale PopulistScale;
RUN;

proc format ;
	value partyhu 1 = "Populist"
			other  = "All other parties"; 
run;

proc logistic data=esshun;
	class HunVote;
	model HunVote (event="Populist") = SocialLibValues SchwartzScale PopulistScale ImmigrationScale rlgdgr agea agesq/ rsquare;
	 
	*Still want to include education for post-materialism religion 
											(rlgdgr - How religious are you?) feelings about income?;
	format HunVote partyhu.;
run;




********************LOGISTIC REGRESSION ANALYSIS FOR POLAND********************;
			*ONLY CAN MEASURE LAW AND JUSTICE PARTY (Prawo i Sprawiedliwość);
			
			
data esspol;
	set "/home/u49757561/Honors project/datasets/ess5e03_4.sas7bdat";
	
	if trstprt = ' ' then 
		trstprt1= input(trstprt, 2.);
		else trstprt1 = trstprt;
		
	if prtvtbpl = ' ' then 
		PolVote= input(prtvtbpl, 2.);
		else PolVote = prtvtbpl;
	*keep the array statements together;
	array Sch{*} impsafe ipfrule ipbhprp ipstrgv imptrad;
	array Pop{*} trstplt trstplc trstprt1 trstprl trstlgl;
	array Imm{*} imbgeco imueclt imwbcnt;
	
	*Schwartz scale;
	do s=1 to 5;
		if Sch{s} >=7 then Sch{s} =. ;
	end;
	if nmiss(of Sch{*}) <=2 then
		SchwartzScale = mean(impsafe, ipfrule, ipbhprp, ipstrgv, imptrad);	
	*populist scale - Trust in politicans, parties, and parliament (Sum);
	do p=1 to 5;
		if Pop{p} >=11 then Pop{p} =. ;
	end;
	if nmiss(of Pop{*}) <=2 then
		PopulistScale = mean(trstplt, trstplc, trstprt1, trstprl, trstlgl);
		*/	
	*Immigration Scale;
	do i=1 to 3;
		if Imm{i} >=11 then Imm{i} =. ;
	end;
	if nmiss(of Imm{*}) <=1 then
		ImmigrationScale = mean(imbgeco, imueclt, imwbcnt);
	
	SocialLibValues = mean(wmcpwrk, mnrgtjb, freehms, euftf, imwbcnt, rlgdgr);
	agesq = agea**2;
	where  essround = 8 and rlgdgr <11 and cntry = "PL" and prtvtahu <9;
run;			
			

 
proc format ;
	value partyp 6 = "Populist"
			other = "All other parties"; 
run;
 

proc print data=ESSMLRPL ;
	var essround prtvtdfr;
	where prtvtdfr is not missing; 
run; 

proc freq data=ESSMLRPL order=freq ;
	tables PolVote /nocum ;
	format PolVote partyp.;
run;

PROC CORR data=esspol plots= matrix(histogram);
	*VAR SchwartzScale ; 
		*WITH ImmigrationScale PopulistScale;
RUN;



proc logistic data=esspol ;
	class PolVote;
	model PolVote (event="Populist") = SchwartzScale PopulistScale ImmigrationScale rlgdgr agea agesq rlgdgr;
	
	*Still want to include education for post-materialism religion 
											(rlgdgr - How religious are you?) feelings about income?;
	format PolVote partyp.;
run;




********************MULTIPLE LINEAR REGRESSION ANALYSIS FOR SERBIA, SLOVENIA, OR CROATIA********************;
												 

