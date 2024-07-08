## 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

select bdr_dt.bidder_id 'Bidder ID', bdr_dt.bidder_name 'Bidder Name', 
(select count(*) from ipl_bidding_details bid_dt 
where bid_dt.bid_status = 'won' and bid_dt.bidder_id = bdr_dt.bidder_id) / 
(select no_of_bids from ipl_bidder_points bdr_pt 
where bdr_pt.bidder_id = bdr_dt.bidder_id)*100 as 'Percentage of Wins (%)'
from ipl_bidder_details bdr_dt
order by 3 desc;

## 2.	Display the number of matches conducted at each stadium with the stadium name and city. 


select ist.stadium_id,stadium_name,city,sum(total_matches) 'No of Matches' from
ipl_stadium ist join ipl_match_schedule  ims
on ist.stadium_id= ims.stadium_id join ipl_tournament it
on it.tournmt_id=ims.tournmt_id
group by ist.stadium_id,ist.stadium_name
order by ist.stadium_id;

## 3.   In a given stadium, what is the percentage of wins by a team which has won the toss?

select std.STADIUM_ID as 'Stadium ID', std.STADIUM_NAME as 'Stadium Name',
(select count(*) from ipl_match mat join ipl_match_schedule ms on mat.MATCH_ID=ms.MATCH_ID
where std.STADIUM_ID=ms.STADIUM_ID and (TOSS_WINNER=MATCH_WINNER))/
(select count(*) from ipl_match_schedule ms where std.STADIUM_ID=ms.STADIUM_ID)*100 as 'Percentage of Wins by teams who won the toss'
from ipl_stadium std
order by 3 desc;

## 4.	Show the total bids along with the bid team and team name.

select TEAM_ID 'Team ID',TEAM_NAME 'Team Name',count(*) as 'Total Bid'
from ipl_team team
left join ipl_bidding_details bid
on team.TEAM_ID=bid.BID_TEAM
group by TEAM_ID
order by 3 desc;

##5.Show the team id who won the match as per the win details.

select distinct team_id from ipl_team it join ipl_match im
on it.team_id=im.match_winner
order by team_id;

## 6.	Display total matches played, total matches won and total matches lost by the team along with its team name.

select ts.TEAM_ID 'Team ID', t.TEAM_NAME 'Team Name', sum(ts.MATCHES_PLAYED) 'Match Played', 
sum(ts.MATCHES_WON) 'Match Won', sum(ts.MATCHES_LOST) 'Match lost'
from ipl_team_standings ts
join ipl_team t
using(team_id)
group by TEAM_ID
order by 4 desc;

## 7.	Display the bowlers for the Mumbai Indians team.

select p.PLAYER_ID 'Player ID', p.PLAYER_NAME 'Player Name'
from ipl_team_players tp
join ipl_team t
using(team_id)
join ipl_player p
using(player_id)
where t.TEAM_ID=5 and PLAYER_ROLE='Bowler';

## 8.	How many all-rounders are there in each team, Display the teams with more than 4 all-rounders in descending order.

select t.TEAM_NAME 'Team Name',count(*) as 'No. of All- Rounder'
from ipl_team_players tp
join ipl_team t
using(team_id)
join ipl_player p
using(player_id)
where PLAYER_ROLE='All-Rounder'
group by t.TEAM_NAME
having count(*) > 4
order by 2 desc;

## 9.  Write a query to get the total bidders points for each bidding status of those bidders who bid on CSK when it won the match in M. Chinnaswamy Stadium bidding year-wise.
##               Display columns: bidding status, bid date as year, total bidder’s points

select bd.BID_STATUS,year(bd.BID_DATE),bp.TOTAL_POINTS
from ipl_bidder_points bp
join ipl_bidding_details bd
using(bidder_id)
join ipl_match_schedule ms
using(schedule_id)
join ipl_stadium s
using(stadium_id)
where bd.BID_TEAM =1 and
s.STADIUM_NAME ='M. Chinnaswamy Stadium' and bd.bid_status='Won'
order by 3 desc;

##10.	Extract the Bowlers and All Rounders those are in the 5 highest number of wickets.

create view t_player_vw as
select ip.player_id,team_name,ip.player_name,player_role,cast(substring(performance_dtls,
position('WKT-'in performance_dtls)+4,
position('DOt'in performance_dtls)-position('WKT-'in performance_dtls)-5) as signed)  wkt_performance
from ipl_player as ip,ipl_team_players as itp, ipl_team as it
where (player_role like "%All-rounder%" or player_role='Bowler') 
and ip.player_id=itp.player_id and it.team_id=itp.team_id;

