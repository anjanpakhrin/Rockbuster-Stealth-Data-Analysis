WITH
top_10_countries AS (
	SELECT E.country
	FROM customer B
	INNER JOIN address C ON B.address_id = C.address_id
	INNER JOIN city D ON C.city_id = D.city_id
	INNER JOIN country E on D.country_id = E.country_id
	GROUP BY E.country
	ORDER BY COUNT(B.customer_id) DESC
	LIMIT 10
),
top_10_cities AS (
	SELECT D.city, E.country
	FROM customer B
	INNER JOIN address C ON B.address_id = C.address_id
	INNER JOIN city D ON C.city_id = D.city_id
	INNER JOIN country E ON D.country_id = E.country_id
	INNER JOIN top_10_countries top10con ON E.country = top10con.country
	GROUP BY E.country, D.city
	ORDER BY COUNT(B.customer_id) DESC
	LIMIT 10
),
top_5_customers AS (
	SELECT A.customer_id, B.first_name, B.last_name, E.country, D.city,
	SUM(A.amount) AS total_amount
	FROM payment A
	INNER JOIN customer B ON A.customer_id = B.customer_id
	INNER JOIN address C on B.address_id = C.address_id
	INNER JOIN city D ON C.city_id = D.city_id
	INNER JOIN country E on D.country_id = E.country_id
	INNER JOIN top_10_cities top10cit ON D.city = top10cit.city AND E.country = top10cit.country
	GROUP BY A.customer_id, B.first_name, B.last_name, E.country, D.city
	ORDER BY total_amount DESC
	LIMIT 5
)
SELECT AVG (top_5_customers.total_amount) AS average
FROM top_5_customers;