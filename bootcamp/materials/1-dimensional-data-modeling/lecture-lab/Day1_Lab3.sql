CREATE TYPE vertex_type
AS ENUM('player', 'team', 'game');

CREATE TABLE vertices (
    identifier TEXT,
    type vertex_type,
    properties JSON,
    PRIMARY KEY (identifier, type)
);

create type edge_type as
    enum('plays_against', 'shares_team', 'plays_in', 'plays_on')

CREATE TABLE edges (
    subject_identifier TEXT,
    subject_type vertex_type,
    object_identifier TEXT,
    object_type vertex_type,
    edge_type edge_type,
    properties JSON,
    primary key (
        subject_identifier,
        subject_type,
        object_identifier,
        object_type,
        edge_type
        )

)

-- SELECT
--     game_id AS identifier,
--     'game'::vertex_type AS type,
--     json_build_object(
--         'pts_home', pts_home,
--         'pts_away', pts_away,
--         'winning_team', CASE WHEN home_team_wins = 1 THEN home_team_id ELSE visitor_team_id END
--     ) as properties
-- FROM games;

-- INSERT INTO vertices
-- WITH players_agg AS (
--     SELECT player_id            AS identifier,
--            MAX(player_name)     AS player_name,
--            COUNT(1)             AS number_of_games,
--            SUM(pts)             AS total_points,
--            ARRAY_AGG(DISTINCT team_id) AS teams
--     FROM game_details
--     GROUP BY player_id
-- )
--
-- -- select * from players_agg
-- select identifier, 'player'::vertex_type,
--        json_build_object(
--         'player_name', player_name,
--         'number_of_games', number_of_games,
--         'total_points', total_points,
--         'teams', teams
--        )
-- from players_agg

-- insert into vertices
-- with team_deduped as (
--     select *, row_number() over (partition by team_id) as row_num from teams
-- )
-- SELECT
--     team_id AS identifier,
--     'team'::vertex_type AS type,
--     json_build_object(
--         'abbreviation', abbreviation,
--         'nickname', nickname,
--         'city', city,
--         'arena', arena,
--         'year_founded', yearfounded
--     )
-- FROM team_deduped
-- where row_num = 1

-- select type, count(1) from vertices group by 1

-- 20:58 https://www.youtube.com/watch?v=8J1uOJI2HFE&t=4s

