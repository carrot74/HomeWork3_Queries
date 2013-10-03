--1.)Same question on homework 2
SELECT 
	agents.city
FROM
	public.agents
WHERE
	 agents.aid in (
		SELECT
			orders.aid
		FROM 
			public.orders
		WHERE
			orders.cid = 'c002')
--2.)Same as question 1 with joins instead of subqueries
SELECT agents.city
FROM agents, orders
WHERE orders.cid = 'c002'
	and orders.aid = agents.aid
--3.)Question on HW2 
SELECT distinct
	orders.pid
FROM
	public.orders
WHERE
	orders.aid in (
	SELECT
		orders.aid--gets the aid of any agent that made a order to kyoto 
	FROM
		public.orders
	WHERE
		orders.cid in (
		SELECT --Gets the CID of customers in city Kyoto
			customers.cid
		FROM
			public.customers
		WHERE
			customers.city = 'Kyoto'))
--4.)Do it with joins


-- 5.)Get names of customer never placed an order with joins
SELECT customers.name
FROM customers, orders
WHERE customers.cid not in(
	SELECT orders.cid
	FROM orders)	
-- 6.)Do it with outer join
--NAME of customer who never places an order
SELECT distinct c.name
FROM customers c 
      left outer join orders o 
	on o.cid = c.cid
WHERE o.cid is null 
--7.) Get names of customers who placed at least 1 order through agent in their city
-- NAMES of customer that placed 1 order where customer.city = agents.city and the agent names
SELECT distinct c.name, a.name
FROM customers c,agents a, orders o
WHERE c.cid = o.cid
	and o.aid=a.aid
	and c.city = a.city
8.)--C.name and a.name where c.city =a.city and the name of city regardess whether
--or not customer has placed an order
SELECT distinct c.name, a.name, c.city
FROM customers c, agents a
WHERE c.city=a.city

9.)--c.name and c.city of customers that live in city with least number of products made.
DROP VIEW IF EXISTS count;
CREATE VIEW count AS 
		(SELECT p.city as city, count(p.city) as Num
		FROM products p
		GROUP BY p.city);

SELECT distinct c.name, count.city, count.num
FROM customers c, products p, count
WHERE c.city = count.city
GROUP BY c.name, count.city, count.num
HAVING MIN(count.num) = (SELECT MIN(Count.num)
			  FROM count
				)
10.)--c.name and c.city of customers in *A* city with most # of products made
DROP VIEW IF EXISTS count;
CREATE VIEW count AS 
		(SELECT p.city as city, count(p.city) as Num
		FROM products p
		GROUP BY p.city);

SELECT distinct c.name, count.city, count.num
FROM customers c, products p, count
WHERE c.city = count.city
GROUP BY c.name, count.city, count.num
HAVING MAX(count.num) = (SELECT MAX(Count.num)
			  FROM count
				)
11.)-- c.name, c.city of customers live in any city where the most # of products are made
DROP VIEW IF EXISTS count;
CREATE VIEW count AS 
		(SELECT p.city as city, count(p.city) as Num
		FROM products p
		GROUP BY p.city
		ORDER BY num desc);

SELECT distinct c.name, count.city, count.num
FROM customers c, products p, count
WHERE c.city = count.city
GROUP BY c.name, count.city, count.num
HAVING MAX(count.num) in (SELECT MAX(Count.num)
			  FROM count
			)
12.)--products priceUSD> avg(priceUSD)
select p.pid,avg(priceUSD)
from products p
group by p.pid
having avg(priceUSD)> (Select avg(priceUSD)
			from products)
order by pid asc
13.)--show c.name, pid, o.dollars for all customer orders,
-- sorted by dollars from high to low
SELECT o.ordno,c.name, o.pid, o.dollars
FROM customers c,orders o
WHERE c.cid = o.cid
GROUP BY o.ordno ,o.pid, c.cid
ORDER BY avg(o.dollars)
14.) --show c.name(in order) and their total order. USE COALESCE avoid showing null
SELECT c.cid ,c.name, COALESCE(SUM(o.dollars),0) as Total
FROM customers c left outer join orders o on c.cid = o.cid
GROUP BY c.cid, c.name
15.)--show c.name from agents when a.city =New York and the 
--names of products they ordered and the agent names
--show c.name from agents when a.city =New York and the names 
--of products they ordered and the agent names
SELECT distinct c.name, a.name, p.name
FROM customers c, orders o, agents a, products p
WHERE a.city = 'New York'
	and c.cid = o.cid
	and p.pid=o.pid
--16.) calculate o.dollars from products and orders
SELECT distinct c.name , o.qty, p.priceusd, c.discount, o.dollars, o.ordno
FROM orders o, products p, customers c
					
WHERE c.cid = o.cid
	and p.pid= o.pid
	and dollars = (o.qty *p.priceUSD) *(1 - c.discount/100)
	
ORDER BY o.ordno asc
--CODE BELOW DISPLAYS THE CALCULATED DOLLAR AMOUNT(INCORRECTLY FOR SOME REASON)
SELECT distinct c.name , o.qty, p.priceusd, c.discount, o.dollars, o.ordno, DollarsCheck
FROM orders o, products p, customers c, (SELECT (o.qty *p.priceUSD) *(1 - c.discount/100) as 
					FROM orders o, products p, customers c) as DollarsCheck 
					
WHERE c.cid = o.cid
	and p.pid= o.pid
	and dollars = (o.qty *p.priceUSD) *(1 - c.discount/100)
	
ORDER BY o.ordno asc
--17. create an error in the dollars column of the orders table
-- so that you can verify your accuracy checking query
