---------------------------------------------------------------------
-- TK 70-461 - Chapter 03 - Filtering and Sorting Data
-- Exercises
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Lesson 01 - Filtering Data with Predicates
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Practice - Filtering Data with Predicates
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Exercise 1: Use the WHERE Clause to Filter Rows with NULLs
---------------------------------------------------------------------

-- 2.

USE TSQL2012;
GO


SELECT
	orderid
	,orderdate
	,custid
	,empid
FROM Sales.Orders
WHERE shippeddate = NULL;

-- 3.

SELECT
	orderid
	,orderdate
	,custid
	,empid
FROM Sales.Orders
WHERE shippeddate IS NULL;

---------------------------------------------------------------------
-- Exercise 2: Use the WHERE Clause to Filter a Range of Dates
---------------------------------------------------------------------

-- 1.

SELECT
	orderid
	,orderdate
	,custid
	,empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20080211' AND '20080212 23:59:59.999';

-- 2.

SELECT
	orderid
	,orderdate
	,custid
	,empid
FROM Sales.Orders
WHERE orderdate >= '20080211'
AND orderdate < '20080213';

---------------------------------------------------------------------
-- Lesson 02 - Sorting Data
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Practice - Sorting Data
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Exercise 1: Use the ORDER BY Clause with Nondeterministic Ordering
---------------------------------------------------------------------

-- 2.

SELECT
	orderid
	,empid
	,shipperid
	,shippeddate
FROM Sales.Orders
WHERE custid = 77;

-- 3.

SELECT
	orderid
	,empid
	,shipperid
	,shippeddate
FROM Sales.Orders
WHERE custid = 77
ORDER BY shipperid;

---------------------------------------------------------------------
-- Exercise 2: Use the ORDER BY Clause with Deterministic Ordering
---------------------------------------------------------------------

-- 1.

SELECT
	orderid
	,empid
	,shipperid
	,shippeddate
FROM Sales.Orders
WHERE custid = 77
ORDER BY shipperid, shippeddate DESC;

-- 2.

SELECT
	orderid
	,empid
	,shipperid
	,shippeddate
FROM Sales.Orders
WHERE custid = 77
ORDER BY shipperid, shippeddate DESC, orderid DESC;

---------------------------------------------------------------------
-- Lesson 03 - Filtering Data with TOP and OFFSET-FETCH
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Practice - Filtering Data with TOP and OFFSET-FETCH
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Exercise 1 - Using the TOP Option
---------------------------------------------------------------------

-- 2.
-- five most expensive products
SELECT TOP (5)
	productid
	,unitprice
FROM Production.Products
WHERE categoryid = 1
ORDER BY unitprice DESC;

-- 3.
-- five most expensive products, with ties
SELECT TOP (5) WITH TIES
	productid
	,unitprice
FROM Production.Products
WHERE categoryid = 1
ORDER BY unitprice DESC;

-- 4.
-- five most expensive products, breaking ties
SELECT TOP (5)
	productid
	,unitprice
FROM Production.Products
WHERE categoryid = 1
ORDER BY unitprice DESC, productid DESC;

---------------------------------------------------------------------
-- Exercise 2 - Using the OFFSET-FETCH Option
---------------------------------------------------------------------

-- five products at a time, sorted by unitprice, productid

-- 2.
-- first 5 rows
SELECT
	productid
	,categoryid
	,unitprice
FROM Production.Products
ORDER BY unitprice, productid
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

-- 3.
-- rows 6 through 10
SELECT
	productid
	,categoryid
	,unitprice
FROM Production.Products
ORDER BY unitprice, productid
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- 4.
-- rows 11 through 15
SELECT
	productid
	,categoryid
	,unitprice
FROM Production.Products
ORDER BY unitprice, productid
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;


-- top 3 od klienta po wartosci zamowienia:

;with OrdersTotals(custid,orderid,ordertotal) as(
select
	o.custid
	,o.orderid
	,sum(od.qty * od.unitprice)
FROM Sales.Orders o
JOIN Sales.OrderDetails od
	ON o.orderid = od.orderid
GROUP by o.custid,o.orderid
)

SELECT TOP 1 WITH TIES
	custid
	,orderid
	,ordertotal
FROM OrdersTotals
ORDER BY CASE
	WHEN ROW_NUMBER() OVER (PARTITION BY custid ORDER BY ordertotal DESC) <= 2 THEN 0
	ELSE 1
END;


select orderid from Sales.Orders order by orderid OFFSET 2 ROWS


select orderid from Sales.Orders order by orderid fetch next 2 rows
