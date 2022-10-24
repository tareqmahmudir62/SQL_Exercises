                                                                      Questions:
1. we needed to group by the day and channel. Then ordering by the number of events (the third column) gave us a quick way to answer

SELECT DATE_TRUNC ('day',w.occurred_at), w.channel, COUNT(*) channel_count
FROM web_events w
GROUP BY 1,2

2. get a table that shows the average number of events a day for each channel

SELECT channel, AVG (channel_count)
FROM (SELECT DATE_TRUNC ('day',w.occurred_at), w.channel, COUNT(*) channel_count
FROM web_events w
GROUP BY 1,2) events_count_per_day
GROUP BY 1
ORDER BY 2 DESC

3. The average amount of standard paper sold on the first month that any order was placed in the orders table (in terms of quantity).

SELECT DATE_TRUNC ('month', occurred_at), AVG(standard_qty) as avg_standard
FROM (SELECT *
FROM orders
WHERE DATE_TRUNC ('month',occurred_at)=(SELECT DATE_TRUNC ('month', MIN(occurred_at)) first_month
FROM orders)
ORDER BY occurred_at) sub
GROUP BY 1
Order BY 1 ASC;

4. The average amount of gloss paper sold on the first month that any order was placed in the orders table (in terms of quantity).

SELECT DATE_TRUNC ('month', occurred_at), AVG(gloss_qty) as avg_gloss
FROM (SELECT *
FROM orders
WHERE DATE_TRUNC ('month',occurred_at)=(SELECT DATE_TRUNC ('month', MIN(occurred_at)) first_month
FROM orders)
ORDER BY occurred_at) sub
GROUP BY 1
Order BY 1 ASC;

5. The average amount of poster paper sold on the first month that any order was placed in the orders table (in terms of quantity).

SELECT DATE_TRUNC ('month', occurred_at), AVG(poster_qty) as avg_poster
FROM (SELECT *
FROM orders
WHERE DATE_TRUNC ('month',occurred_at)=(SELECT DATE_TRUNC ('month', MIN(occurred_at)) first_month
FROM orders)
ORDER BY occurred_at) sub
GROUP BY 1
Order BY 1 ASC;

6. The total amount spent on all orders on the first month that any order was placed in the orders table (in terms of usd).

SELECT DATE_TRUNC ('month', occurred_at), SUM(total_amt_usd) as total_spent
FROM (SELECT *
FROM orders
WHERE DATE_TRUNC ('month',occurred_at)=(SELECT DATE_TRUNC ('month', MIN(occurred_at)) first_month
FROM orders)
ORDER BY occurred_at) sub
GROUP BY 1
Order BY 1 ASC;

7. What is the top channel used by each account to market products? and How often was that same channel used?

SELECT a.id, a.name, w.channel, COUNT (*)
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
GROUP BY 1,2,3
ORDER BY 1, 4 DESC

8. How do we only return the most used account (or accounts if multiple are tied for the most)?

SELECT name, MAX(count_channel_used) Max_num_used
FROM (SELECT a.id, a.name, w.channel, COUNT (*) count_channel_used
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
GROUP BY 1,2,3
ORDER BY 1, 4 DESC) AS T1
GROUP BY 1


9. So now we have the MAX usage number for a channel for each account. Now we can use this to filter the original table to find channels for each account that match the MAX amount for their account.

SELECT table3.id, table3.name, table3.channel, table3.ct
FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
FROM accounts a
JOIN web_events we
On a.id = we.account_id
GROUP BY a.id, a.name, we.channel) table3
JOIN (SELECT table1.id, table1.name, MAX(ct) max_chan
FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
FROM accounts a
OIN web_events we
ON a.id = we.account_id
GROUP BY a.id, a.name, we.channel) table1
GROUP BY table1.id, table1.name) table2
ON table2.id = table3.id AND table2.max_chan = table3.ct
ORDER BY table3.id;

10. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

SELECT t3.sales_rep, t3.region_name, t3.largest_amount_sold
FROM (SELECT region_name, MAX(largest_amount_sold) largest_amount_sold
FROM (SELECT s.name sales_rep, r.name region_name, SUM(o.total_amt_usd) largest_amount_sold
FROM sales_reps s
JOIN region r
ON r.id=s.region_id
JOIN accounts a
ON s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
) t1
GROUP BY 1) t2
JOIN (SELECT s.name sales_rep, r.name region_name, SUM(o.total_amt_usd) largest_amount_sold
FROM sales_reps s
JOIN region r
ON r.id=s.region_id
JOIN accounts a
ON s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 DESC) t3
ON t3.region_name=t2.region_name AND t3.largest_amount_sold=t2.largest_amount_sold


11. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

