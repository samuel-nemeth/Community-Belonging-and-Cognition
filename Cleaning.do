capture log close
log using CB&C.Cleaning, replace text
c B&C
/* 

Program:	CB&C.cleaning.do

Task: 		Cleaning do file 

Project: 	Racial and ethnic differences in community belonging and its impact 
			on cognitive function in older adults.

Author: 		Samuel Nemeth (Created on: 12/12/24)

Last updated:	2/18/2025 (Samuel Nemeth) 
	
Project description: 

Examining the effect of sense of community belonging at various time points
across the life course on cognitive function in later life. 

*/

******************************************************
// 1: Extract Variables from Raw Data 
******************************************************

use hhid pn /// ID participants 
	R14TR20 R14TR20W R14SER7 R14BWC20 R14BWC20W /// 2018 cognitive function
	LH10 LH21 OLB020A PLB020A /// Key independent variables
	R13TR20 R13SER7 R13BWC20 /// 2016 cognitive function 
	r12agey_b r13agey_b /// Age in 2014/2016
	ragender /// Gender 
	raracem rahispan /// Race and ethnicity 
	rabplace /// Region of birth 
	r12mstat r13mstat /// Mariatal status 2014/2016 
	raedyrs /// Education 
	h12atotb h13atotb /// Wealth 2014/2016 
	r12cesd r13cesd /// Depressive symptoms 2014/2016 
	QIWMODE /// Web interview 
	PIWLANG /// Interview language 
	OWGTR PWGTR /// 2014/2016 half-sample weights 
	LHMSWIND /// Participated in LHMS 
	EFTFASSIGN /// Half-sample assignment 
	using master.raw.Tracker2020V3.dta, replace // data set of raw data 
	
******************************************************
// 2: Outcome: 2018 Cognitive function 
******************************************************

/*

Note: In 2018, the total word recall and backawards counting were different 
	  for respondents on the web than in the face to face setting. 
*/

generate 		recall_8 = .
	replace 	recall_8 = R14TR20
label variable 	recall_8 "2018 total word recall summary score 0-20"

generate 		recallweb_8 = .
	replace		recallweb_8 = R14TR20W 

generate 		totrecall_8 = . 
	replace		totrecall_8 = R14TR20
	replace 	totrecall_8 = R14TR20W if R14TR20==.

generate 		serial_8 = .
	replace		serial_8 = R14SER7
label variable 	serial_8 "2018 serial 7s summary score 0-5"

generate 		counting_8 = .
	replace		counting_8 = R14BWC20
label variable 	counting_8 "2018 backwards counting score 0-2"

generate 		countingweb_8 = .
	replace 	countingweb_8 = R14BWC20W
label variable 	countingweb_8 "2018 backawards counting web interview 0-20"
	
generate 		totcounting_8 = .
	replace 	totcounting_8 = R14BWC20
	replace 	totcounting_8 = R14BWC20W if R14BWC20==.

generate 		Cog18 = .
	replace 	Cog18 = totrecall_8 + serial_8 + totcounting_8
label variable 	Cog18 "2018 Total Cognition Score"

fre Cog18

******************************************************
// 3: Key Independent Variables
******************************************************

**				Age 10 community belonging 

generate 		B10 = .
	replace		B10 = LH10
recode 			B10 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (.m=.)
label variable 	B10 "Community beloning age 10"

fre B10 

**				Age 40 community belonging 

generate 		B40 = .
	replace		B40 = LH21
recode			B40 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (.m=.)
label variable 	B40 "Community beloning age 40"

fre B40

**				Current age community belonging 

generate 		LHpart14 = .
	replace 	LHpart14 = 8-OLB020A
	
generate 		LHpart16 = .
	replace		LHpart16 = 8-PLB020A

generate 		CurAgeB = LHpart14 if EFTFASSIGN==1
	replace 	CurAgeB = LHpart16 if EFTFASSIGN==2
