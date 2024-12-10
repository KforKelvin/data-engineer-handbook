-- Question 1: actors table:

-- create type films as (
--     film text,
--     votes integer,
--     rating real,
--     filmid text
-- );
-- -- drop type film cascade
-- CREATE TYPE quality_class AS ENUM ('bad', 'average', 'good', 'star');
--
--
-- CREATE TABLE actors (
--     actorid        text PRIMARY KEY,
--     actor           TEXT NOT NULL,
--     films           films[],          -- Array of the composite type
--     quality_class   TEXT NOT NULL CHECK (quality_class IN ('star', 'good', 'average', 'bad')),
--     is_active       BOOLEAN NOT NULL
-- );
-- drop table actors

-- WITH latest_year_by_actor AS (
--   SELECT actorid, MAX(year) AS latest_year
--   FROM actor_films
--   GROUP BY actorid
-- ),
-- actor_recent_films AS (
--   SELECT f.actorid, f.rating
--   FROM actor_films f
--   JOIN latest_year_by_actor ly
--     ON f.actorid = ly.actorid
--    AND f.year = ly.latest_year
-- ),
-- actor_quality AS (
--   SELECT actorid,
--          AVG(rating) AS avg_rating
--   FROM actor_recent_films
--   GROUP BY actorid
-- )
--
-- -- INSERT INTO actors (actorid, actor, films, quality_class, is_active)
-- SELECT
--   af.actorid,
--   MAX(af.actor) AS actor,
--   ARRAY_AGG((af.film, af.votes, af.rating, af.filmid)::films ORDER BY af.year) AS films,
--   CASE
--     WHEN aq.avg_rating > 8 THEN 'star'
--     WHEN aq.avg_rating > 7 THEN 'good'
--     WHEN aq.avg_rating > 6 THEN 'average'
--     ELSE 'bad'
--   END AS quality_class,
--   -- If the actor has a film in the current year, they are active
--   CASE
-- --     WHEN MAX(af.year) = 2021 THEN TRUE
--     WHEN MAX(af.year) = EXTRACT(YEAR FROM CURRENT_DATE) THEN TRUE
--     ELSE FALSE
--   END AS is_active
-- FROM actor_films af
-- JOIN actor_quality aq ON af.actorid = aq.actorid
-- GROUP BY af.actorid, aq.avg_rating;

-- select * from actors;



-- Q2: Cumulative table generation query
-- clear out table from the previous question
-- DROP TABLE IF EXISTS actors;
-- DROP TYPE IF EXISTS films CASCADE;
-- DROP TYPE IF EXISTS quality_class CASCADE;

-- create type films as (
--     film text,
--     votes integer,
--     rating real,
--     filmid text
-- );

-- CREATE TYPE quality_class AS ENUM ('bad', 'average', 'good', 'star');
-- create table actors(
--     snapshot_year integer not null,
--     actorid text not null,
--     actor text not null,
--     films films[],
--     quality_class TEXT NOT NULL CHECK (quality_class IN ('star', 'good', 'average', 'bad')),
--     is_active boolean,
--     primary key (snapshot_year,actorid)
-- )


-- \set target_year 2018
-- with latest_year_by_actor as (
--     SELECT actorid, MAX(year) AS latest_year
--       FROM actor_films
--     WHERE year <= :target_year
--     GROUP BY actorid
--
-- ),
--     actor_recent_films as(
--         SELECT
--             f.actorid, f.rating
--         FROM actor_films f
--         JOIN latest_year_by_actor ly
--         ON f.actorid = ly.actorid AND f.year = ly.latest_year
-- ),
--     actor_quality as (
--         SELECT actorid,
--             AVG(rating) AS avg_rating
--         FROM actor_recent_films
--         GROUP BY actorid
-- )
--
-- select
--     :target_year as snapshot_year,
--     af.actorid,
--     MAX(af.actor) AS actor,
--     ARRAY_AGG((af.film, af.votes, af.rating, af.filmid)::films ORDER BY af.year) AS films,
--     CASE
--         WHEN aq.avg_rating > 8 THEN 'star'
--         WHEN aq.avg_rating > 7 THEN 'good'
--         WHEN aq.avg_rating > 6 THEN 'average'
--         ELSE 'bad'
--       END AS quality_class,
--
--     CASE
--         WHEN MAX(af.year) = :target_year THEN TRUE
--         ELSE FALSE
--       END AS is_active
--
-- from actor_films af
-- join actor_quality aq on af.actorid = aq.actorid
-- where af.year <= :target_year
-- group by af.actorid, aq.avg_rating;

-- Q3: actors_history_scd
CREATE TABLE actors_history_scd (
    actor_scd_id     SERIAL PRIMARY KEY,
    actorid          TEXT NOT NULL,
    actor            TEXT NOT NULL,
    quality_class    TEXT NOT NULL CHECK (quality_class IN ('star', 'good', 'average', 'bad')),
    is_active        BOOLEAN NOT NULL,
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL DEFAULT ('9999-12-31'::date)
);
SELECT
    a.actorid,
    a.actor,
    a.quality_class,
    a.is_active,
    2013 as start_date,
    '9999-12-31' as end_date
FROM actors a;