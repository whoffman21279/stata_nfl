
insheet using "C:/Users/`c(username)'/Dropbox/nfl/season2017.csv", clear
gen n = _n

global TEAM "SEA"

drop if play_type == "Two Minute Warning" | play_type == "Timeout"

foreach var in epa wpa down home_wp away_wp home_wp_post away_wp_post opp_td_prob ///
td_prob posteam_score defteam_score opp_fg_prob fg_prob {
capture replace `var' = "" if `var'=="NA"
}

foreach var in epa wpa opp_td_prob td_prob down home_wp away_wp home_wp_post away_wp_post yrdln ///
posteam_score defteam_score opp_fg_prob fg_prob {
destring `var', replace
}

gen change =  posteam!=posteam[_n+1]

gen opp_td_prob_after = .
gen td_prob_after = .

gen opp_fg_prob_after = .
gen fg_prob_after = .

gen tmp1 = opp_td_prob[_n+1]
gen tmp2 = td_prob[_n+1]
 
gen tmp3 = opp_fg_prob[_n+1]
gen tmp4 = fg_prob[_n+1]

replace opp_td_prob_after = tmp1 if change == 0
replace opp_td_prob_after = tmp2 if change == 1

replace td_prob_after = tmp1 if change == 1
replace td_prob_after = tmp2 if change == 0

replace opp_fg_prob_after = tmp3 if change == 0
replace opp_fg_prob_after = tmp4 if change == 1

replace fg_prob_after = tmp3 if change == 1
replace fg_prob_after = tmp4 if change == 0

drop tmp1 tmp2 tmp3 tmp4

if home_team == "SEA" {
gen sea_wp_pre = home_wp
gen sea_wp_post = home_wp_post
}

else {
gen sea_wp_pre = away_wp
gen sea_wp_post = away_wp_post
}

foreach var in sea_td_pre sea_td_post opp_td_pre opp_td_post sea_fg_pre sea_fg_post {
gen `var' = .
	}

//tds
replace sea_td_pre = td_prob if posteam == "SEA"
replace sea_td_pre = opp_td_prob if sea_td_pre==.

replace sea_td_post = td_prob_after if posteam == "SEA"
replace sea_td_post = opp_td_prob_after if sea_td_post == .

//fgs
replace sea_fg_pre = fg_prob if posteam == "SEA"
replace sea_fg_pre = opp_fg_prob if sea_fg_pre==.

replace sea_fg_post = fg_prob_after if posteam == "SEA"
replace sea_fg_post = opp_fg_prob_after if sea_fg_post == .

//don't think this is used anymore
replace opp_td_pre = opp_td_prob if posteam == "SEA"
replace opp_td_pre = td_prob if opp_td_pre==.

replace opp_td_post = opp_td_prob_after if posteam == "SEA"
replace opp_td_post = td_prob_after if opp_td_post==.

gen sea_score_pre = sea_td_pre + sea_fg_pre
gen sea_score_post = sea_td_post + sea_fg_post

gen abs_epa = abs(epa)
gen abs_wpa=abs(wpa)

gsort - abs_$var

local n 15

preserve

capture keep in 1/`n'

so abs_$var

keep qtr down ydstogo side_of_field yrdln desc sea_wp_* ///
sea_td_* opp_td_pre opp_td_post epa wpa abs_epa ep change ///
td_prob td_prob_after posteam_score defteam_score posteam defteam home_wp_post home_wp sea_score_*

order qtr down ydstogo yrdln side_of_field desc

//export full file
outsheet using full_epa.csv , comma replace

replace sea_wp_pre = sea_wp_pre * 100
replace sea_wp_post = sea_wp_post * 100
replace td_prob = td_prob * 100
replace td_prob_after = td_prob_after * 100
replace home_wp_post = home_wp_post * 100
replace home_wp = home_wp * 100
replace sea_score_pre =sea_score_pre * 100
replace sea_score_post = sea_score_post * 100
replace td_prob_after = 100 if td_prob_after==0


//create top 10 plays

cap log close
log using wp_epa.txt, text replace

if posteam=="SEA" | defteam == "SEA" {

forvalues i=1/`n' {
	foreach var in qtr down ydstogo yrdln epa abs_epa sea_wp_pre sea_wp_post sea_score_pre sea_score_post {
		capture qui sum `var' in `i'
		local t`var' `r(mean)'
		}
	local play = desc[`i']
	local tm = side_of_field[`i']

noi di ""
noi di "#`n'. Q`tqtr' `tdown'-`tydstogo' `tm' `tyrdln': `play'"
noi di "EPA: " %4.1f `tepa' ". Score before play: " posteam[`i'] posteam_score[`i'] ", " defteam[`i'] defteam_score[`i'] ". SEA WP change: " %2.0f `tsea_wp_pre' "-> " %2.0f `tsea_wp_post' ". SEA next score %: " %2.0f `tsea_score_pre' "-> " %2.0f `tsea_score_post'

local n = `n' - 1


}
}

else {

forvalues i=1/`n' {
	foreach var in qtr down ydstogo yrdln abs_epa home_wp_pre home_wp_post touchdown_prob td_prob_after {
		capture qui sum `var' in `i'
		local t`var' `r(mean)'
		}
	local play = desc[`i']
	local tm = side_of_field[`i']

noi di ""
noi di as error "#`n'. Q`tqtr' `tdown'-`tydstogo' `tm' `tyrdln': `play'"
noi di as text "EPA:" %4.1f `tabs_epa' ". Score before play: " posteam[`i'] posteam_score[`i'] ", " defteam[`i'] defteam_score[`i'] ". Home WP change: " %2.0f `thome_wp_pre' "-> " %2.0f `thome_wp_post' ". TD% before: " %2.0f `ttouchdown_prob' ". TD% after: " %2.0f `ttd_prob_after'

local n = `n' - 1

}
}

di "EP/WP and play by play from nflscrapr: https://github.com/maksimhorowitz/nflscrapR"

log close

restore

so n
