-- SQL mini test 
-- Skills used: Joins, Windows Functions, Aggregate Functions, Converting Data Types, COALESCE

-- Software: PostgreSQL

-- Datasets: subscription_data.csv, business_data.csv and activity_data.csv




-- View the datasets

-- Subscription dataset
SELECT
	*
FROM
	subscription_data;
	
-- Business dataset	
SELECT
	*
FROM
	business_data;	
	
-- Activity dataset
SELECT
	*
FROM
	activity_data;
	
	

-- Task #1: Write a query to get basic and extra subscriptions that started after 2022-05-01.
-- We want their subscription id, start date of the subscription, locale and renewal interval.

SELECT
	subscription_id
	,subscription_start
	,locale
	,renewal_interval
	--,plan_code
FROM
	subscription_data
WHERE
	(subscription_start > '2022-05-01')
	AND
	(plan_code = 'basic'
	OR 
	plan_code = 'extra')
ORDER BY
	subscription_start;
	


-- Task #2: Write a query to get how many live service businesses we have that are not 
-- in the retail category.

SELECT
	COUNT(DISTINCT customer_id) AS live_service_count
FROM
	business_data
WHERE
	service_live = 1
	AND
	business_category <> 'Retail';
	
	
	
-- Task #3: Write a query to get a list of customers who have over 5 messages 
-- since the start of this year.

SELECT
	DISTINCT bd.customer_id AS list_customers
FROM
	activity_data AS ad
JOIN
	business_data AS bd
	ON
	ad.business_id = bd.business_id
WHERE
	ad.messages > 5
	AND
	ad.date >= '2023-01-01';




-- Task #4: The company wants the number of businesses in each category with 
-- at least 20 bookings in a single day. Please write a query to get this.

SELECT
	bd.business_category
	,COUNT(bd.customer_id) AS business_count
FROM
	business_data AS bd
JOIN
	(
	SELECT
		DISTINCT business_id
	FROM
		activity_data
	WHERE
		bookings >= 20
	--ORDER BY
	--	business_id
	) AS ad
	ON
	bd.business_id = ad.business_id
GROUP BY
	bd.business_category;
	
	
	
-- Task #5: Write a query to show the cancellation rate of each plan_code. 

SELECT
	plan_code
	,CAST(COUNT(cancelled_at) AS NUMERIC) / CAST(COUNT(subscription_start) AS NUMERIC) * 100 AS cancellation_rate
FROM
	subscription_data
GROUP BY
	plan_code;
	


-- Task #6: Write a query to get the number of cancelled subscriptions that still have a live service. 

SELECT
	COUNT(cancelled_at) AS live_cancelled_subscriptions_count
FROM
	subscription_data AS sd
JOIN
	business_data AS bd
	ON
	sd.customer_id = bd.customer_id
WHERE
	sd.cancelled_at IS NOT NULL
	AND
	bd.service_live = 1;
	


-- Task #7: For customer_id “abatS”, write a query to get the cumulative number of bookings 
-- they have in each month, starting with the month they started their subscription.
		
SELECT
	sd.subscription_start
	,ad.month							-- I don't know how to add the remaining months to the table
	,ad.bookings AS monthly_count
	,SUM(ad.bookings) 
		OVER (PARTITION BY bd.customer_id ORDER BY ad.month) AS culmulative_bookings
FROM
	subscription_data AS sd
JOIN
	business_data AS bd
	ON
	sd.customer_id = bd.customer_id
JOIN
	(
	SELECT
		business_id
		,DATE_TRUNC('month', date) AS month
		,COALESCE(SUM(bookings), 0) AS bookings
	FROM
		activity_data
	GROUP BY
		business_id
		,month
	) AS ad
	ON
	bd.business_id = ad.business_id
WHERE
	sd.customer_id = 'abatS';
	


-- Task #8: For each business, count the number of days in which they have messages, 
-- the number of days they do not have messages but they have bookings, 
-- and the total number of sales they have received. Group this by business name.

SELECT
	bd.business_name
	,me.day_count_messages
	,bo.day_count_bookings
	,SUM(sales) AS total_sales
FROM
	activity_data AS ad
JOIN
	(
	SELECT
		DISTINCT business_id
		,COUNT(date) AS day_count_messages
	FROM
		activity_data
	WHERE
		messages IS NOT NULL
	GROUP BY
		business_id
	) AS me
	ON
	ad.business_id = me.business_id
JOIN
	(
	SELECT
		DISTINCT business_id
		,COUNT(date) AS day_count_bookings
	FROM
		activity_data
	WHERE
		messages IS NULL
		AND
		bookings IS NOT NULL
	GROUP BY
		business_id
	) AS bo
	ON
	ad.business_id = bo.business_id
JOIN
	business_data AS bd
	ON
	ad.business_id = bd.business_id
GROUP BY
	bd.business_name
	,me.day_count_messages
	,bo.day_count_bookings;
	


-- Task #9: For each business category, count the number of businesses that have 
-- at least 22 messages on a day where they had no sales. 

SELECT
	bd.business_category
	,COUNT(ad.business_id) AS business_count
FROM
	activity_data AS ad
JOIN
	business_data AS bd
	ON
	ad.business_id = bd.business_id
WHERE
	ad.messages >= 22
	AND
	ad.sales IS NULL
GROUP BY
	bd.business_category;