recode 			CurAgeB (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (.m=.)
label variable 	CurAgeB "Current age belonging"

fre CurAgeB

******************************************************
// 4: Covariates
******************************************************

**				2016 Cognitive Function 

generate 		recall_7 = .
	replace 	recall_7 = R13TR20
label variable 	recall_7 "2016 total word recall summary score 0-20"

generate 		serial_7 = .
	replace		serial_7 = R13SER7
label variable 	serial_7 "2016 serial 7s summary score 0-5"

generate 		counting_7 = .
	replace 	counting_7 = R13BWC20
label variable 	counting_7 "2016 backwards counting score 0-2"

generate 		Cog16 = .
	replace 	Cog16 = recall_7 + serial_7 + counting_7
label variable 	Cog16 "2016 Total Cognition Score"

fre Cog16


**				Age
 
generate 		age2014 = .
	replace		age2014 = r12agey_b
label variable  age2014 "Age in 2014"

generate 		age2016 = .
	replace		age2016 = r13agey_b
label variable 	age2016 "Age in 2016"

generate 		age = .
	replace 	age = age2014 if EFTFASSIGN==1
	replace 	age = age2016 if EFTFASSIGN==2
label variable 	age "Age"

fre age

** 				Gender

generate		fem = .
	replace 	fem = ragender
recode 			fem (1=0) (2=1)
label variable 	fem "Women"
label define 	fem 0 "Men" ///
					1 "Women"
label values 	fem fem 

fre fem

**				Race/Ethnicity 

generate		rce = . 
	replace		rce = 0 if raracem==1 & rahispan==0
	replace 	rce = 1 if raracem==2 & rahispan==0
	replace 	rce = 2 if rahispan==1
label variable 	rce "Race and Ethnicity"
label define 	rce 0 "Non-Hispanic White" ///
					1 "Non-Hispanic Black" ///
					2 "Hispanic" 
label values 	rce rce

fre rce 

**				Birth location

generate 		region = .
	replace 	region = rabplace
recode 			region (5/7 = 1) (1/2 = 2) (3/4 = 3) (8/9 = 4) (11 = 5) ///
					   (10 = .) (.m = .) 
label define 	region 1 "South" ///
					   2 "Northeast" ///
					   3 "Midwest" ///
					   4 "West" ///
					   5 "Forign Born"
label values 	region region 
label variable 	region "Birth region"

fre region 

**				Mariatal Status 

generate 		marstat6 = .
	replace 	marstat6 = r12mstat
recode 			marstat6 (1/3=0) (4/6=1) (7=2) (8=3) (.m=.)
label variable 	marstat6 "Marital Status 2014"

generate 		married6 = .
	replace 	married6 = 0 if marstat6==1 | marstat6==2 | marstat6==3 
	replace 	married6 = 1 if marstat6==0
label variable 	married6 "Married in 2014"

generate 		marstat7 = . 
	replace 	marstat7 = r13mstat
recode 			marstat7 (1/3=0) (4/6=1) (7=2) (8=3) (.m=.)
label variable 	marstat7 "Marital Status 2016"

generate 		married7 = .
	replace 	married7 = 0 if marstat7==1 | marstat7==2 | marstat7==3 
	replace 	married7 = 1 if marstat7==0
label variable 	married7 "Married in 2016"

generate 		married = .
	replace 	married = married6 if EFTFASSIGN==1
	replace 	married = married7 if EFTFASSIGN==2
label variable 	married "Married"
label define 	married 0 "Not married" ///
						1 "Married"
label values 	married married

fre married 

**				Education 

generate 		educ = .
	replace 	educ = raedyrs
	replace 	educ = . if raedyrs==.m
label variable 	educ "Education"

fre educ

**				Wealth

generate		wealth1416 = .
	replace 	wealth1416 = h12atotb if EFTFASSIGN==1
	replace 	wealth1416 = h13atotb if EFTFASSIGN==2
label variable 	wealth1416 "Wealth 2014/2016"

generate 		wlth = .
	replace 	wlth = asinh(wealth1416)
label variable 	wlth "Wealth"

fre wlth

**		Depressive Symptoms 

generate		depress = .
	replace		depress = r12cesd if EFTFASSIGN==1
	replace 	depress = r13cesd if EFTFASSIGN==2
recode			depress (.m = .) (.s = .)
label variable 	depress "Depressive Symptoms"

fre depress

**				Web Usage 

generate 		web2018 = .
	replace 	web2018 = 0 if QIWMODE==1 | QIWMODE==2
	replace 	web2018 = 1 if QIWMODE==3
label variable 	web2018 "Web survey, 2018"
label define 	web2018 0 "FTF/Phone" ///
						1 "Web"
label values 	web2018 web2018

fre web2018

******************************************************
// 5: Variables for Supplementary Analysis 
******************************************************

**				Race and Ethnicity 4 categories 

generate 		rce4 = .
	replace 	rce4 = 0 if raracem==1 & rahispan==0
	replace 	rce4 = 1 if raracem==2 & rahispan==0
	replace 	rce4 = 2 if rahispan==1 & region~=5
	replace 	rce4 = 3 if rahispan==1 & region==5
label variable 	rce4 "4 categories of race-ethnicity"
label define 	rce4 0 "Non-Hispanic White" ///
					 1 "Non-Hispanic Black" ///
					 2 "US Born Hispanic" ///
					 3 "Foreign Born Hispanic"
label values 	rce4 rce4

**				Interview Language 

generate 		lang = .
	replace 	lang = 0 if PIWLANG==1
	replace 	lang = 1 if PIWLANG==2
label variable 	lang "Interview Language"
label define 	lang 0 "English" ///
					 1 "Spanish"
label values 	lang lang 

fre lang 

******************************************************
// 6: Creating weights, dummy variables, etc. 
******************************************************

**				Making weights for 2014/16 half sample 

generate 		weight1416m = .
	replace 	weight1416m = 0
	replace 	weight1416m = 1 if OWGTR==0  & EFTFASSIGN==1
	replace 	weight1416m = 1 if mi(OWGTR) & EFTFASSIGN==1
	replace 	weight1416m = 1 if PWGTR==0  & EFTFASSIGN==2
	replace 	weight1416m = 1 if mi(PWGTR) & EFTFASSIGN==2
label variable 	weight1416m "2014/2016 Half sample weights"

**				Participated in the LHMS 

/*
Note: 
	LHMSWIND: 1 = completed 2015 & 2017 Fall supp
			  2 = completed 2015 interview but not 2017 fall supp
			  3 = completed 2017 fall supp but was not in the 2015 interview 
				  sample
			  4 = completed 2017 spring
			  5 = completed 2017 full

Variables of Interest were asked in 2017 only 

*/

generate 		lhpart = .
	replace 	lhpart = 0 if LHMSWIND==. | LHMSWIND==3 | LHMSWIND==2 | ///
							  LHMSWIND==1   
	replace 	lhpart = 1 if LHMSWIND==4 | LHMSWIND==5
label variable 	lhpart "LHMS participant"


**		Generating for T-tests 

generate 		Black = .
	replace 	Black = 0 if rce==0
	replace 	Black = 1 if rce==1
label variable 	Black "White and Hispanic T-test"
label define 	Black 0 "White" ///
					  1 "Black"
label values 	Black Black

generate 		Hispanic =. 
	replace 	Hispanic = 0 if rce==0
	replace 	Hispanic = 1 if rce==2
label variable 	Hispanic "White and Hispanic T-test"
label define 	Hispanic 0 "White" ///
					     1 "Hispanic"
label values 	Hispanic Hispanic

generate 		BH =.
	replace 	BH = 0 if rce==1
	replace 	BH = 1 if rce==2
label variable 	BH "Black and Hispanic T-test"
label define 	BH 0 "Black" ///
				   1 "Hispanic"
label values 	BH BH 
******************************************************
// 7: Dropping Raw Variables 
******************************************************

drop R14TR20 R14TR20W R14SER7 R14BWC20 R14BWC20W /// 2018 cognitive function
	 recall_8 recallweb_8 totcounting_8 totrecall_8 /// 2018 cognitive function
	 countingweb_8 counting_8 serial_8 /// 2018 cognitive function
	 LH10 LH21 OLB020A PLB020A LHpart14 LHpart16 /// Key independent variables
	 R13TR20 R13SER7 R13BWC20 recall_7 serial_7 /// 2016 cognitive function 
	 counting_7 /// 2016 cognitive function 
	 r12agey_b r13agey_b age2014 age2016 /// Age in 2014/2016
	 ragender /// Gender 
	 raracem rahispan /// Race and ethnicity 
	 rabplace /// Region of birth 
	 r12mstat r13mstat marstat6 married6 marstat7 /// Mariatal status 2014/2016 
	 married7 /// Mariatal status 2014/2016 
	 raedyrs /// Education 
	 h12atotb h13atotb wealth1416 /// Wealth 2014/2016 
	 r12cesd r13cesd /// Depressive symptoms 2014/2016 
	 QIWMODE /// Web interview 
	 PIWLANG /// Interview language 
	 PWGTR /// 2014/2016 half-sample weights 
	 LHMSWIND /// Participated in LHMS 
	 EFTFASSIGN /// Half-sample assignment
	 
******************************************************
// 8: Handeling missing data 
******************************************************

*1. Dropping for 0 weights in 2014/2016 Half Sample

drop if weight1416m == 1 | mi(OWGTR)
dis _N

drop weight1416m OWGTR

*2. Dropping if did not do LHMS Survey 

drop if lhpart==0
dis _N

drop lhpart 

*3. Dropping based on Cognition at baseline 

drop if Cog16<=6
dis _N

*4. Dropping if not White, Black, or Hispanic

drop if missing(rce)
dis _N

*5. Dropping if missing on Belonging variables 

foreach var in B10 B40 CurAgeB {
	drop if missing(`var')
	dis _N
}

*Dropping if missing on 2018 cognition

drop if missing(Cog18)
dis _N

******************************************************
// 8B: Performing Listwise Deletion 
******************************************************

foreach var in Cog16 age fem region married educ wlth depress web2018 {
	drop if missing(`var')
	dis _N
}

misstable summarize 

	 
******************************************************
// 8: Saving clean dataset 
******************************************************

compress
label data "HRS | CB&C | Cleaned Data - Final | 2/18/205 | CB&C_Finald"
datasignature set, reset

************************************
save "CB&C_Final", replace
************************************

log close
clear
exit
NOTES: 

/*		
	Data is pulled from the public access HRS and RAND data files. 

	Citation: 

	Nemeth, S. R., Thomas, P. A., Stoddart, C. M., & Ferraro, K. F. (2025).
	Racial and ethnic differences in community belonging and its impact on 
	cognitive function in older adults. The Journals of Gerontology: Series B, 
	gbaf028. https://doi.org/10.1093/geronb/gbaf028
	
*/	

