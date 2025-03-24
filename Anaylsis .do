clear
log using CB&C.analysis, replace text
c B&C 
/* 

Program:	CB&C.Analysis.do

Task: 		Analysis do file 

Project: 	Racial and ethnic differences in community belonging and its impact 
			on cognitive function in older adults.

Author: 		Samuel Nemeth (Created on: 12/12/24)

Last updated:	3/14/2025 (Samuel Nemeth) 
	
Project description: 

Examining the effect of sense of community belonging at various time points
across the life course on cognitive function in later life. 

*/

********************************************************************
// Load Data 
********************************************************************

use CB&C_Final.dta

********************************************************************
/* Table 1. Descriptive Statistics (Means and Percentages) 
			of Analytic Sample
*/			
********************************************************************

foreach var in Cog18 Cog16 B10 B40 CurAgeB age educ wlth depress {
	di _newline(1)
				di in white "******************************"
				di in white "// DV: `var' //"
				di in white "******************************"
				di _newline(1)
	summarize `var'
	by rce, sort : summarize `var'
	ttest `var', by(Black)
	ttest `var', by(Hispanic)
	ttest `var', by(BH)
}

foreach var in fem region married web2018 {
	di _newline(1)
				di in white "******************************"
				di in white "// DV: `var' //"
				di in white "******************************"
				di _newline(1)
	tab `var' rce, col 
	tab `var' Black, chi
	tab `var' Hispanic, chi
	tab `var' BH, chi 
}
	
********************************************************************
/* Table 2. OLS Regression of the Impact of Community Belonging on
		 	2018 Cognitive Function
*/
********************************************************************

**			Model 1 no controls 

reg Cog18 B10 B40 CurAgeB, vce(robust) 
estimates store T2Model1

**			Model 2 with controls 

reg Cog18 B10 B40 CurAgeB age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region, vce(robust) 
estimates store T2Model2

**			Model 3 interaction Belonging age 10*race/ethnicity

reg Cog18 B40 CurAgeB age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B10##i.rce, vce(robust) 
estimates store T2Model3

**			Model 4 interaction Belonging age 40*race/ethnicity

reg Cog18 B10 CurAgeB age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B40##i.rce, vce(robust) 
estimates store T2Model4

**			Model 5 interaction belonging current age*race/ethnicity

reg Cog18 B10 B40 age i.fem i.rce married wlth educ web2018 ///
	c.depress i.region c.CurAgeB##i.rce, vce(robust) 
estimates store T2Model5

esttab T2Model1 T2Model2 T2Model3 T2Model4 T2Model5, b(%4.3f) se(%4.3f) r2 ///
	star(* 0.05 ** 0.01 *** 0.001) noobs nobase ///
	label title("Table 2.") ///
	mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") nonumbers ///
	drop(age 1.fem 1.rce 2.rce married wlth educ web2018 depress ///
		 2.region 3.region 4.region 5.region) replace

********************************************************************
/* Table 3. OLS Regression of the Impact of Community Belonging on
		 	the Change in Cognitive Function from 2016 to 2018 
*/
********************************************************************

**			Model 1 no controls 

reg Cog18 B10 B40 CurAgeB Cog16, vce(robust) 
estimates store T3Model1

**			Model 2 with controls 

reg Cog18 B10 B40 CurAgeB Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region, vce(robust) 
estimates store T3Model2

**			Model 3 interaction Belonging age 10*race/ethnicity

reg Cog18 B40 CurAgeB Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B10##i.rce, vce(robust) 
estimates store T3Model3

**			Model 4 interaction Belonging age 40*race/ethnicity

reg Cog18 B10 CurAgeB Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region c.B40##i.rce, vce(robust) 
estimates store T3Model4

**			Model 5 interaction belonging current age*race/ethnicity

reg Cog18 B10 B40 Cog16 age fem i.rce married wlth educ web2018 ///
	c.depress i.region c.CurAgeB##i.rce, vce(robust) 
estimates store T3Model5

esttab T3Model1 T3Model2 T3Model3 T3Model4 T3Model5, b(%4.3f) se(%4.3f) r2 ///
	star(* 0.05 ** 0.01 *** 0.001) noobs nobase ///
	label title("Table 3.") ///
	mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") nonumbers ///
	drop(Cog16 age fem 1.rce 2.rce married wlth educ web2018 depress ///
		 2.region 3.region 4.region 5.region) replace 

********************************************************************
/* Figure 1. Impact of age-10 community belonging by race and 
			 ethnicity on cognitive function in 2018 (Panel A) and 
			 change in cognitive function from 2016 to 2018 (Panel B)
*/
********************************************************************
	
**			Panel A

estimate restore T2Model3 
margins i.rce, at(B10=(0(1)6))
marginsplot,  ///
	noci ///
	title("Panel A", size(16pt) position(11)) ///
	ylabel(12(1)17, labsize(16pt)) ///
	ytitle("Cognitive Function", size(16pt)) ///
	xtitle("Community Belonging at Age 10", size(16pt))  ///
	xlabel(,labsize(16pt)) ///
	plot1opts(lcolor() lwidth(medthick) msymbol(circle) ///
						mcolor()) ///
	plot2opts(lcolor() lwidth(medthick) msymbol(triangle) ///
						mcolor()) ///
	plot3opts(lcolor() lwidth(medthick) msymbol(square) ///
						mcolor()) ///
	legend(off)