select * from(select *,dense_rank() over(order by wkt_performance desc) wkt_rank
from t_player_vw)t where wkt_rank<=5;

## 11.	show the percentage of toss wins of each bidder and display the results in descending order based on the percentage
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select bd.bidder_id,(count(*)/no_of_bids *100) 'percentageoftosswins'
from ipl_match m
join ipl_match_schedule ms
on m.MATCH_ID=ms.MATCH_ID
join ipl_bidding_details bd
on ms.SCHEDULE_ID=bd.SCHEDULE_ID
join ipl_bidder_points bp
on bp.BIDDER_ID=bd.BIDDER_ID
where bd.BID_TEAM=m.TOSS_WINNER
##bd.BID_STATUS ='Won'
group by bd.BIDDER_ID
order by percentageoftosswins desc;


##12.	find the IPL season which has min duration and max duration.

select tournmt_id,tournmt_name,duration,
case 
when max_duration=1 then 'Max Duration'
when min_duration=1 then 'Min Duration'
end Duration_range 
from(select tournmt_id,tournmt_name , (datediff(to_date,from_date)) duration,
dense_rank() over(order by (datediff(to_date,from_date)) desc) max_duration,
dense_rank() over(order by (datediff(to_date,from_date)) ) min_duration
from ipl_tournament
group by tournmt_id)dur where max_duration=1 or min_duration=1;

##13.	Write a query to display to calculate the total points month-wise for the 2017 bid year. sort the results based on total points in descending order and month-wise in ascending order.

select bd.BIDDER_ID 'bidder ID',bd.BIDDER_NAME 'Bidder Name',year(bid.bid_date) 'Year',month(bid.BID_DATE) 'Month',bp.TOTAL_POINTS 'Total Points'
from ipl_bidder_details bd
join ipl_bidding_details bid
on bd.BIDDER_ID=bid.BIDDER_ID
join ipl_bidder_points bp
on bp.BIDDER_ID=bid.BIDDER_ID
where year(bid.BID_DATE) = 2017
group by bd.bidder_id
order by 4 asc, 5 desc;

## 14.	Write a query for the above question using sub queries by having the same constraints as the above question.

select BIDDER_ID 'bidder ID',
(select bidder_name from ipl_bidder_details  bd where bd.BIDDER_ID=bid.BIDDER_ID) 'Bidder Name',
year(bid.bid_date) 'Year',month(bid.BID_DATE) 'Month',
(select TOTAL_POINTS from ipl_bidder_points bp where bp.BIDDER_ID=bid.BIDDER_ID) 'Total Points'
from ipl_bidding_details bid
where year(bid.BID_DATE) = 2017
group by bidder_id,month(bid.BID_DATE) 
order by 4 asc,5 desc;

## 15.	Write a query to get the top 3 and bottom 3 bidders based on the total bidding points for the 2018 bidding year.

select bidder_id 'Bidder ID', bidder_name 'Bidder Name',
case
when t.rankup <=3 then 'Highest top 3 bidders'
when t.rankdown <=3 then 'Lowest Top 3 bidders'
end as Rank_range from
(select bd.BIDDER_ID,bd.BIDDER_NAME,bp.TOTAL_POINTS,
dense_rank() over(order by TOTAL_POINTS desc) as rankup,
dense_rank() over(order by TOTAL_POINTS) as rankdown
from ipl_bidder_details bd
join ipl_bidding_details bid
on bd.BIDDER_ID=bid.BIDDER_ID
join ipl_bidder_points bp
on bp.BIDDER_ID=bid.BIDDER_ID
where year(bid.BID_DATE) = 2018
group by bd.bidder_id
order by rankup,rankdown)t
where t.rankup <=3 or t.rankdown <=3;

#16.Create two tables called Student_details and Student_details_backup.
create table student_details(
student_id int,
student_name varchar(30),
mail_id varchar(30),
mobile_number varchar(15));

create table student_details_backup(
student_id int,
student_name varchar(30),
mail_id varchar(30),
mobile_number varchar(15));

delimiter #
create trigger student_details_trigger after insert on student_details
for each row
begin
insert into student_details_backup(student_id,student_name,mail_id,mobile_number)
values (new.student_id,new.student_name,new.mail_id,new.mobile_number);
end #
delimiter ;
insert into student_details values(1,"jhon","jhon@great.com","9999999999");
select * from student_details;
select * from student_details_backup;