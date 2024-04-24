-- Mostrando a tabela

SELECT * FROM maquinas;

-- Quantidade limitada de linhas no resultadoda query

SELECT * FROM maquinas
LIMIT 10;

-- Montante de quantidades que cada maquina produziu

SELECT nome, SUM(quantidade) AS TOTAL 
FROM maquinas
WHERE nome IN ('Maquina 01', 'Maquina 02', 'Maquina 03')
GROUP BY nome

-- Montante e média de cada maquina

SELECT nome, SUM(quantidade) AS TOTAL, ROUND(AVG(quantidade),2) AS media
FROM maquinas
WHERE nome IN ('Maquina 01', 'Maquina 02', 'Maquina 03')
GROUP BY nome


-- ordenado pela média ASCENDENTE

SELECT nome, SUM(quantidade) AS TOTAL, ROUND(AVG(quantidade),2) AS media
FROM maquinas
WHERE nome IN ('Maquina 01', 'Maquina 02', 'Maquina 03')
GROUP BY nome
ORDER BY "media" ASC;

-- ordenado pela média DESCENDENTE

SELECT nome, SUM(quantidade) AS TOTAL, ROUND(AVG(quantidade),2) AS media
FROM maquinas
WHERE nome IN ('Maquina 01', 'Maquina 02', 'Maquina 03')
GROUP BY nome
ORDER BY media DESC;

-- Calculando a moda

SELECT nome, MODE() WITHIN GROUP(ORDER BY quantidade) AS MODA
FROM maquinas
GROUP BY nome;

-- Calculando a amplitude

SELECT nome,
	MAX(quantidade) AS maximo,
	MIN(quantidade) AS minimo,
	MAX(quantidade) - MIN(quantidade) AS amplitude
	FROM maquinas
	GROUP BY nome
	ORDER BY 1 DESC;
	
-- média, desvio padrão e variância

SELECT nome,
	ROUND(AVG(quantidade),2) AS media,
	MAX(quantidade) AS maximo,
	MIN(quantidade) AS minimo,
	MAX(quantidade) - MIN(quantidade) AS amplitude,
	ROUND(STDDEV_POP(quantidade),2) AS desvpad,
	ROUND(VAR_POP(quantidade),2) AS variancia
	FROM maquinas
	GROUP BY nome
	ORDER BY 4 DESC;
	
-- Calculando a mediana

CREATE OR REPLACE FUNCTION _final_median(NUMERIC[])
   RETURNS NUMERIC AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;
										 
CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

SELECT MEDIAN(quantidade) AS MEDIANA
FROM maquinas;

SELECT nome, ROUND(MEDIAN(quantidade),2) AS MEDIANA
FROM maquinas
WHERE nome IN ('Maquina 01', 'Maquina 02', 'Maquina 03')
GROUP BY nome;

-- todas juntas numa query só.

SELECT nome,
	COUNT(quantidade) AS QTD,
	SUM(quantidade) AS TOTAL,
	ROUND(AVG(quantidade),2) AS MEDIA,
	MAX(quantidade) - MIN(quantidade) AS AMPLITUDE_TOTAL,
	ROUND(VAR_POP(quantidade),2) AS VARIANCIA,
	ROUND(STDDEV_POP(quantidade),2) AS DESVIO_PADRAO,
	ROUND(MEDIAN(quantidade),2) AS MEDIANA,
	ROUND((STDDEV_POP(quantidade) / AVG(quantidade)) * 100,2) AS COEF_VAR,
	MODE() WITHIN GROUP(ORDER BY quantidade) AS MODA
	   FROM maquinas
	   GROUP BY nome
	   ORDER BY 1;

-- alguns inserts a mais

INSERT INTO MAQUINAS VALUES('Maquina 01',11,15.9);
INSERT INTO MAQUINAS VALUES('Maquina 02',11,15.4);
INSERT INTO MAQUINAS VALUES('Maquina 03',11,15.7);
INSERT INTO MAQUINAS VALUES('Maquina 01',12,30);
INSERT INTO MAQUINAS VALUES('Maquina 02',12,24);
INSERT INTO MAQUINAS VALUES('Maquina 03',12,45);


