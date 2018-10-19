


if "$measure"=="EPA" {
	global outcome epa
	global t EPA
	}
	if "$measure"=="WPA" {
	global outcome wpa
	global t WPA
	}
	
	if "$side"=="o" {
	global var posteam
	global title "Offense: $measure and success rate, 2018"
	}
	if "$side"=="d" {
	global var defensiveteam
	global title "Defense: $measure and success rate against, 2018"
	}


clear 
clear matrix
set mem 1g

cd "C:\Users\\`c(username)'\Dropbox\nfl\nfldata"

use pbp_rush_pass_18, clear

gen success = $outcome > 0

drop if two_point_attempt=="1"

sum $outcome
global mean_e = `r(mean)'
sum success
global mean_s = `r(mean)'


collapse (mean) $outcome success, by($var)

	twoway (scatter  $outcome success if $var!="$team", msize(small) mlabel($var) mlabposition(9) mlabsize(vsmall)) ///
	(scatter  $outcome success if $var=="$team", msize(small) mlabel($var) mlabposition(12) mlabsize(small) mcolor(red) mlabcolor(red)) ///
	(lfit  $outcome success)  ///
	, graphregion(fcolor(white)) scheme(s2mono) ///
	 ytitle("$t per play") xtitle(Success rate) xline($mean_s) yline($mean_e) ///
	legend(off) name(epar, replace) title("$title")
	
	graph export "${dir}/results/2018_${side}_${team}.png", replace width(3900)
	
