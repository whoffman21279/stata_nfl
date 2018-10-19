clear
clear matrix
set mem 1g

cd "C:\Users\\`c(username)'\Dropbox\nfl\nfldata"

foreach team in $team {
global team `team'

use posteam epa rush season using pbp_rush_pass_09_17, clear
append using pbp_rush_pass_18, keep(posteam epa rush season)
replace posteam = "STL" if posteam=="LA"
replace posteam = "SD" if posteam=="LAC"
replace posteam = "JAC" if posteam=="JAX"

*destring absscorediff, replace
*keep if absscorediff<=14


if "$measure"=="EPA" {
	global var epa
	global offset .04
	global title "EPA per Play"
	}
	if "$measure"=="Success" {
	global var success
	global offset .02
	global title "Success Rate"
	}

gen success = epa>0

preserve
	drop if posteam=="$team"
	collapse (mean) $var, by(rush season)
	tempfile nfl
	save `nfl', replace
restore

collapse (mean) $var, by(rush posteam season)
append using `nfl'

replace posteam="NFL" if posteam==""

/*
reshape wide $var, i(posteam season) j(rush)
drop if posteam=="NFL"
corr $var0 $var1
gen rush_team = $var1>$var0
*/

so posteam rush season 


qui sum $var if posteam=="NFL" & season == 2010 & rush==0
local np = `r(mean)'+$offset
qui sum $var if posteam=="NFL" & season == 2014 & rush == 1
local nr = `r(mean)'+$offset
qui sum $var if posteam=="$team" & season == 2015 & rush == 0
local tp = `r(mean)'+$offset
qui sum $var if posteam=="$team" & season == 2017 & rush == 1
local tr = `r(mean)'-$offset

twoway ///
(connected $var season if rush == 1 & posteam=="ARI", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="ARI", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="ATL", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="ATL", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="BUF", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="BUF", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="CAR", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="CAR", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="CHI", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="CHI", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="CIN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="CIN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="CLE", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="CLE", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="DAL", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="DAL", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="DEN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="DEN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="DET", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="DET", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="GB", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="GB", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="HOU", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="HOU", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="IND", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="IND", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="JAC", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="JAC", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="KC", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="KC", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="MIA", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="MIA", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="MIN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="MIN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="NE", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="NE", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="NO", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="NO", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="NYG", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="NYG", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="NYJ", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="NYJ", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="OAK", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="OAK", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="PHI", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="PHI", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="PIT", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="PIT", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="SD", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="SD", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="SEA", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="SEA", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="SF", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="SF", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="STL", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="STL", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="TB", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="TB", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="TEN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="TEN", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 1 & posteam=="WAS", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if rush == 0 & posteam=="WAS", msymbol(i) lcolor(grey) lcolor(*.2) lwidth(thin)) ///
(connected $var season if posteam=="$team" & rush == 0, msize(small) mcolor(green) lcolor(green)) ///
(connected $var season if posteam=="$team" & rush == 1, msize(small) mcolor(blue) lcolor(blue)) ///
(connected $var season if posteam=="NFL" & rush == 0, msymbol(i) lcolor(black)) ///
(connected $var season if posteam=="NFL" & rush == 1, msymbol(i) lcolor(red)), ///
xsc(r(2009 2018)) xlab(2009 (1) 2018) /*ysc(r(-.3 .4)) ylab(-.3 (.1) .4)*/ ///	
text(`np' 2010 "Dropbacks: NFL avg", size(small)) text(`nr' 2014.3 "Rushes: NFL avg", color(red) size(small)) ///
text(`tp' 2015.4 "${team} dropbacks", color(green) size(small)) text(`tr' 2017 "${team} rushes", color(blue) size(small)) legend(off) ///
xtitle(Season) ytitle($title) graphregion(fcolor(white)) title("Rushing and Passing $title, ${team}", color(black)) name($var, replace) t1title(2018 through $S_DATE)



graph export "${dir}/results/${team}_${measure}_over_time.png", replace width(3900)


}
