DROP PROCEDURE IF EXISTS SimulateDraft;
GO

CREATE PROCEDURE SimulateDraft
    @LotNumber INT,
    @RoundNumber INT
AS
BEGIN
    BEGIN TRY
        PRINT 'Starting Draft for Lot ' + CAST(@LotNumber AS NVARCHAR) + ' in Round ' + CAST(@RoundNumber AS NVARCHAR);

        -- Ensure players are available in the current lot
        IF NOT EXISTS (
            SELECT 1
            FROM players p
            WHERE p.player_status = 'available' AND p.player_current_lot = @LotNumber
        )
        BEGIN
            PRINT 'No available players in Lot ' + CAST(@LotNumber AS NVARCHAR);
            RETURN;
        END

        -- Process each available player in the current lot
        DECLARE @NextPlayerID INT, @WinningTeamID INT, @WinningBidAmount INT, @NewBidID INT;

        -- Use a cursor to iterate through players (more efficient for this scenario)
        DECLARE player_cursor CURSOR FOR
        SELECT p.player_id
        FROM players p
        WHERE p.player_status = 'available'
          AND p.player_current_lot = @LotNumber
        ORDER BY p.player_ranking ASC; -- Based on ranking

        OPEN player_cursor;
        FETCH NEXT FROM player_cursor INTO @NextPlayerID;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT 'Bidding for Player: ' + CAST(@NextPlayerID AS NVARCHAR);

            -- Calculate max bid for eligible teams
            DECLARE @TeamBids TABLE (
                team_id INT,
                max_bid INT
            );

            INSERT INTO @TeamBids (team_id, max_bid)
            SELECT 
                t.team_id,
                CASE WHEN t.team_live_budget / 2 > 0 THEN t.team_live_budget / 2 ELSE t.team_live_budget END AS max_bid
            FROM teams t
            WHERE t.team_player_count = @RoundNumber - 1
              AND t.team_live_budget > 0
              AND EXISTS (
                  SELECT 1
                  FROM players p
                  WHERE p.player_current_lot = @LotNumber
              );

            -- Determine the winning team
            SELECT TOP 1 
                @WinningTeamID = tb.team_id,
                @WinningBidAmount = tb.max_bid
            FROM @TeamBids tb
            ORDER BY tb.max_bid DESC;

            -- Handle cases where no team places a valid bid
            IF @WinningTeamID IS NULL OR @WinningBidAmount IS NULL
            BEGIN
                PRINT 'No valid bids for Player ' + CAST(@NextPlayerID AS NVARCHAR) + '. Moving to next player.';
                FETCH NEXT FROM player_cursor INTO @NextPlayerID;
                CONTINUE;
            END

            PRINT 'Winning Team: ' + CAST(@WinningTeamID AS NVARCHAR) + ' with Bid Amount: ' + CAST(@WinningBidAmount AS NVARCHAR);

            -- Insert into bids table
            INSERT INTO bids (bid_by, bid_for, bid_amount, bid_status)
            SELECT 
                tb.team_id,
                @NextPlayerID,
                tb.max_bid,
                CASE WHEN tb.team_id = @WinningTeamID THEN 'successful' ELSE 'unsuccessful' END
            FROM @TeamBids tb;

            -- Update player and team details
            UPDATE players
            SET player_status = 'assigned'
            WHERE player_id = @NextPlayerID;

            UPDATE teams
            SET team_player_count = team_player_count + 1,
                team_live_budget = team_live_budget - @WinningBidAmount
            WHERE team_id = @WinningTeamID;

            -- Insert into results table
            INSERT INTO results (result_bid_id, result_team_id, result_player_id)
            VALUES (SCOPE_IDENTITY(), @WinningTeamID, @NextPlayerID);

            PRINT 'Player ' + CAST(@NextPlayerID AS NVARCHAR) + ' assigned to Team ' + CAST(@WinningTeamID AS NVARCHAR) + '.';

            FETCH NEXT FROM player_cursor INTO @NextPlayerID;
        END;

        CLOSE player_cursor;
        DEALLOCATE player_cursor;

        PRINT 'Draft for Lot ' + CAST(@LotNumber AS NVARCHAR) + ' in Round ' + CAST(@RoundNumber AS NVARCHAR) + ' Completed.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred during the draft process.';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Execute the procedure for all lots and rounds
EXEC SimulateDraft @LotNumber = 1, @RoundNumber = 1;
EXEC SimulateDraft @LotNumber = 2, @RoundNumber = 1;
EXEC SimulateDraft @LotNumber = 3, @RoundNumber = 1;

EXEC SimulateDraft @LotNumber = 4, @RoundNumber = 2;
EXEC SimulateDraft @LotNumber = 5, @RoundNumber = 2;
EXEC SimulateDraft @LotNumber = 6, @RoundNumber = 2;

EXEC SimulateDraft @LotNumber = 7, @RoundNumber = 3;
EXEC SimulateDraft @LotNumber = 8, @RoundNumber = 3;
EXEC SimulateDraft @LotNumber = 9, @RoundNumber = 3;

-- Check results
SELECT * FROM results;
SELECT * FROM bids;