graph save figure1.gph, replace

**			Panel B

estimates restore T3Model3
margins i.rce, at(B10=(0(1)6))
marginsplot, ///
	 noci ///
	title("Panel B", size(16pt) position(11)) ///
	ylabel(12(1)17, labsize(16pt)) ///
	ytitle("Cognitive Function", size(16pt)) ///
	xtitle("Community Belonging at Age 10", size(16pt))  ///
	xlabel(,labsize(16pt)) ///
	plot1opts(lcolor() lwidth(medthick) msymbol(circle) ///
						mcolor()) ///
	plot2opts(lcolor() lwidth(medthick) msymbol(triangle) ///
						mcolor()) ///
	plot3opts(lcolor() lwidth(medthick) msymbol(square) ///
						mcolor()) ///
	legend(off)
graph save figure2.gph, replace

**			Combine into one figure

graph combine figure1.gph figure2.gph, ///
	title("") 
	
graph export figure1.tif, replace

********************************************************************
// Supplementary Table 1
********************************************************************

reg Cog18 B10, vce(robust)
est store ST1ModelA1

reg Cog18 B10 age i.fem i.rce married wlth educ web2018 c.depress i.region, ///
	vce(robust) 
est store ST1ModelA2

reg Cog18 age i.fem married wlth educ web2018 c.depress i.region ///
	c.B10##i.rce, vce(robust)
est store ST1ModelA3

reg Cog18 B10 Cog16, vce(robust)
est store ST1ModelA4
 
reg Cog18 B10 Cog16 age i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store ST1ModelA5

reg Cog18 Cog16 age i.fem married wlth educ web2018 c.depress i.region ///
	c.B10##i.rce, vce(robust) 
est store ST1ModelA6

esttab ST1ModelA1 ST1ModelA2 ST1ModelA3 ST1ModelA4 ST1ModelA5 ST1ModelA6, ///
	b(%4.3f) se(%4.3f) r2 star(* 0.05 ** 0.01 *** 0.001) noobs nobase ///
	label title("Panel A: Age 10 Community Belonging") ///
	mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") ///
	nonumbers ///
	drop(age 1.fem 1.rce 2.rce married wlth educ web2018 depress ///
		 2.region 3.region 4.region 5.region) replace 

********************************************************************

reg Cog18 B40, vce(robust)
est store ST1ModelB1

reg Cog18 B40 age i.fem i.rce married wlth educ web2018 c.depress i.region, ///
	vce(robust) 
est store ST1ModelB2

reg Cog18 age i.fem married wlth educ web2018 c.depress i.region ///
	c.B40##i.rce, vce(robust)
est store ST1ModelB3

reg Cog18 B40 Cog16, vce(robust)
est store ST1ModelB4

reg Cog18 B40 Cog16 age i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store ST1ModelB5

reg Cog18 Cog16 age i.fem married wlth educ web2018 c.depress i.region ///
	c.B40##i.rce, vce(robust) 
est store ST1ModelB6

esttab ST1ModelB1 ST1ModelB2 ST1ModelB3 ST1ModelB4 ST1ModelB5 ST1ModelB6, ///
	b(%4.3f) se(%4.3f) r2 star(* 0.05 ** 0.01 *** 0.001) noobs nobase ///
	label title("Panel B: Age 40 Community Belonging") ///
	mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") ///
	nonumbers ///
	drop(age 1.fem 1.rce 2.rce married wlth educ web2018 depress ///
		 2.region 3.region 4.region 5.region) replace 

********************************************************************

reg Cog18 CurAgeB, vce(robust)
est store ST1ModelC1

reg Cog18 CurAgeB age i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store ST1ModelC2

reg Cog18 age i.fem married wlth educ web2018 c.depress i.region ///
	c.CurAgeB##i.rce, vce(robust)
est store ST1ModelC3

reg Cog18 CurAgeB Cog16, vce(robust)
est store ST1ModelC4

reg Cog18 CurAgeB age Cog16 i.fem i.rce married wlth educ web2018 c.depress ///
	i.region, vce(robust) 
est store ST1ModelC5

reg Cog18 age Cog16 i.fem married wlth educ web2018 c.depress i.region ///
	c.CurAgeB##i.rce, vce(robust) 
est store ST1ModelC6


esttab ST1ModelC1 ST1ModelC2 ST1ModelC3 ST1ModelC4 ST1ModelC5 ST1ModelC6, ///
	b(%4.3f) se(%4.3f) r2 star(* 0.05 ** 0.01 *** 0.001) noobs nobase ///
	label title("Panel C: Current Age Community Belonging") ///
	mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6") ///
	nonumbers ///
	drop(age 1.fem 1.rce 2.rce married wlth educ web2018 depress ///
		 2.region 3.region 4.region 5.region) replace 

********************************************************************

log close
clear 
exit
NOTES: 
