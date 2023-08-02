-- Swapna Menon TPC003 --
/*
Join Queries
REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/
USE orderbook_activity_db;
-- #1: Display the dateJoined and username for admin users.
SELECT dateJoined, uname FROM User
WHERE uname = 'admin';
 /*2023-02-14 13:13:28	admin
 Only 1 row*/
 
-- #2: Display each absolute order net (share*price), status, symbol, trade data, and username.
-- Sort the results with largest the absolute order net (share*price) at the top.
-- Include only orders that were not canceled or partially canceled.
SELECT ABS(shares*price) AS net_order, status, symbol, orderid, userid, side, orderTime
FROM `Order`
WHERE status = "filled" OR status = "pending"
ORDER BY net_order DESC;
/*
27429.75	filled	SPY	14	4	2	2023-03-15 19:24:47
26827.00	pending	QQQ	13	4	2	2023-03-15 19:24:32
26827.00	pending	QQQ	12	4	2	2023-03-15 19:24:32
24315.00	pending	NFLX	3	6	2	2023-03-15 19:21:12
3873.00	pending	WLY	20	3	1	2023-03-15 19:51:06
18 ROWS RETURNED
*/


-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!
SELECT o.orderid, o.symbol, o.status, o.shares, o.price, f.orderid, f.symbol, f.share, f.price
FROM `Order` AS o
JOIN `Fill` AS f ON f.orderid = o.orderid;
/*
2	WLY	filled	-10	38.73
4	A	filled	10	129.89
5	A	filled	-10	129.89
7	GS	filled	-10	305.63
8	AAPL	filled	25	140.76
14 ROWS RETURNED
*/
-- #4: Display all partial_fill orders and how many outstanding shares are left.
-- Also include the username, symbol, and orderid.
SELECT *
FROM `Order`orderTimeOrder
WHERE status = "partial_fill";
/*
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill
11	5	SPY	1	2023-03-15 19:24:21	100	365.73	partial_fill
2 rows returned
*/


-- #5: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Also include the username, role, absolute net filled, and absolute net order.
-- Sort by the absolute net order with the largest value at the top.
SELECT o.orderid, o.symbol, o.status, o.shares, f.share, f.price, ABS(o.shares*o.price)
FROM `Order` AS o
JOIN `Fill` AS f ON f.orderid = o.orderid;
SELECT
    o.orderid,
    o.symbol,
    o.status,
    o.shares AS order_shares,
    f.share AS filled_shares,
    o.price,
    ABS(o.shares*o.price) AS net_price
FROM
    `Order` AS o
INNER JOIN
    `Fill` AS f ON o.orderid = f.orderid
WHERE
    o.status = 'filled';
    /*
2	WLY	filled	-10	10	38.73	387.30
4	A	filled	10	-10	129.89	1298.90
5	A	filled	-10	10	129.89	1298.90
7	GS	filled	-10	10	305.63	3056.30
8	AAPL	filled	25	-10	140.76	3519.00
11 ROWS RETURNED
    */
    
    
-- #6: Display the username and user role for users who have not placed an order.
SELECT u.uname, r.name AS role_name
FROM User AS u
LEFT JOIN `Order` AS o ON o.userid = u.userid
JOIN UserRoles AS ur ON u.userid = ur.userid
JOIN Role AS r ON ur.roleid = r.roleid
WHERE o.userid IS NULL;
/*
sam	user
wiley	admin
2 ROWS RETURNED
*/

#7: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.
SELECT o.orderid, u.uname, r.name AS role, o.symbol, o.price, COUNT(o.shares) AS num_of_shares
FROM `Order` AS o
JOIN `User` AS u ON o.userid = u.userid
JOIN UserRoles AS  ur  ON u.userid = ur.userid
JOIN `Role` AS r  ON ur.roleid = r.roleid
LEFT JOIN Fill AS f ON f.orderid = o.orderid
WHERE NOT o.status = "filled"
GROUP BY o.orderid, u.uname, r.name; 
/*
1	admin	admin	WLY	38.73	1
6	admin	admin	GS	305.63	1
11	alice	admin	SPY	365.73	1
19	alice	admin	GOOG	100.82	1
21	alice	admin	A	129.89	1
14 rows returned
*/


#8: Display the symbol, username, role, and number of filled shares where the order symbol is WLY.
-- Include all orders, even if the order has no fills.
SELECT o.symbol, u.uname, r.name AS role_name, COUNT(o.shares)
FROM `Order` AS o
JOIN `User` AS u ON o.userid = u.userid
JOIN UserRoles AS  ur  ON u.userid = ur.userid
JOIN `Role` AS r  ON ur.roleid = r.roleid
WHERE o.symbol = "WLY" AND NOT o.status = "filled"
GROUP BY o.orderid, u.uname, r.name;
/*
WLY	admin	admin	1
WLY	james	user	1
2 Rows Returned
*/


