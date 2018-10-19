//where the .do files are saved
global dir "C:\Users\\`c(username)'\Dropbox\nfl\current_season"
global sym Oh /*Oh for hollow, or O */

global team CLE //team to highlight
global measure EPA /*EPA or WPA*/

//update season data. takes a long time
include "${dir}\2018_pbp.do"

/* ***************
**** FULL SEASON STUFF
************** */
//get rush & pass epa by player -- set sym above
global minr 16
global minp 100

include "${dir}\1_success_vs_epa.do"

include "${dir}\2_success_vs_epa_team.do"

//get overall side of d plots for team...and offense too
foreach s in o d {
global side `s'
include "${dir}\3_success_vs_epa_team_defense.do"
}

//show offense and defense success and epa
include "${dir}\4_o_d_success.do"

//a decade of pass & rush efficiency
global measure EPA /*EPA or Success*/
global team SEA //team to highlight
include "${dir}\5_team_over_time.do"

window manage close graph _all

/* ***************
**** ONE GAME STUFF
************** */

global gameid 2018091700 

//calls epa_list and epa_summary from a given game
include "${dir}\6_epa_all.do"