SELECT r.name, COUNT(o.total) total_order
FROM orders o
JOIN accounts a
ON a.id=o.account_id
JOIN sales_reps s
ON s.id=a.sales_rep_id
JOIN region r
ON r.id=s.region_id
GROUP BY 1
HAVING SUM(o.total_amt_usd)=(SELECT MAX(max_amount)
FROM (SELECT SUM(o.total_amt_usd) max_amount, r.name region
FROM orders o
JOIN accounts a
ON a.id=o.account_id
JOIN sales_reps s
ON s.id=a.sales_rep_id
JOIN region r
ON r.id=s.region_id
GROUP BY 2
ORDER BY 1 DESC) SUB)

12. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

SELECT COUNT(*)
FROM (SELECT a.name, COUNT(*) account_count
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
HAVING SUM (o.total) > (SELECT total_amt_usd
FROM (SELECT a.id, a.name account, SUM (o.standard_qty) most_std_qty, SUM(o.total) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1) sub)) sub2

13. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

SELECT a.name account, w.channel channel, COUNT(*) count_events
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
AND a.id = (SELECT id
FROM (SELECT a.id, a.name account, SUM(o.total_amt_usd) spent_total
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1) sub)
GROUP BY 1,2
ORDER BY 3 DESC

14. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

SELECT AVG(total_amt_spent)avg_spent
FROM(SELECT a.id, a.name, SUM(o.total_amt_usd) total_amt_spent
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10) t1

15. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders?

SELECT AVG (avg_account_spent) avg_spent_more_than_all_avg
FROM(SELECT a.id, a.name account, AVG (o.total_amt_usd) avg_account_spent
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1, 2
HAVING AVG (o.total_amt_usd) > (SELECT AVG (o.total_amt_usd) avg_all_orders
FROM accounts a
JOIN orders o
ON a.id=o.account_id))t1


16. Find the average number of events for each channel per day

WITH t1 AS
(SELECT DATE_TRUNC('day',occurred_at) when_happened, channel, COUNT(*)
FROM web_events
GROUP BY 1,2)
SELECT channel, AVG(count) avg_count
FROM t1
GROUP BY 1
ORDER BY 2 DESC

                OR

SELECT channel, AVG(count) AVG_number
FROM(
    SELECT DATE_TRUNC('day',occurred_at) when_happened, channel, COUNT(*)
    FROM web_events
    GROUP BY 1,2) t1
    GROUP BY 1
    ORDER BY 2 DESC


17. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

WITH t1 as
(SELECT s.name sales_rep, r.name region, SUM (o.total_amt_usd) total_sold
FROM sales_reps s
JOIN region r
ON r.id=s.region_id
JOIN accounts a
ON s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC),
t2 as
(SELECT region, MAX(total_sold) max_sold
 FROM t1
 GROUP BY 1
 ORDER BY 2 DESC)
SELECT t1.sales_rep, t1.region, t2.max_sold
FROM t1
JOIN t2
on t1. region=t2.region
AND t1.total_sold=t2.max_sold
ORDER BY 3 DESC

18. For the region with the largest sales total_amt_usd, how many total orders were placed?

WITH T1 AS(SELECT r.id region_id, r.name region, SUM (o.total_amt_usd) total_amt_sold
FROM sales_reps s
JOIN region r
ON r.id=s.region_id
JOIN accounts a
ON s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 2 DESC)
SELECT t1.region region_name, COUNT(o.total) total_order
FROM T1
JOIN sales_reps s
ON T1.region_id=s.region_id
JOIN accounts a
ON s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
WHERE t1.region= 'Northeast'
GROUP BY 1

19. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

WITH t1 AS (
SELECT a.name account_name, SUM(o.standard_qty) Total_STD_bought, SUM (o.total) total_bought
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1),
 t2 AS
(SELECT a.name account_name2
FROM accounts a
JOIN orders o
ON a.id=o.account_id
 GROUP BY 1
HAVING SUM(o.total)> (select total_bought from t1))
SELECT COUNT(*)
FROM t2

20. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

WITH t1 AS (SELECT a.id, a.name account_name, SUM(o.total_amt_usd) total_amt_spent
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1)
SELECT t1.account_name, w.channel, count(*)
FROM web_events w
JOIN t1
ON t1.id=w.account_id
GROUP BY 1,2
ORDER BY 3 DESC


21. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

WITH t1 AS(
  SELECT a.name account, SUM (o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10)
SELECT AVG(total_spent) average_amount
FROM t1

22. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

WITH t1 AS (SELECT AVG(total_amt_usd) avg_all_orders
FROM orders),
  t2 AS (SELECT a.name account, AVG(total_amt_usd) avg_amount_orders
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
HAVING AVG(total_amt_usd)> (SELECT avg_all_orders FROM t1)
ORDER BY 2 DESC)
SELECT AVG(avg_amount_orders) average_
FROM t2
