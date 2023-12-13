
* run these two lines to install rcall ::::::::::::::::::
//net install github, from("https://haghish.github.io/github/")
//github install haghish/rcall, stable


capture program drop apci

program apci
	
	// define the syntax, all the arguments should be mandatary
	syntax varlist, outcome(varname) age(varname) period(varname) family(string) [weight(varname) cohort(varname)]
	gettoken depvar indeps : varlist
	
	rcall: library("APCI")
	rcall: library("magrittr")
	rcall: data = st.data()
	
	// get the fomula
	rcall: covs = unlist(strsplit("`indeps'"," "))
	rcall: covs = covs[covs!=""]
	
	// run apci model
	rcall: data\$`age' = as.factor(data\$`age')
	rcall: data\$`period' = as.factor(data\$`period')
	
	rcall: APC_I = APCI::apci(outcome = "`outcome'", age = "`age'",period = "`period'", cohort  = NULL,weight = NULL,covariate = covs,data = data, dev.test=FALSE,family = "`family'", print = T)
	
	// visualization
	rcall: apci.plot(model=APC_I,age = "`age'",period = "`period'",outcome_var = "`outcome'",type="explore",quantile = 0.1)
end

use "simulation.dta", clear
gen x1 = 0.2*age+0.3*period
apci y x1, outcome(y) age(age) period(period) family("gaussian")


capture log close
log using "simulation.log",replace
use "simulation.dta", clear

*****************
// no covariates
*****************
apci y, outcome(y) age(age) period(period) family("gaussian")

*****************
// add covariates x1
*****************
gen x1 = 0.2*age+0.3*period
apci y x1, outcome(y) age(age) period(period) family("gaussian")

log close





