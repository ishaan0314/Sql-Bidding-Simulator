use [Project DB] 
go 

--DOWN
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_preference_team_id')
    alter table preferences drop constraint fk_preference_team_id

drop table if exists preferences

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_result_player_id')
    alter table results drop constraint fk_result_player_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_result_team_id')
    alter table results drop constraint fk_result_team_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_result_bid_id')
    alter table results drop constraint fk_result_bid_id

drop table if exists results

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_players_bid_for')
    alter table bids drop constraint fk_players_bid_for

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_teams_bid_by')
    alter table bids drop constraint fk_teams_bid_by

drop table if exists bids

drop table if exists teams

drop table if exists players





--UP Metadata
create table players(

    player_id int identity not null,
    player_firstname varchar(50) not null,
    player_lastname varchar(50) not null,
    player_ppg float not null,
    player_apg float not null,
    player_rpg float not null,
    player_impact float not null,
    player_position varchar(2) not null,
    player_ranking int not null,
    player_status varchar(10) not null,
    player_current_lot int not null,
    constraint pk_player_id primary key(player_id),
    constraint u_player_ranking unique(player_ranking)
)

create table teams(

    team_id int identity not null,
    team_name varchar(50) not null,
    team_total_budget integer not null,
    team_live_budget float not null,
    team_ranking int not null,
    team_player_count int not null,
    team_lot_round_1 int not null,
    team_lot_round_2 int not null,
    team_lot_round_3 int not null,
    constraint pk_team_id primary key(team_id),
    constraint u_team_name unique(team_name),
    constraint u_team_ranking unique(team_ranking),
    constraint ck_max_players check(team_player_count <= 3),
    constraint ck_min_budget check(team_live_budget >=0)
)

create table bids(

    bid_id int identity not null,
    bid_by int not null,
    bid_for int not null,
    bid_amount float not null,
    bid_status varchar(30) not null,
    constraint pk_bid_id primary key(bid_id),
    constraint ck_min_bid check(bid_amount > 0),
    constraint u_bid_player unique(bid_by, bid_for)
)

alter table bids 
    add constraint fk_teams_bid_by foreign key(bid_by)
        references teams(team_id)

alter table bids
    add constraint fk_players_bid_for foreign key(bid_for)
        references players(player_id)

create table results(

    result_id int identity not null,
    result_bid_id int not null,
    result_team_id int not null,
    result_player_id int not null,
    constraint pk_result_id primary key(result_id),
)

alter table results 
    add constraint fk_result_bid_id foreign key(result_bid_id)
        references bids(bid_id)

alter table results
    add constraint fk_result_team_id foreign key(result_team_id)
        references teams(team_id)

alter table results
    add constraint fk_result_player_id foreign key(result_player_id)
        references players(player_id)

create table preferences(

    preference_id int identity not null,
    preference_team_id int not null,
    preferred_player_position_1 varchar(2) not null,
    preferred_player_position_2 varchar(2) not null,
    preferred_player_position_3 varchar(2) not null,
    constraint pk_preference_id primary key(preference_id)
)



alter table preferences
    add constraint fk_preference_team_id foreign key(preference_team_id)
        references teams(team_id)

--create table team_preferences(

 --   preference_id int, 
   -- team_id int identity not null,
    --constraint pk_preference_team_id primary key(team_id, preference_id)
--)


