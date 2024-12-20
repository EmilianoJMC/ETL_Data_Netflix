
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


-- View para Melhores Títulos por Gênero e Ano
CREATE VIEW vw_best_titles_by_genre_year AS
SELECT
    t.title,
    t.release_year,
    g.genre,
    t.score,
    t.number_of_votes,
    t.duration,
    'Movie' AS type
FROM
    best_movies_netflix t
    LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre
UNION ALL
SELECT
    t.title,
    t.release_year,
    g.genre,
    t.score,
    t.number_of_votes,
    t.duration,
    'Show' AS type
FROM
    best_shows_netflix t
    LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre;
   
   
-- View de Produções por País
CREATE VIEW vw_productions_by_country AS
SELECT
    t.production_countries AS country,
    COUNT(DISTINCT t.title) AS total_titles,
    AVG(t.imdb_score) AS avg_score,
    AVG(t.imdb_votes) AS avg_votes
FROM
    raw_titles t
GROUP BY
    t.production_countries;   


-- View Gêneros ao longo dos Anos
CREATE VIEW vw_genre_trends AS
SELECT
    g.genre,
    t.release_year,
    COUNT(*) AS total_titles,
    AVG(t.score) AS avg_score
FROM
    best_movies_netflix t
    JOIN dim_genre_netflix g ON t.main_genre = g.genre
GROUP BY
    g.genre, t.release_year
ORDER BY
    t.release_year, total_titles DESC;


-- View Participaçoes dos Atores e Personagens
 CREATE VIEW vw_actor_roles AS
SELECT
    c.name AS actor,
    c.character,
    c.role,
    COUNT(*) AS total_appearances
FROM
    raw_credits c
GROUP BY
    c.name, c.character, c.role
ORDER BY
    total_appearances DESC;


-- View Gêneros Populares por Ano
CREATE VIEW vw_genre_popularity_by_year AS
SELECT
    t.release_year,
    g.genre,
    COUNT(t.title) AS total_titles,
    AVG(t.score) AS avg_score,
    SUM(t.number_of_votes) AS total_votes
FROM (
    SELECT title, release_year, main_genre, score, number_of_votes FROM best_movies_netflix
    UNION ALL
    SELECT title, release_year, main_genre, score, number_of_votes FROM best_shows_netflix
) t
LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre
GROUP BY t.release_year, g.genre
ORDER BY t.release_year, total_votes DESC;


-- View Top 10 Títulos por Pontuação
CREATE VIEW vw_top_10_titles AS
SELECT
    title,
    type,
    release_year,
    score,
    number_of_votes,
    genre
FROM (
    SELECT
        t.title,
        'Movie' AS type,
        t.release_year,
        t.score,
        t.number_of_votes,
        g.genre
    FROM best_movies_netflix t
    LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre
    UNION ALL
    SELECT
        t.title,
        'Show' AS type,
        t.release_year,
        t.score,
        t.number_of_votes,
        g.genre
    FROM best_shows_netflix t
    LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre
) combined
ORDER BY score DESC
LIMIT 10;


-- View Distribuição de Duração por Gênero
CREATE VIEW vw_duration_by_genre AS
SELECT
    g.genre,
    AVG(t.duration) AS avg_duration,
    MAX(t.duration) AS max_duration,
    MIN(t.duration) AS min_duration,
    COUNT(t.title) AS total_titles
FROM (
    SELECT title, main_genre, duration FROM best_movies_netflix
    UNION ALL
    SELECT title, main_genre, duration FROM best_shows_netflix
) t
LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre
GROUP BY g.genre
ORDER BY avg_duration DESC;


-- View Tendências de Lançamentos ao Longo do Tempo
CREATE VIEW vw_trends_over_time AS
SELECT
    release_year,
    type,
    COUNT(title) AS total_titles
FROM (
    SELECT title, release_year, 'Movie' AS type FROM best_movies_netflix
    UNION ALL
    SELECT title, release_year, 'Show' AS type FROM best_shows_netflix
) t
GROUP BY release_year, type
ORDER BY release_year, total_titles DESC;


-- View Comparação de Pontuação e Votos
CREATE VIEW vw_score_votes_analysis AS
SELECT
    title,
    type,
    score,
    number_of_votes,
    genre,
    release_year,
    CASE
        WHEN score >= 8.0 AND number_of_votes < 500 THEN 'Hidden Gem'
        WHEN score < 5.0 AND number_of_votes > 1000 THEN 'Overrated'
        ELSE 'Normal'
    END AS category
FROM (
    SELECT
        t.title,
        'Movie' AS type,
        t.release_year,
        t.score,
        t.number_of_votes,
        g.genre
    FROM best_movies_netflix t
    LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre
    UNION ALL
    SELECT
        t.title,
        'Show' AS type,
        t.release_year,
        t.score,
        t.number_of_votes,
        g.genre
    FROM best_shows_netflix t
    LEFT JOIN dim_genre_netflix g ON t.main_genre = g.genre
) combined
ORDER BY score DESC, number_of_votes DESC;


-- View para Big Numbers
CREATE VIEW vw_big_numbers AS
SELECT
    (SELECT COUNT(*) FROM best_movies_netflix) AS total_movies,
    (SELECT COUNT(*) FROM best_shows_netflix) AS total_shows,
    (SELECT COUNT(DISTINCT release_year) FROM raw_titles) AS total_years,
    (SELECT AVG(imdb_score) FROM raw_titles) AS avg_score,
    (SELECT COUNT(DISTINCT production_countries) FROM raw_titles) AS total_countries,
    (SELECT COUNT(DISTINCT name) FROM raw_credits) AS total_actors