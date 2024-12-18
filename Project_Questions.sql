--1. How many players were drafted?

SELECT count(player_id) as 'Drafted Players'

FROM players 

WHERE player_status = 'assigned'; 

 

--2.⁠ ⁠Which teams have the highest remaining budget? 
SELECT top 5 team_id, team_name, team_ranking, team_live_budget 

FROM teams 

ORDER BY team_live_budget DESC 


 

--3.⁠ ⁠Which players had the 5 highest bid amounts? 

SELECT top 5 player_id, player_firstname + ' ' + player_lastname as player_name, MAX(bid_amount) as highest_bid 

FROM bids b
join players p on b.bid_for = p.player_id

GROUP BY player_id, player_firstname + ' ' + player_lastname

ORDER BY highest_bid DESC 


 

--4.⁠ ⁠Which positions were most in demand? 

SELECT player_position, COUNT(*) as demand_count 

FROM players

GROUP BY player_position 

ORDER BY demand_count DESC; 

 

-- 5.⁠ ⁠Which teams had the most failed bids? 

SELECT top 5 team_id, team_name, COUNT(*) as failed_bids 

FROM bids b join teams t 
on b.bid_by = t.team_id

WHERE bid_status = 'Unsuccessful' 

GROUP BY team_id, team_name 

ORDER BY failed_bids DESC;