-- UP Data
INSERT INTO players (player_firstname, player_lastname, player_ppg, player_apg, player_rpg, player_impact, player_position, player_ranking, player_status, player_current_lot)
VALUES
('Malik', 'Boards', 22.8, 9.0, 12.4, 8.9, 'SF', 1, 'available', 1),
('Terrance', 'Hustle', 22.9, 7.8, 11.6, 9.1, 'SG', 2, 'available', 1),
('Andre', 'Glassman', 24.3, 6.5, 9.7, 12.0, 'PF', 3, 'available', 1),
('Jabari', 'Skyhook', 21.5, 7.6, 13.7, 9.3, 'PG', 4, 'available', 1),
('Antwan', 'Postman', 21.6, 6.4, 13.8, 10.0, 'C', 5, 'available', 1),
('Trey', 'Buckets', 23.4, 7.8, 11.3, 9.2, 'PG', 6, 'available', 2),
('Desmond', 'Rooftop', 24.0, 8.9, 11.0, 7.6, 'PF', 7, 'available', 2),
('Tyrese', 'Steele', 23.1, 8.4, 10.0, 9.6, 'SG', 8, 'available', 2),
('Trey', 'Dagger', 20.0, 7.9, 13.5, 9.4, 'SF', 9, 'available', 2),
('Tavon', 'Icewater', 21.9, 8.8, 10.5, 9.2, 'C', 10, 'available', 2),
('Deshawn', 'Crossover', 21.9, 3.9, 14.0, 10.2, 'PG', 11, 'available', 3),
('Devon', 'Finisher', 18.6, 9.2, 13.3, 8.5, 'SF', 12, 'available', 3),
('Damian', 'Grind', 21.2, 8.5, 12.1, 7.3, 'SG', 13, 'available', 3),
('Kendrick', 'Outlaw', 23.4, 6.9, 10.6, 8.2, 'PF', 14, 'available', 3),
('Zion', 'Baseline', 24.1, 5.6, 11.2, 7.9, 'C', 15, 'available', 3),
('Kareem', 'Hardaway', 19.7, 9.2, 11.3, 8.3, 'PF', 16, 'available', 4),
('Juwan', 'Lightsout', 21.3, 7.1, 9.4, 10.2, 'SG', 17, 'available', 4),
('DeAndre', 'Buckets', 21.7, 9.0, 9.5, 7.8, 'C', 18, 'available', 4),
('Jalen', 'Fastbreak', 19.5, 8.1, 12.2, 7.1, 'PG', 19, 'available', 4),
('Brandon', 'Tallman', 20.0, 7.3, 12.5, 7.5, 'SF', 20, 'available', 4),
('Chase', 'Quickstep', 22.7, 5.8, 10.6, 8.1, 'PF', 21, 'available', 5),
('Amir', 'Fastlane', 23.3, 7.5, 9.4, 6.7, 'PG', 22, 'available', 5),
('Malik', 'Rimrocker', 19.8, 7.1, 12.8, 7.0, 'SG', 23, 'available', 5),
('Eli', 'Moneyshot', 22.2, 5.5, 12.0, 6.5, 'C', 24, 'available', 5),
('Cedric', 'Buckets', 20.1, 8.0, 11.5, 6.5, 'SF', 25, 'available', 5),
('Kenyon', 'Fullcourt', 23.7, 6.0, 9.0, 6.8, 'PG', 26, 'available', 6),
('Phil', 'Swish', 25.0, 6.5, 10.1, 4.2, 'C', 27, 'available', 6),
('Rashawn', 'Ballerson', 18.8, 7.5, 12.1, 7.2, 'SF', 28, 'available', 6),
('Chad', 'Backboard', 18.4, 8.8, 11.9, 6.4, 'PF', 29, 'available', 6),
('Lamar', 'Clutch', 20.8, 7.7, 13.0, 4.0, 'SG', 30, 'available', 6),
('Jamal', 'Hooper', 20.5, 8.2, 11.7, 5.0, 'SG', 31, 'available', 7),
('Marcus', 'Swift', 20.1, 6.3, 13.5, 5.6, 'SF', 32, 'available', 7),
('Keon', 'Clutchman', 18.2, 6.9, 13.1, 7.0, 'C', 33, 'available', 7),
('Jamal', 'Pivot', 17.2, 7.7, 13.1, 7.0, 'PF', 34, 'available', 7),
('Donovan', 'Drainer', 18.7, 8.2, 13.0, 4.6, 'PF', 35, 'available', 7),
('Marcus', 'Grinder', 19.2, 6.7, 11.8, 6.7, 'PG', 36, 'available', 8),
('Jamal', 'Bigman', 18.9, 5.5, 12.7, 6.4, 'SG', 37, 'available', 8),
('Cole', 'Shooter', 17.3, 5.9, 14.0, 6.2, 'C', 38, 'available', 8),
('Leroy', 'Fastlane', 22.5, 4.8, 10.3, 5.6, 'PF', 39, 'available', 8),
('Tristan', 'Backspin', 18.1, 9.3, 10.0, 5.5, 'SF', 40, 'available', 8),
('Corey', 'Toughshot', 20.4, 6.1, 11.5, 4.8, 'SG', 41, 'available', 9),
('Jaylen', 'Deep', 20.8, 6.7, 9.2, 5.9, 'PF', 42, 'available', 9),
('Marvin', 'Splash', 19.8, 8.3, 10.8, 3.6, 'SF', 43, 'available', 9),
('Andre', 'Handoff', 19.9, 8.2, 9.9, 4.1, 'PG', 44, 'available', 9),
('Ethan', 'Drive', 20.5, 8.5, 10.5, 2.4, 'C', 45, 'available', 9),
('Malcolm', 'Floater', 18.7, 6.4, 12.2, 4.3, 'C', 46, 'available', 10),
('Antonio', 'Baseline', 19.7, 6.8, 11.2, 3.8, 'SG', 47, 'available', 10),
('Tyrone', 'Paintman', 19.4, 5.8, 11.7, 4.3, 'PG', 48, 'available', 10),
('Chris', 'Hardcourt', 17.6, 5.3, 12.1, 6.0, 'SF', 49, 'available', 10),
('Xavier', 'Bigshot', 21.4, 4.2, 11.7, 2.9, 'PF', 50, 'available', 10),
('Isaiah', 'Spinmove', 19.1, 7.2, 10.3, 3.1, 'PG', 51, 'available', 11),
('Brett', 'Layup', 15.4, 7.2, 11.5, 5.1, 'SG', 52, 'available', 11),
('Darnell', 'Pivot', 17.9, 4.0, 13.0, 3.3, 'C', 53, 'available', 11),
('Devonte', 'Skywalker', 22.0, 4.5, 10.9, 0.4, 'SF', 54, 'available', 11),
('Jahlil', 'Glasscleaner', 17.5, 5.6, 9.8, 1.7, 'PF', 55, 'available', 11),
('Jordan', 'Alleyoop', 18.9, 4.7, 9.9, -2.5, 'PF', 56, 'available', 12),
('Darius', 'Boardman', 16.4, 3.8, 8.4, 1.0, 'C', 57, 'available', 12),
('Javon', 'Swatson', 18.3, 3.5, 8.5, -1.4, 'SG', 58, 'available', 12),
('Mark', 'Romayes', 16.8, 2.1, 5.6, -2.6, 'PG', 59, 'available', 12),
('Mario', 'Dosa', 15.4, 1.5, 6.8, -1.2, 'SF', 60, 'available', 12);


