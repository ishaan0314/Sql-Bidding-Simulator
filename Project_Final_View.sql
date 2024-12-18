drop view if exists vw_PlayerBids 
go

CREATE VIEW vw_PlayerBids AS
SELECT 
    (p.player_firstname + ' ' + p.player_lastname) AS player_name,
    p.player_ranking AS player_rank,
    p.player_position as position,
    t.team_name,
    t.team_ranking,
    b.bid_amount
FROM results r
JOIN players p ON r.result_player_id = p.player_id
JOIN teams t ON r.result_team_id = t.team_id
JOIN bids b ON r.result_bid_id = b.bid_id;
GO

SELECT * FROM vw_PlayerBids;

