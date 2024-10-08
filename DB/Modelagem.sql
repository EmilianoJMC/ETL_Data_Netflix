
-- Tabelas Originadas de CSV inseridas previamente, com a adição de outras criadas para o Projeto

-- Tabela best_movie_by_year_netflix -> CSV
CREATE TABLE `best_movie_by_year_netflix` (
  `index` int DEFAULT NULL,
  `TITLE` varchar(50) DEFAULT NULL,
  `RELEASE_YEAR` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `MAIN_GENRE` varchar(50) DEFAULT NULL,
  `MAIN_PRODUCTION` varchar(50) DEFAULT NULL,
  KEY `fk_main_genre` (`MAIN_GENRE`),
  KEY `fk_title_genre_bmbyn` (`TITLE`),
  CONSTRAINT `fk_main_genre` FOREIGN KEY (`MAIN_GENRE`) REFERENCES `dim_genre_netflix` (`genre`),
  CONSTRAINT `fk_title_genre_bmbyn` FOREIGN KEY (`TITLE`) REFERENCES `dim_title_netflix` (`title`)
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
  KEY `fk_title_genre_bmn` (`title`),
  CONSTRAINT `fk_main_genre_bmn` FOREIGN KEY (`main_genre`) REFERENCES `dim_genre_netflix` (`genre`),
  CONSTRAINT `fk_title_genre_bmn` FOREIGN KEY (`title`) REFERENCES `dim_title_netflix` (`title`)
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
  KEY `fk_title_genre_bsbyn` (`TITLE`),
  CONSTRAINT `fk_main_genre_bsbyn` FOREIGN KEY (`MAIN_GENRE`) REFERENCES `dim_genre_netflix` (`genre`),
  CONSTRAINT `fk_title_genre_bsbyn` FOREIGN KEY (`TITLE`) REFERENCES `dim_title_netflix` (`title`)
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
  KEY `fk_title_genre_bsn` (`TITLE`),
  CONSTRAINT `fk_main_genre_bsn` FOREIGN KEY (`MAIN_GENRE`) REFERENCES `dim_genre_netflix` (`genre`),
  CONSTRAINT `fk_title_genre_bsn` FOREIGN KEY (`TITLE`) REFERENCES `dim_title_netflix` (`title`)
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
  `imdb_votes` double DEFAULT NULL,
  KEY `fk_title_genre_rt` (`title`),
  CONSTRAINT `fk_title_genre_rt` FOREIGN KEY (`title`) REFERENCES `dim_title_netflix` (`title`)
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


-- Tabela dim_genre_netflix criada a partir de Union para gerar Primary Key -> Criada para o Projeto
CREATE TABLE `dim_genre_netflix` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `genre` varchar(50) NOT NULL,
  PRIMARY KEY (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Tabela dim_title_netflix criada a partir de Union para gerar Primary Key -> Criada para o Projeto
CREATE TABLE `dim_title_netflix` (
  `id` bigint unsigned NOT NULL DEFAULT '0',
  `title` varchar(500) NOT NULL,
  PRIMARY KEY (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



---- ALTERAÇÕES EXECUTADAS DURANTE O PROJETO ----


-- Problemas tamanho de caracteres, erros ocorreram na inserção via Python
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
    UNION
    SELECT DISTINCT genres as genre FROM raw_titles
)
SELECT ROW_NUMBER() OVER () AS id, genre FROM valores_unicos;


-- Criar nova tabela Dimensão -> dim_title_netflix
CREATE TABLE dim_title_netflix AS
WITH valores_unicos AS (
    SELECT DISTINCT TITLE AS title FROM best_movie_by_year_netflix
    UNION
    SELECT DISTINCT TITLE AS title FROM best_show_by_year_netflix
    UNION
    SELECT DISTINCT TITLE AS title FROM best_shows_netflix
    UNION
    SELECT DISTINCT title AS title FROM best_movies_netflix
    UNION
    SELECT DISTINCT title AS title FROM raw_titles
)
SELECT ROW_NUMBER() OVER () AS id, title FROM valores_unicos;


-- Transformar o ID Gênero da tabela dim_genre_netflix em Primary KEY
ALTER TABLE dim_genre_netflix ADD PRIMARY KEY (genre);

-- Transformar o ID Título da tabela dim_title_netflix em Primary KEY
ALTER TABLE dim_title_netflix ADD PRIMARY KEY (title);

-- ID 2064 nulo, deletado para criar Primary Key da nova tabela dim_title_netflix
DELETE FROM dim_title_netflix WHERE title IS NULL;


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


-- Transformar as colunas de Títulos da cada tabela em FOREIGN KEY, para a tabela Pai -> dim_title_netflix
ALTER TABLE best_movie_by_year_netflix
ADD CONSTRAINT fk_title_genre_bmbyn
FOREIGN KEY (TITLE)
REFERENCES dim_title_netflix(title); 

ALTER TABLE best_movies_netflix
ADD CONSTRAINT fk_title_genre_bmn
FOREIGN KEY (title)
REFERENCES dim_title_netflix(title); 

ALTER TABLE best_show_by_year_netflix
ADD CONSTRAINT fk_title_genre_bsbyn
FOREIGN KEY (TITLE)
REFERENCES dim_title_netflix(title); 

ALTER TABLE best_shows_netflix
ADD CONSTRAINT fk_title_genre_bsn
FOREIGN KEY (TITLE)
REFERENCES dim_title_netflix(title); 

ALTER TABLE raw_titles
ADD CONSTRAINT fk_title_genre_rt
FOREIGN KEY (title)
REFERENCES dim_title_netflix(title); 


-- Por boa prática, coluna ID estava com números aleatórios, setado sequêncial a partir do 1
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