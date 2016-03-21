declare @t table (k int,m varchar(3),p decimal(10,2),v int)
INSERT @t
	VALUES (1, 'Jan', 0.99, 1000),
	(1, 'Feb', 1, 2000)

;
WITH raw
AS (SELECT
		a.k
		,a.m
		,SUM(CASE
			WHEN a.p < 1 THEN a.v
			ELSE 0
		END) AS notready
		,SUM(CASE
			WHEN a.p = 1 THEN a.v
			ELSE 0
		END) AS ready

	FROM @t a
	GROUP BY	a.k
				,a.m)

------------------------------------------------------
-- oddzielnie dla pewnych i niepewnych
SELECT
	k
	,m
	,notready AS val
	,'notready' AS prob
FROM (SELECT
		a.k
		,a.m
		,SUM(CASE
			WHEN a.p < 1 THEN a.v
			ELSE 0
		END) AS notready
		,SUM(CASE
			WHEN a.p = 1 THEN a.v
			ELSE 0
		END) AS ready

	FROM @t a
	GROUP BY	a.k
				,a.m) x UNION ALL SELECT
	k
	,m
	,ready AS val
	,'ready' AS prob
FROM (SELECT
		a.k
		,a.m
		,SUM(CASE
			WHEN a.p < 1 THEN a.v
			ELSE 0
		END) AS notready
		,SUM(CASE
			WHEN a.p = 1 THEN a.v
			ELSE 0
		END) AS ready

	FROM @t a
	GROUP BY	a.k
				,a.m) y
ORDER BY k, m


------------------------------------------------------
-- najpierw pewne a potem pewne + niepewne (grouping set?)
SELECT
	k
	,m
	,'roh' AS prob
	,roh AS val
FROM (SELECT
		a.k
		,a.m
		,SUM(CASE
			WHEN a.p = 1 THEN a.v
			ELSE 0
		END) AS roh
		,SUM(CASE
			WHEN a.p <= 1 THEN a.v
			ELSE 0
		END) AS outlook

	FROM @t a
	GROUP BY	a.k
				,a.m) x UNION ALL SELECT
	k
	,m
	,'outlook' AS prob
	,outlook AS val
FROM (SELECT
		a.k
		,a.m
		,SUM(CASE
			WHEN a.p = 1 THEN a.v
			ELSE 0
		END) AS roh
		,SUM(CASE
			WHEN a.p <= 1 THEN a.v
			ELSE 0
		END) AS outlook

	FROM @t a
	GROUP BY	a.k
				,a.m) y
ORDER BY k, m