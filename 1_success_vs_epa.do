
/*
global minr 24
global minp 80
global team SEA

global measure EPA /*EPA or WPA*/

global sym Oh /*Oh, O */
*/

if "$measure"=="EPA" {
	global var epa
	}
	if "$measure"=="WPA" {
	global var wpa
	}

*include C:\Users\\`c(username)'\Dropbox\nfl\2018_pbp.do

clear 
clear matrix
set mem 1g

cd "C:\Users\\`c(username)'\Dropbox\nfl\nfldata"

use pbp_rush_pass_18, clear

gen success = $var > 0

gen one = 1
keep if rush == 1

drop if rusher_id=="None"
drop if playtype=="no_play" | two_point_attempt=="1"

duplicates drop game_id play_id, force

sum $var
global mean_e = `r(mean)'
sum success
global mean_s = `r(mean)'

bys rusher_id: egen name = mode(rusher)
replace rusher = name

collapse (mean) $var success (sum) plays = one (firstnm) rusher posteam, by(rusher_id)
keep if plays >= $minr

egen lab = mlabvpos($var success)

	twoway (scatter  $var success if posteam!="$team" [w=plays], msymbol($sym)) ///
	(scatter  $var success if posteam!="$team", msymbol(none) mlabel(rusher) mlabvpos(lab) mlabsize(vsmall)) ///
	(scatter  $var success if posteam=="$team" [w=plays], msymbol($sym) mcolor(red)) ///
	(scatter  $var success if posteam=="$team", msymbol(none) mlabel(rusher) mlabposition(12) mlabsize(small) mlabcolor(red)) ///
	(lfit  $var success), graphregion(fcolor(white)) scheme(s2mono) ///
	 ytitle($measure per carry) xtitle(Success rate) xline($mean_s) yline($mean_e) ///
	 text(-.3 .45 "Data: #nflscrapR", size(small)) ///
	 text(-.35 .45 "Success: %plays w EPA>0", size(small)) ///
	legend(off) name(epar, replace) title("$measure and success rate per rush attempt") t1title("Min $minr attempts, through $S_DATE")
	
	graph export "${dir}/results/2018_rush_${team}.png", replace width(3900)
	
use pbp_rush_pass_18, clear
gen success = $var > 0
keep if pass == 1
drop if playtype=="no_play" | two_point_attempt=="1"

duplicates drop game_id play_id, force

replace passer = rusher if passer=="NA"
replace passer_id = rusher_id if passer_id=="NA"

sum $var
global mean_e = `r(mean)'
sum success
global mean_s = `r(mean)'

bys passer_id: egen name = mode(passer)
replace passer = name

gen one = 1

collapse (mean) $var success (sum) plays = one (firstnm) passer posteam, by(passer_id)
keep if plays >= $minp

	
egen lab = mlabvpos($var success)

	twoway (scatter  $var success if posteam!="$team" [w=plays], msymbol($sym)) ///
	(scatter  $var success if posteam!="$team", msymbol(none) mlabel(passer) mlabvpos(lab) mlabsize(vsmall)) ///
	(scatter  $var success if posteam=="$team" [w=plays], msymbol($sym) mcolor(red)) ///
	(scatter  $var success if posteam=="$team", msymbol(none) mlabel(passer) mlabposition(12) mlabsize(small) mlabcolor(red)) ///
	(lfit  $var success), graphregion(fcolor(white)) scheme(s2mono) ///
	 ytitle($measure per dropback) xtitle(Success rate) xline($mean_s) yline($mean_e) ///
	 text(-.17 .55 "Data: #nflscrapR", size(small)) ///
	 text(-.22 .55 "Success: %plays w EPA>0", size(small)) ///
	legend(off) name(epap, replace) title("$measure and success rate per dropback, 2018") t1title("Min $minp attempts, through $S_DATE")
	
	graph export "${dir}/results/2018_pass_${team}.png", replace width(3900)

	
