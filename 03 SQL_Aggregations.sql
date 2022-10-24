                                                                      Questions:
1. Find the total amount of poster_qty paper ordered in the orders table.

SELECT SUM (poster_qty) as total_poster
FROM orders;

2. Find the total amount of standard_qty paper ordered in the orders table.

SELECT SUM (standard_qty ) as total_standard
FROM orders;

3. Find the total dollar amount of sales using the total_amt_usd in the orders table.

SELECT SUM (total_amt_usd) as total_amount_USD
FROM orders;

4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.

SELECT standard_amt_usd+gloss_amt_usd as Total_standard_gloss_each_order_USD
FROM orders

5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both aggregation and a mathematical operator.

SELECT SUM (standard_amt_usd)/SUM (standard_qty ) AS standard_qty_per_unit_USD
FROM orders;

6. When was the earliest order ever placed? You only need to return the date.

SELECT MIN (occurred_at)
FROM orders

7. Try performing the same query as in question 1 without using an aggregation function.

SELECT occurred_at
FROM orders
ORDER BY occurred_at ASC
LIMIT 1;

8. When did the most recent (latest) web_event occur?

SELECT MAX (occurred_at)
FROM web_events

9. Try to perform the result of the previous query without using an aggregation function.

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

10. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT AVG (standard_amt_usd) AS AVG_standard_USD,
AVG(gloss_amt_usd) AS AVG_gloss_USD, AVG(poster_amt_usd) AS AVG_poster_USD, AVG(standard_qty) AS AVG_standard_amount, AVG(GLOSS_qty) AS AVG_sGLOSS_amount,
AVG(poster_qty) AS AVG_poster_amount
FROM orders

11. You might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?

SELECT *
FROM (SELECT total_amt_usd
   FROM orders
   ORDER BY total_amt_usd
   LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

12. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

SELECT a.name, o.occurred_at as Date_ordered
FROM accounts a
JOIN orders o
ON a.id=o.account_id
ORDER BY occurred_at ASC
limit 1;

12. Find the total sales in usd for each account. You should include two columns - the total sales for each companys orders in usd and the company name.

SELECT a.id, SUM (o.total_amt_usd ) AS Total_sales
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.id
ORDER BY a.id ASC;

13. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.

SELECT a.name, w.channel, w.occurred_at as date
FROM web_events w
JOIN accounts a
ON a.id=w.account_id
ORDER BY occurred_at DESC
LIMIT 1;

14. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.

SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel

15. Who was the primary contact associated with the earliest web_event?

SELECT a.primary_poc primary_contact, w.occurred_at date
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
ORDER BY w.occurred_at ASC
limit 1;

16. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name,MIN(o.total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY a.name
ORDER BY smallest_order

17. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from the fewest reps to most reps.

SELECT r.name AS region, count(s.region_id) AS number
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY number

18. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

SELECT a.name account_name, AVG(o.standard_qty) AS standard_number, AVG(o.gloss_qty) AS gloss_qty_number,AVG(o.poster_qty) AS poster_number
FROM orders o
JOIN accounts a
ON a.id=o.account_id
GROUP BY a.name;

19. For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT a.name, AVG(o.standard_amt_usd) avg_stand, AVG(o.gloss_amt_usd) avg_gloss, AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

20. Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT s.name name_sales_rep, w.channel Name_of_Channel, count(*) channel_used_number
FROM sales_reps s
JOIN accounts a
ON s.id= a.sales_rep_id
JOIN web_events w
ON a.id= w.account_id
GROUP BY s.name, w.channel
ORDER BY channel_used_number DESC;

21. Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT r.name region_name, w.channel name_channel, count(*) number_used
FROM region r
JOIN sales_reps s
ON r.id=s.region_id
JOIN accounts a
ON a.sales_rep_id=s.id
JOIN web_events w
ON a.id=w.account_id
GROUP BY r.name,w.channel
ORDER BY 3 DESC;

22. Use DISTINCT to test if there are any accounts associated with more than one region.

SELECT DISTINCT id, name
FROM accounts;

23. Have any sales reps worked on more than one account?

SELECT s.id, s.name sale_reps, count(*) number_account
FROM accounts a
JOIN sales_reps s
ON s.id=a.sales_rep_id
Group By s.id, s.name
order by number_account

23. How many of the sales reps have more than 5 accounts that they manage?

SELECT s.id, s.name, COUNT(*) number_account
FROM accounts a
JOIN sales_reps s
ON s.id=a.sales_rep_id
GROUP BY 1, 2
HAVING COUNT(*) >5
ORDER BY 3 DESC

24. How many accounts have more than 20 orders?

SELECT a.id, a.name account_name, COUNT(*)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
HAVING COUNT(*) >20
ORDER BY 3 desc

25. Which account has the most orders?

SELECT a.id, a.name account_name, COUNT(*)
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 desc
LIMIT 1;

26. Which accounts spent more than 30,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) as total
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY 3 desc;

27. Which accounts spent less than 1,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) as total
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
HAVING SUM(o.total_amt_usd) <1000
ORDER BY 3 desc;

