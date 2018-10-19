
cd C:\Users\\`c(username)'\Dropbox\nfl

insheet using "C:/Users/`c(username)'/Dropbox/nfl/season2017.csv", clear
gen n = _n

foreach var in epa wpa posteam_score defteam_score time_secs yrdline100 ep playtimediff scorediff down pass_attempt {
capture replace `var' = "" if `var' == "NA"
capture destring `var', replace
}

//these aren't real plays
drop if play_type == "Two Minute Warning" | play_type == "Timeout" | play_type == "Quarter End" ///
| play_type=="Half End" | play_type=="Kickoff" | play_type=="NA"
*drop if  time_secs==.

drop if posteam==""

gen fs = strpos(desc, "False Start")
gen delay = strpos(desc, "Delay of Game")
gen nzi = strpos(desc, "Neutral Zone")

drop if fs > 0 | nzi > 0
*drop if delay>0
drop if play_type=="qb_kneel" | play_type=="spike" 

so n
drop n
gen n = _n

gen mid = strpos(desc, "up the middle")
gen rg = strpos(desc, "right guard")
gen re = strpos(desc, "right end")
gen rt = strpos(desc, "right tackle")
gen lg = strpos(desc, "left guard")
gen lt = strpos(desc, "left tackle")
gen le = strpos(desc, "left end")

gen rush = 1 if mid > 0 | rg > 0 | re > 0 | rt > 0 | lg > 0 | lt > 0 | le > 0

gen scramble = strpos(desc, "scrambles")
drop sack
gen sack = strpos(desc, "sacked")

replace rush = 0 if scramble > 0

gen pass = 1 if pass_attempt == 1 | sack > 0 | scramble>0

replace rush = 0 if rush == .
replace pass = 0 if pass == .

drop if rush == 0 & pass == 0
replace pass = 0 if rush == 1

//what we want
/*
success rate
rush
pass

epa per play
rush
pass
*/

gen success = epa > 0
/*
replace success = . if success == 1 & epa < 0
replace success = . if success == 0 & epa > 0
*/

preserve
	collapse (mean) success epa (firstnm) home_team, by(posteam)
	gen pass = 99
	tempfile all
	save `all', replace
restore

preserve
collapse (mean) success epa (firstnm) home_team, by(posteam pass)
append using `all'

foreach i in 0 1 99 {
	qui sum epa if posteam == home_team & pass == `i'
	scalar se`i' =`r(mean)'
	qui sum epa if posteam != home_team & pass == `i'
	scalar ne`i' =`r(mean)'
	
	qui sum success if posteam == home_team	& pass == `i'
	scalar ss`i' =`r(mean)'
	qui sum success if posteam != home_team & pass == `i'
	scalar ns`i' =`r(mean)'
	}

matrix all = ss99, ns99 \ ss0, ns0 \ ss1, ns1 \ se99, ne99 \ se0, ne0 \ se1, ne1
 
matrix colnames all = Home Away
matrix rownames all = Success SuccessR SuccessP EPA EPA_r EPA_p

restore

preserve
*drop if qtr==4
gen one = 1
keep if rush==1
drop if success==.
collapse (mean) success epa (sum) carries = one successes = success tot_epa = epa (firstnm) rusher_player_name, by(rusher_player_id)
gsort - carries
noi list rusher_player_name successes carries success epa tot_epa rusher_player_id
restore

noi tab home_team
noi estout matrix(all, fmt(%9.2f))
