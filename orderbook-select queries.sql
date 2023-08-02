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
'admin', '2023-02-14 13:13:28'
'wiley', '2023-04-01 13:13:28'
'james', '2023-03-15 19:15:48'
'kendra', '2023-03-15 19:16:06'
'alice', '2023-03-15 19:16:21'

ROWS=7
*/

-- #2: List the username and datejoined from users with the newest users at the top.
SELECT uname, dateJoined
FROM User
ORDER BY dateJoined DESC;
/*
wiley	2023-04-01 13:13:28
sam	    2023-03-15 19:16:59
robert	2023-03-15 19:16:43
alice	2023-03-15 19:16:21
kendra	2023-03-15 19:16:06

ROWS=7
*/

-- #3: List all usernames and dateJoined for users who joined in March 2023.
SELECT uname, dateJoined
FROM User
WHERE dateJoined BETWEEN '2023-03-01' AND '2023-03-31';
/*
james	2023-03-15 19:15:48
kendra	2023-03-15 19:16:06
alice	2023-03-15 19:16:21
robert	2023-03-15 19:16:43
sam	2023-03-15 19:16:59

ROWS=5
*/

-- #4: List the different role names a user can have.
SELECT name FROM Role;
/*
admin
it
user

ROWS=3
*/


-- #5: List all the orders.
SELECT * FROM `Order`;
/*
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill
2	6	WLY	2	2023-03-15 19:20:50	-10	38.73	filled
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
4	5	A	1	2023-03-15 19:21:31	10	129.89	filled
5	3	A	2	2023-03-15 19:21:39	-10	129.89	filled

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
/*
A	8	1039.12
GOOG	100	10082.00
GS	90	27506.70
MSFT	100	23627.00
SPY	25	9143.25

ROWS = 6
*/

-- #7: List all the unique status types from orders.
SELECT DISTINCT status FROM `Order`;
/*
A	8	1039.12
GOOG	100	10082.00
GS	90	27506.70
MSFT	100	23627.00
SPY	25	9143.25

ROWS = 6
*/



-- #8: List all pending and partial fill orders with oldest orders first.
SELECT * FROM `Order`
WHERE status = 'pending' OR status = 'partial_fill';
/*
1	1	WLY	    1	2023-03-15 19:20:35	100	    38.73	partial_fill
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
11	5	SPY	    1	2023-03-15 19:24:21	100	    365.73	partial_fill
12	4	QQQ	    2	2023-03-15 19:24:32	-100	268.27	pending
13	4	QQQ	    2	2023-03-15 19:24:32	-100	268.27	pending

ROWS=10
*/


-- #9: List the 10 most expensive financial products where the productType is stock.
-- Filter the results according to the price with the most expensive at the top. 
SELECT  * from Product WHERE productType = 'stock'
ORDER BY price DESC LIMIT 10;
/*
207940.KS	830000.00	stock	Samsung Biologics Co.,Ltd.	2022-10-17 15:24:51
003240.KS	715000.00	stock	Taekwang Industrial Co., Ltd.	2022-10-17 15:24:51
000670.KS	630000.00	stock	Young Poong Corporation	2022-10-17 15:24:51
010130.KS	616000.00	stock	Korea Zinc Company, Ltd.	2022-10-17 15:24:51
006400.KS	605000.00	stock	Samsung SDI Co., Ltd.	2022-10-17 15:24:51

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
/*
11	11	5	SPY	27429.75
14	12	4	SPY	27429.75
6	5	1	GS	3056.30
7	6	4	GS	3056.30
8	9	6	AAPL	2111.40

ROWS=10
*/
