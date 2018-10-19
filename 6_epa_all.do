
*epa or wpa
global var epa

cd C:\Users\\`c(username)'\Dropbox\nfl

file open rcode using test.R, write replace

/*`"devtools::install_github(repo = "maksimhorowitz/nflscrapR")"' _newline /// */
//can replace "game_play_by_play(GameID = $gameid)" with "scrape_json_play_by_play($gameid)"

file write rcode ///
    `"library(nflscrapR)"' _newline ///
	`"library(tidyverse)"' _newline ///
    `"pbp_data <- scrape_json_play_by_play($gameid)"' _newline ///
    `"write.csv(pbp_data, file = "C:/Users/`c(username)'/Dropbox/nfl/season2017.csv",row.names=FALSE)"'
file close rcode

if "`c(version)'" == "11.2" {
shell "C:\Program Files\R\R-3.4.2\bin\x64\R.exe" CMD BATCH test.R
}

else {
shell "C:\Program Files\R\R-3.5.1\bin\x64\R.exe" CMD BATCH test.R
}


qui include "${dir}\epa_list.do"


qui include "${dir}\epa_summary.do"