28. Which account has spent the most with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) as total
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 desc
LIMIT 1;

29. Which account has spent the least with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) as total
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1,2
ORDER BY 3 ASC
LIMIT 1;

30. Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.id,a.name, w.channel, count(*) number_of_times
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
WHERE w.channel= 'facebook'
GROUP BY 1,2,3
HAVING count(*) > 6
ORDER BY 4 DESC;

31. Which account used facebook most as a channel?

SELECT a.id,a.name, w.channel, COUNT(*) channel_used_number
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
WHERE w.channel= 'facebook'
GROUP BY 1,2,3
ORDER BY 4 desc
Limit 1;

32. Which channel was most frequently used by most accounts?

SELECT a.id, a.name, w.channel channel_name, COUNT(*) channel_used_number
FROM accounts a
JOIN web_events w
ON a.id=w.account_id
GROUP BY 1,2,3
ORDER BY 4 desc

33. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

SELECT DATE_PART ('year', occurred_at), SUM(total_amt_usd) toal_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC

34. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

SELECT DATE_PART ('month', occurred_at), SUM(total_amt_usd) toal_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

35. Which year did Parch & Posey have the greatest sales in terms of the total number of orders? Are all years evenly represented by the dataset?

SELECT DATE_PART ('year', occurred_at), count(*)
FROM orders
GROUP BY 1
ORDER BY 2 DESC

36. Which month did Parch & Posey have the greatest sales in terms of the total number of orders? Are all months evenly represented by the dataset?

SELECT DATE_PART ('month', occurred_at) month_ordered, count(*) total_order
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

37. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_TRUNC('month', o.occurred_at) took_place, SUM(o.gloss_amt_usd) money_spent_gloss
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

38. Write a query to display for each order, the account ID, the total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

SELECT a.id, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, case when o.total >= 3000 THEN 'large' WHEN o.total < 3000 THEN 'small' END AS category_order
from accounts a
join orders o
on a.id=o.account_id
ORDER BY 5 DESC


39. Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

40. We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top-level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT a.name account_name, SUM(total_amt_usd ) total_sales, CASE  WHEN SUM(total_amt_usd ) >200000 THEN 'top-level'
WHEN SUM(total_amt_usd ) BETWEEN 200000 AND 100000 THEN 'second-level' ELSE 'under 100000' END AS sales_category
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
ORDER BY 2 desc

41. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT a.name account_name, SUM(total_amt_usd ) total_sales, CASE  WHEN SUM(total_amt_usd ) >200000 THEN 'top-level'
WHEN SUM(total_amt_usd ) BETWEEN 200000 AND 100000 THEN 'second-level' ELSE 'under 100000' END AS sales_category
FROM accounts a
JOIN orders o
ON a.id=o.account_id
WHERE o.occurred_at> '2015-12-31'
GROUP BY 1
order by 2 desc

42. We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top salespeople first in your final table.

select s.name sales_rep, COUNT (*) total_COUNT, CASE WHEN COUNT (*) >200 THEN 'top' ELSE 'NOT' END as sales_category
from accounts a
join sales_reps s
on s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
ORDER BY 2 DESC

43. The previous didnt account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on these criteria. Place the top salespeople based on the dollar amount of sales first in your final table. You might see a few upset salespeople by this criteria!

select s.name sales_rep, COUNT (*) total_COUNT, SUM (o.total_amt_usd), CASE WHEN COUNT (*) >200 and SUM (o.total_amt_usd)>750000 THEN 'top' WHEN COUNT (*) >100 and SUM (o.total_amt_usd)>500000 THEN 'middle' ELSE 'NOT' END as sales_category
from accounts a
join sales_reps s
on s.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY 1
ORDER BY 2 DESC
