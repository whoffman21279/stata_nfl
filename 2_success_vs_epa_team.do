
if "$measure"=="EPA" {
	global var epa
	}
	if "$measure"=="WPA" {
	global var wpa
	}


clear 
clear matrix
set mem 1g

cd "C:\Users\\`c(username)'\Dropbox\nfl\nfldata"

use pbp_rush_pass_18, clear

gen success = $var > 0

keep if rush == 1

drop if two_point_attempt=="1"

sum $var
global mean_e = `r(mean)'
sum success
global mean_s = `r(mean)'


collapse (mean) $var success, by(posteam)

	twoway (scatter  $var success if posteam!="$team", msize(small) mlabel(posteam) mlabposition(9) mlabsize(vsmall)) ///
	(scatter  $var success if posteam=="$team", msize(small) mlabel(posteam) mlabposition(12) mlabsize(small) mcolor(red) mlabcolor(red)) ///
	(lfit  $var success), graphregion(fcolor(white)) scheme(s2mono) ///
	 ytitle($measure per carry) xtitle(Success rate) xline($mean_s) yline($mean_e) ///
	legend(off) name(epar, replace) title("$measure and success rate per rush attempt, 2018")
	
	graph export "${dir}/results/2018_rush_total_${team}.png", replace width(3900)
	
use pbp_rush_pass_18, clear
gen success = $var > 0
keep if pass == 1
drop if two_point_attempt=="1"

sum $var
global mean_e = `r(mean)'
sum success
global mean_s = `r(mean)'

collapse (mean) $var success, by(posteam)

	twoway (scatter  $var success if posteam!="$team", msize(small) mlabel(posteam) mlabposition(9) mlabsize(tiny)) ///
	(scatter  $var success if posteam=="$team", msize(small) mlabel(posteam) mlabposition(12) mlabsize(small) mcolor(red) mlabcolor(red)) ///
	(lfit  $var success), graphregion(fcolor(white)) scheme(s2mono) ///
	 ytitle($measure per dropback) xtitle(Success rate) xline($mean_s) yline($mean_e) ///
	legend(off) name(epap, replace) title("$measure and success rate per dropback, 2018")
	
	graph export "${dir}/results/2018_pass_total_${team}.png", replace width(3900)

	
