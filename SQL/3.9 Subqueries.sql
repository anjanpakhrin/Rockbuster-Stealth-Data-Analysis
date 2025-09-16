-- Top 5 customers withinh each country
WITH
top_10_countries AS ( 								-- top 10 countries CTE
	SELECT E.country
	FROM customer AS B
	INNER JOIN address AS C ON B.address_id = C.address_id
	INNER JOIN city AS D ON C.city_id = D.city_id
	INNER JOIN country AS E ON D.country_id = E.country_id
	GROUP BY E.country
	ORDER BY COUNT(B.customer_id) DESC
LIMIT 10),
top_10_cities AS ( 									-- top 10 cities CTE
	SELECT D.city, E.country
	FROM customer AS B
	INNER JOIN address AS C ON B.address_id = C.address_id
	INNER JOIN city AS D ON C.city_id = D.city_id
	INNER JOIN country AS E ON D.country_id = E.country_id
	INNER JOIN top_10_countries top10con ON E.country = top10con.country
	GROUP BY E.country, D.city
	ORDER BY COUNT(B.customer_id) DESC
	LIMIT 10),
top_5_customers AS ( 								-- top 10 customers CTE
	SELECT A.customer_id, B.first_name, B.last_name, E.country, D.city,
	SUM(A.amount) AS total_amount
	FROM payment AS A
	INNER JOIN customer AS B ON A.customer_id = B.customer_id
	INNER JOIN address AS C on B.address_id = C.address_id
	INNER JOIN city AS D ON C.city_id = D.city_id
	INNER JOIN country AS E on D.country_id = E.country_id
	INNER JOIN top_10_cities top10cit ON D.city = top10cit.city AND E.country = top10cit.country
	GROUP BY A.customer_id, B.first_name, B.last_name, E.country, D.city
	ORDER BY total_amount DESC
	LIMIT 5)
SELECT E.country, 									-- recreating table-chain customer -->country
		COUNT(DISTINCT B.customer_id) AS all_customer_count,
		COUNT(DISTINCT top_5_customers.customer_id) AS top_customer_count
FROM customer B
INNER JOIN address AS C ON B.address_id = C.address_id
INNER JOIN city AS D ON C.city_id = D.city_id
INNER JOIN country AS E ON D.country_id = E.country_id
LEFT JOIN top_5_customers ON E.country = top_5_customers.country
GROUP BY 1
ORDER BY top_customer_count DESC,
		all_customer_count DESC
LIMIT 5;