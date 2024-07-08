SQL_Project_IPL_Analysis
-------------------------------------------------------------------
SQL project to analyze IPL data insights

This project is for beginners and will teach you how to analyze the IPL database. You can examine the dataset with SQL and help the store understand its IPL growth by answering simple questions.

1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

2.	Display the number of matches conducted at each stadium with the stadium name and city.

3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

4.	Show the total bids along with the bid team and team name.

5.	Show the team id who won the match as per the win details.

6.	Display total matches played, total matches won and total matches lost by the team along with its team name.

7.	Display the bowlers for the Mumbai Indians team.

8.	How many all-rounders are there in each team, Display the teams with more than 4 all-rounders in descending order.

9.	 Write a query to get the total bidders points for each bidding status of those bidders who bid on CSK when it won the match in M. Chinnaswamy Stadium bidding year-wise.
 Note the total bidders’ points in descending order and the year is bidding year. Display columns: bidding status, bid date as year, total bidder’s points

10.	Extract the Bowlers and All Rounders those are in the 5 highest number of wickets.
Note 
1. use the performance_dtls column from ipl_player to get the total number of wickets
2. Do not use the limit method because it might not give appropriate results when players have the same number of wickets
3.	Do not use joins in any cases.
4.	Display the following columns teamn_name, player_name, and player_role.

11.	show the percentage of toss wins of each bidder and display the results in descending order based on the percentage

12.	find the IPL season which has min duration and max duration.
Output columns should be like the below:
 Tournment_ID, Tourment_name, Duration column, Duration

13.	Write a query to display to calculate the total points month-wise for the 2017 bid year. sort the results based on total points in descending order and month-wise in ascending order.
Note: Display the following columns:
1.	Bidder ID, 2. Bidder Name, 3. bid date as Year, 4. bid date as Month, 5. Total points
Only use joins for the above query queries.

14.	Write a query for the above question using sub queries by having the same constraints as the above question.

15.	Write a query to get the top 3 and bottom 3 bidders based on the total bidding points for the 2018 bidding year.
Output columns should be:
like:
Bidder Id, Ranks (optional), Total points, Highest_3_Bidders --> columns contains name of bidder, Lowest_3_Bidders  --> columns contains name of bidder;