-- Insert 20 teams named after U.S. locations
INSERT INTO teams (team_name, team_total_budget, team_live_budget, team_ranking, team_player_count, team_lot_round_1, team_lot_round_2, team_lot_round_3)
VALUES
('Seattle Slammers', 916, 916, 1, 0, 4, 8, 12),
('Houston Hustlers', 1070, 1070, 2, 0, 4, 8, 12),
('Miami Maniacs', 964, 964, 3, 0, 4, 8, 12),
('Brooklyn Bruisers', 942, 942, 4, 0, 4, 8, 12),
('Dallas Dunkers', 1088, 1088, 5, 0, 4, 8, 12),
('Chicago Crushers', 964, 964, 6, 0, 3, 7, 11),
('Phoenix Phantoms', 900, 900, 7, 0, 3, 7, 11),
('Vegas Villains', 932, 932, 8, 0, 3, 7, 11),
('Detroit Destroyers', 1004, 1004, 9, 0, 3, 7, 11),
('Atlanta Avengers', 998, 998, 10, 0, 3, 7, 11),
('Boston Beasts', 946, 946, 11, 0, 2, 6, 10),
('Portland Predators', 1032, 1032, 12, 0, 2, 6, 10),
('Denver Daredevils', 986, 986, 13, 0, 2, 6, 10),
('Orlando Outlaws', 974, 974, 14, 0, 2, 6, 10),
('San Diego Savages', 1014, 1014, 15, 0, 2, 6, 10),
('Memphis Mayhem', 996, 996, 16, 0, 1, 5, 9),
('New Orleans Nightmares', 1076, 1076, 17, 0, 1, 5, 9),
('Cleveland Chaos', 1018, 1018, 18, 0, 1, 5, 9),
('San Francisco Fire', 1038, 1038, 19, 0, 1, 5, 9),
('Los Angeles Legends', 1054, 1054, 20, 0, 1, 5, 9);

-- Insert values into the preferences table
INSERT INTO preferences (preference_team_id, preferred_player_position_1, preferred_player_position_2, preferred_player_position_3)
VALUES 
(1, 'SG', 'PG', 'C'),
(2, 'PF', 'SF', 'SG'),
(3, 'PG', 'C', 'PF'),
(4, 'SF', 'SG', 'PG'),
(5, 'C', 'PF', 'SF'),
(6, 'SG', 'PG', 'SF'),
(7, 'PF', 'C', 'SG'),
(8, 'PG', 'SF', 'PF'),
(9, 'SG', 'C', 'PG'),
(10, 'SF', 'PF', 'C'),
(11, 'C', 'SG', 'PG'),
(12, 'PF', 'PG', 'SF'),
(13, 'SG', 'SF', 'PF'),
(14, 'PF', 'C', 'SG'),
(15, 'SF', 'C', 'PG'),
(16, 'C', 'PF', 'SF'),
(17, 'PG', 'SG', 'C'),
(18, 'SG', 'PG', 'PF'),
(19, 'PF', 'C', 'SF'),
(20, 'C', 'PF', 'PG');



