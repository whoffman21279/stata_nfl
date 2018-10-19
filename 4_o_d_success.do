

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
	global var posteam
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

preserve
	collapse (mean) success epa, by(posteam)
	rename success o_success
	ren epa o_epa
	rename posteam team
	tempfile o
	save `o', replace
restore

collapse (mean) success epa, by(defensiveteam)
	rename success d_success
	ren epa d_epa
	rename defensiveteam team
merge 1:1 team using `o', nogen

ren team posteam

	twoway (scatter  d_success o_success if posteam!="$team", msize(small) mlabel($var) mlabposition(9) mlabsize(vsmall)) ///
	(scatter  d_success o_success if posteam=="$team", msize(small) mlabel($var) mlabposition(12) mlabsize(small) mcolor(red) mlabcolor(red)) ///
	, graphregion(fcolor(white)) scheme(s2mono) ///
	 ytitle(Defense success rate allowed) xtitle(Offense success rate) xline($mean_s) yline($mean_s) ///
	legend(off) name(epar, replace) title("Offense and defense success rates") t1title("Through $S_DATE") ysc(reverse) ///
	text(.37 .35 "Good D, Bad O", size(small)) 	text(.53 .35 "Bad O, Bad D", size(small)) ///
	text(.37 .47 "Good O, Good D", size(small)) 	text(.53 .47 "Good O, Bad D", size(small))

	graph export "${dir}/results/2018_success_${team}.png", replace width(3900)
	

	twoway (scatter  d_epa o_epa if posteam!="$team", msize(small) mlabel($var) mlabposition(9) mlabsize(vsmall)) ///
	(scatter  d_epa o_epa if posteam=="$team", msize(small) mlabel($var) mlabposition(12) mlabsize(small) mcolor(red) mlabcolor(red)) ///
	, graphregion(fcolor(white)) scheme(s2mono) ///
	 ytitle(Defense EPA per play allowed) xtitle(Offense EPA per play) xline($mean_e) yline($mean_e) ///
	legend(off) name(epar, replace) title("Offense and defense EPA per play") t1title("Through $S_DATE") ysc(reverse) ///
	text(-.1 -.2 "Good D, Bad O", size(small)) 	text(.1 -.2 "Bad O, Bad D", size(small)) ///
	text(-.1 .2 "Good O, Good D", size(small)) 	text(.1 .2 "Good O, Bad D", size(small)) ///
	xsc(r(-.3 .3)) xlab(-.3 (.1) .3)

	graph export "${dir}/results/2018_epa_${team}.png", replace width(3900)
	
