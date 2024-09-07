
-- Tabelas Originadas de CSV 

-- Criar nova tabela Dimensão -> dim_genre_netflix

CREATE TABLE dim_genre_netflix AS
WITH valores_unicos AS (
    SELECT DISTINCT MAIN_GENRE AS genre FROM best_movie_by_year_netflix
    UNION
    SELECT DISTINCT MAIN_GENRE AS genre FROM best_show_by_year_netflix
    UNION
    SELECT DISTINCT MAIN_GENRE AS genre FROM best_shows_netflix
)

SELECT ROW_NUMBER() OVER () AS id, genre FROM valores_unicos;


-- Tabela best_movie_by_year_netflix 

CREATE TABLE `best_movie_by_year_netflix` (
  `index` int DEFAULT NULL,
  `TITLE` varchar(50) DEFAULT NULL,
  `RELEASE_YEAR` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `MAIN_GENRE` varchar(50) DEFAULT NULL,
  `MAIN_PRODUCTION` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela best_movies_netflix 

CREATE TABLE `best_movies_netflix` (
  `index` int DEFAULT NULL,
  `title` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `release_year` int DEFAULT NULL,
  `score` double DEFAULT NULL,
  `number_of_votes` int DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `main_genre` varchar(50) DEFAULT NULL,
  `main_production` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela best_show_by_year_netflix 

CREATE TABLE `best_show_by_year_netflix` (
  `index` int DEFAULT NULL,
  `TITLE` varchar(50) DEFAULT NULL,
  `RELEASE_YEAR` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `NUMBER_OF_SEASONS` int DEFAULT NULL,
  `MAIN_GENRE` varchar(50) DEFAULT NULL,
  `MAIN_PRODUCTION` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela best_shows_netflix 

CREATE TABLE `best_shows_netflix` (
  `index` int DEFAULT NULL,
  `TITLE` varchar(50) DEFAULT NULL,
  `RELEASE_YEAR` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `NUMBER_OF_VOTES` int DEFAULT NULL,
  `DURATION` int DEFAULT NULL,
  `NUMBER_OF_SEASONS` int DEFAULT NULL,
  `MAIN_GENRE` varchar(50) DEFAULT NULL,
  `MAIN_PRODUCTION` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela raw_credits 

CREATE TABLE `raw_credits` (
  `index` int DEFAULT NULL,
  `person_id` int DEFAULT NULL,
  `id` varchar(50) DEFAULT NULL,
  `name` varchar(500) DEFAULT NULL,
  `character` varchar(500) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--Tabela raw_titles 

CREATE TABLE `raw_titles` (
  `index` int DEFAULT NULL,
  `id` varchar(50) DEFAULT NULL,
  `title` varchar(500) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `release_year` int DEFAULT NULL,
  `age_certification` varchar(50) DEFAULT NULL,
  `runtime` int DEFAULT NULL,
  `genres` varchar(128) DEFAULT NULL,
  `production_countries` varchar(50) DEFAULT NULL,
  `seasons` double DEFAULT NULL,
  `imdb_id` varchar(50) DEFAULT NULL,
  `imdb_score` double DEFAULT NULL,
  `imdb_votes` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Alterações Executados durante o Projeto

-- Problemas tamanho de caracteres
ALTER TABLE raw_credits MODIFY COLUMN `character` VARCHAR(500);
ALTER TABLE raw_credits MODIFY COLUMN `name` VARCHAR(500);
ALTER TABLE raw_titles MODIFY COLUMN `title` VARCHAR(500);