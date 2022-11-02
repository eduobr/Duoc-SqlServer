SELECT * from titles

SELECT COUNT(*) AS "cantidad",type FROM titles GROUP BY type ORDER BY "cantidad" DESC

SELECT REPLACE(title,'e','3') AS "remplazar titulos" FROM titles

SELECT COUNT(pub_id) "cantidad de titulos" AS "",AVG(price) AS "promedio precio" FROM titles GROUP BY pub_id 

SELECT MAX(price) AS "precio maximo",MIN(price) AS "precio Minimo",AVG(price) AS "promedio" FROM titles

SELECT UPPER(title) AS "titulos en minusculas" FROM TITLES WHERE LEN(title)<20

SELECT CONCAT(RIGHT(title,8),CONCAT(SPACE(10),LEFT(notes,8))) AS "concat" FROM TITLES