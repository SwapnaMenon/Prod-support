-- Swapna Menon TPC003-- 
/*
Basic Selects

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: List all users, including username and dateJoined.
SELECT uname, dateJoined
FROM `User`;
/*
ROWS=7
*/

-- #2: List the username and datejoined from users with the newest users at the top.
SELECT uname, dateJoined
FROM User
ORDER BY dateJoined DESC;
/*
ROWS=7
*/

-- #3: List all usernames and dateJoined for users who joined in March 2023.
SELECT uname, dateJoined
FROM User
WHERE dateJoined BETWEEN '2023-03-01' AND '2023-03-31';
/*
ROWS=5
*/

-- #4: List the different role names a user can have.
SELECT name FROM Role;
/*
ROWS=3
*/


-- #5: List all the orders.
SELECT * FROM `Order`;
/*
ROWS=24
*/

-- #6: List all orders in March where the absolute net order amount is greater than 1000.
SELECT * FROM orderbook_activity_db.Order;

SELECT symbol,
	SUM(shares) AS total_shares,
	SUM(shares * price) AS total_amount
FROM `Order`
WHERE MONTH(orderTime) = 3
GROUP BY symbol
HAVING total_amount > 1000;

-- #7: List all the unique status types from orders.
SELECT DISTINCT status FROM `Order`;
/*
ROWS=5
*/

-- #8: List all pending and partial fill orders with oldest orders first.
SELECT * FROM `Order`
WHERE status = 'pending' OR status = 'partial_fill';
/*
ROWS=10
*/


-- #9: List the 10 most expensive financial products where the productType is stock.
-- Filter the results according to the price with the most expensive at the top. 
SELECT  * from Product WHERE productType = 'stock'
ORDER BY price DESC LIMIT 10;
/*
ROWS=10
*/


-- #10: Display orderid, fillid, userid, symbol, and absolute net fill amount
-- from fills where the absolute net fill is greater than $1000.
-- Filter the results with the largest absolute net fill at the top.
SELECT orderid, fillid, userid, symbol,
ABS(SUM(share * price )) AS absolute_net_fill_amount
FROM Fill
GROUP BY orderid, fillid, userid, symbol
HAVING ABS(SUM(share * price)) > 1000
ORDER BY absolute_net_fill_amount DESC;