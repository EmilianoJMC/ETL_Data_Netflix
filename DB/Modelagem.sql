
-- Tabelas Originadas de CSV inseridas previamente e criadas para o Projeto

-- Tabela best_movie_by_year_netflix -> CSV
CREATE TABLE `best_movie_by_year_netflix` (
  `index` int DEFAULT NULL,
  `TITLE` varchar(50) DEFAULT NULL,
  `RELEASE_YEAR` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `MAIN_GENRE` varchar(50) DEFAULT NULL,
  `MAIN_PRODUCTION` varchar(50) DEFAULT NULL,
  KEY `fk_main_genre` (`MAIN_GENRE`),
  CONSTRAINT `fk_main_genre` FOREIGN KEY (`MAIN_GENRE`) REFERENCES `dim_genre_netflix` (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela best_movies_netflix -> CSV
CREATE TABLE `best_movies_netflix` (
  `index` int DEFAULT NULL,
  `title` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `release_year` int DEFAULT NULL,
  `score` double DEFAULT NULL,
  `number_of_votes` int DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `main_genre` varchar(50) DEFAULT NULL,
  `main_production` varchar(50) DEFAULT NULL,
  KEY `fk_main_genre_bmn` (`main_genre`),
  CONSTRAINT `fk_main_genre_bmn` FOREIGN KEY (`main_genre`) REFERENCES `dim_genre_netflix` (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela best_show_by_year_netflix -> CSV
CREATE TABLE `best_show_by_year_netflix` (
  `index` int DEFAULT NULL,
  `TITLE` varchar(50) DEFAULT NULL,
  `RELEASE_YEAR` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `NUMBER_OF_SEASONS` int DEFAULT NULL,
  `MAIN_GENRE` varchar(50) DEFAULT NULL,
  `MAIN_PRODUCTION` varchar(50) DEFAULT NULL,
  KEY `fk_main_genre_bsbyn` (`MAIN_GENRE`),
  CONSTRAINT `fk_main_genre_bsbyn` FOREIGN KEY (`MAIN_GENRE`) REFERENCES `dim_genre_netflix` (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela best_shows_netflix -> CSV
CREATE TABLE `best_shows_netflix` (
  `index` int DEFAULT NULL,
  `TITLE` varchar(50) DEFAULT NULL,
  `RELEASE_YEAR` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `NUMBER_OF_VOTES` int DEFAULT NULL,
  `DURATION` int DEFAULT NULL,
  `NUMBER_OF_SEASONS` int DEFAULT NULL,
  `MAIN_GENRE` varchar(50) DEFAULT NULL,
  `MAIN_PRODUCTION` varchar(50) DEFAULT NULL,
  KEY `fk_main_genre_bsn` (`MAIN_GENRE`),
  CONSTRAINT `fk_main_genre_bsn` FOREIGN KEY (`MAIN_GENRE`) REFERENCES `dim_genre_netflix` (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela raw_credits -> CSV
CREATE TABLE `raw_credits` (
  `index` int DEFAULT NULL,
  `person_id` int DEFAULT NULL,
  `id` varchar(50) DEFAULT NULL,
  `name` varchar(500) DEFAULT NULL,
  `character` varchar(500) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--Tabela raw_titles -> CSV
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


-- Tabela dim_genre_netflix criada a partir de Union para gerar Primary Key -> Criada para o Projeto
CREATE TABLE `dim_genre_netflix` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `genre` varchar(50) NOT NULL,
  PRIMARY KEY (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



---- ALTERAÇÕES EXECUTADAS DURANTE O PROJETO ----


-- Problemas tamanho de caracteres, erros acorreram na inserção via Python
ALTER TABLE raw_credits MODIFY COLUMN `character` VARCHAR(500);
ALTER TABLE raw_credits MODIFY COLUMN `name` VARCHAR(500);
ALTER TABLE raw_titles MODIFY COLUMN `title` VARCHAR(500);


-- Criar nova tabela Dimensão -> dim_genre_netflix
CREATE TABLE dim_genre_netflix AS
WITH valores_unicos AS (
    SELECT DISTINCT MAIN_GENRE AS genre FROM best_movie_by_year_netflix
    UNION
    SELECT DISTINCT MAIN_GENRE AS genre FROM best_show_by_year_netflix
    UNION
    SELECT DISTINCT MAIN_GENRE AS genre FROM best_shows_netflix
    UNION 
    SELECT DISTINCT main_genre as genre FROM best_movies_netflix
)


-- Transformar o ID Gênero das tabelas em Primary KEY
ALTER TABLE dim_genre_netflix ADD PRIMARY KEY (genre);


-- Transformar as colunas de Gêneros da cada tabela em FOREIGN KEY, para a tabela Pai -> dim_genre_netflix
ALTER TABLE best_movie_by_year_netflix
ADD CONSTRAINT fk_main_genre
FOREIGN KEY (MAIN_GENRE)
REFERENCES dim_genre_netflix(genre); 

ALTER TABLE best_show_by_year_netflix
ADD CONSTRAINT fk_main_genre_bsbyn
FOREIGN KEY (MAIN_GENRE)
REFERENCES dim_genre_netflix(genre);

ALTER TABLE best_shows_netflix
ADD CONSTRAINT fk_main_genre_bsn
FOREIGN KEY (MAIN_GENRE)
REFERENCES dim_genre_netflix(genre); 

ALTER TABLE best_movies_netflix
ADD CONSTRAINT fk_main_genre_bmn
FOREIGN KEY (MAIN_GENRE)
REFERENCES dim_genre_netflix(genre); 

ALTER TABLE best_movies_netflix
ADD CONSTRAINT fk_main_genre_bmn
FOREIGN KEY (main_genre)
REFERENCES dim_genre_netflix(genre); 


-- Por boa prática, coluna ID estava com números aleatórios, setado sequencial a partir do 1
SET @id_seq = 0; -- Setar Variável
UPDATE dim_genre_netflix 
SET ID = (@id_seq := @id_seq + 1)
ORDER BY ID;


-- Trigger para comportamento da coluna production_countries, tabela raw_titles
CREATE TRIGGER clean_production_countries_before_insert
BEFORE INSERT ON raw_titles
FOR EACH ROW
BEGIN
    SET NEW.production_countries = REPLACE(SUBSTRING_INDEX(REPLACE(REPLACE(REPLACE(NEW.production_countries, '[', ''), ']', ''), '''', ''), ',', 1), '''', '');
END;


-- Trigger para comportamento da coluna genre, tabela raw_titles
CREATE TRIGGER clean_genres_before_insert
BEFORE INSERT ON raw_titles
FOR EACH ROW
BEGIN
    SET NEW.genres = REPLACE(SUBSTRING_INDEX(REPLACE(REPLACE(REPLACE(NEW.genres, '[', ''), ']', ''), '''', ''), ',', 1), '''', '');
END;