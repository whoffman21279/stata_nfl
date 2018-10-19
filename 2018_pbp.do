
cd C:\Users\\`c(username)'\Dropbox\nfl

file open rcode using test.R, write replace

/*`"devtools::install_github(repo = "maksimhorowitz/nflscrapR")"' _newline /// */

//can replace "season_play_by_play(2018)" with "scrape_season_play_by_play(2018)"

file write rcode ///
    `"library(nflscrapR)"' _newline ///
	`"library(tidyverse)"' _newline ///
    `"pbp_data <- scrape_season_play_by_play(2018)"' _newline ///
    `"write.csv(pbp_data, file = "C:/Users/`c(username)'/Dropbox/nfl/season2018.csv",row.names=FALSE)"'
file close rcode

if "`c(version)'" == "11.2" {
shell "C:\Program Files\R\R-3.4.2\bin\x64\R.exe" CMD BATCH test.R
}

else {
shell "C:\Program Files\R\R-3.5.1\bin\x64\R.exe" CMD BATCH test.R
}


cd C:\Users\\`c(username)'\Dropbox\nfl

insheet using season2018.csv, clear
gen n = _n

ren (play_type posteam_score defteam_score yardline_100 ep     score_differential pass_attempt home_team away_team game_seconds_remaining) ///
	(playtype  posteamscore  defteamscore  yrdline100   exppts scorediff          passattempt  hometeam  awayteam  timesecs)
	
ren (rusher_player_id passer_player_id rusher_player_name passer_player_name defteam) ///
	(rusher_id passer_id rusher passer defensiveteam)


foreach var in epa wpa posteamscore defteamscore yrdline100 exppts scorediff down passattempt timesecs {
capture replace `var' = "" if `var' == "NA"
capture destring `var', replace
}

//these aren't real plays
drop if playtype == "NA" | playtype == "extra_point" | playtype == "kickoff" ///
| playtype=="qb_kneel" | playtype=="qb_spike" | playtype=="field_goal" | playtype=="punt" | posteam==""
drop if  timesecs==.

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

gen str_pass = strpos(desc, "pass")
replace str_pass = 1 if str_pass >0

drop sack
gen sack = strpos(desc, "sacked")

replace rush = 0 if qb_scramble ==1

gen pass = 1 if str_pass == 1 | sack > 0 | qb_scramble==1

replace rush = 0 if rush == .
replace pass = 0 if pass == .

drop if rush == 0 & pass == 0 //timeouts, nzi, false start, delay of game, etc
replace pass = 0 if rush == 1

gen season = 2018

cd "C:\Users\\`c(username)'\Dropbox\nfl\nfldata"
save pbp_rush_pass_18, replace

