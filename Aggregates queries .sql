-- Swapna Menon TPC003--

/*
Aggregate Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     THEN records returned. 
*/

USE orderbook_activity_db;

-- #1: How many users do we have?
SELECT COUNT(userid) FROM User;
/*
7
Returned 1 row */

-- #2: List the username, userid, and number of orders each user has placed.
SELECT u.uname, u.userid, COUNT(orderId) FROM `User` AS u
JOIN `ORDER` AS o
ON o.userid = u.userid
GROUP BY u.uname = u.userid; 


-- #3: List the username, symbol, and number of orders placed for each user and for each symbol. 
-- Sort results in alphabetical order by symbol.
SELECT u.uname, o.symbol,  COUNT(o.userId) AS `User_Count`, COUNT(o.symbol)
FROM `Order` AS o
JOIN `User` AS u
ON o.orderId = u.userId
GROUP BY u.uname, o.symbol
ORDER BY o.symbol DESC; 

SELECT u.uname, o.symbol, COUNT(*) AS User_Count
FROM `Order` AS o
JOIN `User` AS u ON o.userId = u.userId
GROUP BY u.uname, o.symbol
ORDER BY o.symbol ASC;

/*
'wiley','WLY','1','1'
'sam','GS','1','1'
'robert','GS','1','1'
'kendra','A','1','1'
'james','NFLX','1','1'
'alice','A','1','1'
'admin','WLY','1','1'
7 Rows returned

'alice','A','5'
'james','A','1'
'robert','AAA','1'
'admin','AAPL','1'
'robert','AAPL','1'
'kendra','AAPL','1'
'alice','GOOG','1'
'admin','GS','1'
'kendra','GS','1'
'robert','MSFT','1'
'robert','NFLX','1'
'kendra','QQQ','2'
'kendra','SPY','1'
'alice','SPY','1'
'james','TLT','1'
'alice','TLT','1'
'james','WLY','1'
'robert','WLY','1'
'admin','WLY','1'
19 Rows Returned 
*/


-- #4: Perform the same query as the one above, but only include admin users.
SELECT u.uname, o.symbol, COUNT(*) AS User_Count 
FROM `Order` AS o
JOIN `User` AS u ON o.userId = u.userId
JOIN `UserRoles` AS ur 
ON ur.userId = u.userId
JOIN Role AS r ON r.roleId = ur.roleId 
WHERE r.name = "admin"
GROUP BY u.uname, o.symbol
ORDER BY o.symbol ASC;
/*
'alice','A','5'
'admin','AAPL','1'
'alice','GOOG','1'
'admin','GS','1'
'alice','SPY','1'
'alice','TLT','1'
'admin','WLY','1'
7 Rows Returned */

SELECT u.uname, o.symbol,  COUNT(o.userId) AS `User_Count`, COUNT(o.symbol)
FROM `Order` AS o
JOIN `User` AS u
ON o.userid = u.userid
GROUP BY u.uname, o.symbol
ORDER BY o.symbol DESC;
/*
'admin','WLY','1','1'
'robert','WLY','1','1'
'james','WLY','1','1'
'alice','TLT','1','1'
'james','TLT','1','1'
'alice','SPY','1','1'
'kendra','SPY','1','1'
'kendra','QQQ','2','2'
'robert','NFLX','1','1'
'robert','MSFT','1','1'
'kendra','GS','1','1'
'admin','GS','1','1'
'alice','GOOG','1','1'
'kendra','AAPL','1','1'
'admin','AAPL','1','1'
'robert','AAPL','1','1'
'robert','AAA','1','1'
'james','A','1','1'
'alice','A','5','5'
19 Rows Returned
*/

-- #5: List the username and the average absolute net order amount for each user with an order.
-- Round the result to the nearest hundredth and use an alias (averageTradePrice).
-- Sort the results by averageTradePrice with the largest value at the top.
SELECT u.uname, ROUND(AVG(o.price * o.shares),2) AS average_net_order
FROM User AS u
JOIN  `Order` AS o
ON u.userid = o.userid
WHERE o.orderid  IS NOT NULL 
GROUP BY u.uname
ORDER BY average_net_order DESC;  
/*
'admin','10774.87'
'alice','6000.47'
'james','1187.80'
'robert','536.92'
'kendra','-17109.53'
5 Rows Returned
*/


-- #6: How many shares for each symbol does each user have?
-- Display the username and symbol with number of shares.
SELECT u.uname, o.symbol, COUNT(o.shares) AS number_shares
FROM `Order` AS o 
JOIN `User` AS u 
ON o.userid = u.userid
GROUP BY u.uname, o.symbol;
/*
'admin','WLY','100'
'admin','GS','100'
'admin','AAPL','-15'
'alice','A','18'
'alice','SPY','100'
'alice','TLT','-10'
'alice','GOOG','100'
'james','A','-10'
'james','TLT','10'
'james','WLY','100'
'kendra','GS','-10'
'kendra','AAPL','-10'
'kendra','QQQ','-200'
'kendra','SPY','-75'
'robert','WLY','-10'
'robert','NFLX','-100'
'robert','AAPL','25'
'robert','AAA','10'
'robert','MSFT','100'
19 Rows Returned  */

SELECT u.uname, o.symbol, SUM(o.shares) AS number_shares
FROM `Order` AS o 
JOIN `User` AS u 
ON o.userid = u.userid
GROUP BY u.uname, o.symbol;
/*
'admin','WLY','100'
'admin','GS','100'
'admin','AAPL','-15'
'alice','A','18'
'alice','SPY','100'
'alice','TLT','-10'
'alice','GOOG','100'
'james','A','-10'
'james','TLT','10'
'james','WLY','100'
'kendra','GS','-10'
'kendra','AAPL','-10'
'kendra','QQQ','-200'
'kendra','SPY','-75'
'robert','WLY','-10'
'robert','NFLX','-100'
'robert','AAPL','25'
'robert','AAA','10'
'robert','MSFT','100'
*/


-- #7: What symbols have at least 3 orders?
SELECT COUNT(o.symbol) AS order_count, o.symbol
FROM `Order` AS o
GROUP BY  o.symbol
HAVING order_count >= 3; 
/*
'6','A'
'3','AAPL'
'3','WLY'
3 Rows Returned
*/

-- #8: List all the symbols and absolute net fills that have fills exceeding $100.
-- Do not include the WLY symbol in the results.
-- Sort the results by highest net with the largest value at the top.

SELECT o.symbol, (f.share * f.price) AS net_fill 
FROM `Order` AS o
JOIN Fill AS f 
ON o.orderId = f.orderId 
GROUP BY o.symbol, f.price, f.share 
HAVING NOT o.symbol = 'WLY'
ORDER BY net_fill DESC;
/*
'SPY','27429.75'
'GS','3056.30'
'AAPL','2111.40'
'AAPL','1407.60'
'A','1298.90'
'TLT','989.30'
'TLT','-989.30'
'A','-1298.90'
'AAPL','-1407.60'
'AAPL','-2111.40'
'GS','-3056.30'
'SPY','-27429.75'
12 Rows Returned 
*/


-- #9: List the top five users with the greatest amount of outstanding orders.
-- Display the absolute amount filled, absolute amount ordered, and net outstanding.
-- Sort the results by the net outstanding amount with the largest value at the top.
SELECT u.uname, o.status, o.orderId
FROM `User` AS u
FROM `Order` AS o
ON u.userId = 
GROUP BY o.symbol, f.price, f.share 
HAVING NOT o.symbol = 'WLY'
ORDER BY net_fill DESC;