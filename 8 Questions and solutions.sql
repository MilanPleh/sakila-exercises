-- Q1: Write a query to find the full name of the actor who has acted in the maximum number of movies.
SELECT 
    CONCAT(first_name, ' ', last_name) AS FullName
FROM
    actor AS a
        INNER JOIN
    film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY fa.actor_id
ORDER BY COUNT(fa.actor_id) DESC
LIMIT 1;

-- Q2: Write a query to find the full name of the actor who has acted in the third most number of movies.
SELECT 
    CONCAT(first_name, ' ', last_name) AS FullName
FROM
    actor AS a
        INNER JOIN
    film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY FullName
ORDER BY COUNT(film_id) DESC
LIMIT 2 , 1;

-- Q3: Write a query to find the film which grossed the highest revenue for the video renting organisation.
SELECT 
    Title
FROM
    film
        INNER JOIN
    inventory USING (film_id)
        INNER JOIN
    rental USING (inventory_id)
        INNER JOIN
    payment USING (rental_id)
GROUP BY title
ORDER BY SUM(amount) DESC
LIMIT 1;

-- Q4: Write a query to find the city which generated the maximum revenue for the organisation. 
SELECT 
    city
FROM
    city
        INNER JOIN
    address USING (city_id)
        INNER JOIN
    customer USING (address_id)
        INNER JOIN
    payment USING (customer_id)
GROUP BY city
ORDER BY SUM(amount) DESC
LIMIT 1;

-- Q5: Write a query to find out how many times a particular movie category is rented. Arrange these categories in the decreasing order of the number of times they are rented.
SELECT 
    c.name, COUNT(DISTINCT rental_id) AS TimesRented
FROM
    category AS c
        INNER JOIN
    film_category AS fc USING (category_id)
        INNER JOIN
    inventory AS i USING (film_id)
        INNER JOIN
    rental USING (inventory_id)
GROUP BY name
ORDER BY TimesRented DESC;

-- Q6: Write a query to find the full names of customers who have rented sci-fi movies more than 2 times. Arrange these names in the alphabetical order.
SELECT 
    CONCAT(first_name, ' ', last_name) AS Full_Name
FROM
    category
        INNER JOIN
    film_category USING (category_id)
        INNER JOIN
    film USING (film_id)
        INNER JOIN
    inventory USING (film_id)
        INNER JOIN
    rental USING (inventory_id)
        INNER JOIN
    customer USING (customer_id)
WHERE
    name = 'Sci-Fi'
GROUP BY Full_Name
HAVING COUNT(rental_id) > 2
ORDER BY Full_Name;

-- Q7: Write a query to find the full names of those customers who have rented at least one movie and belong to the city Arlington.
SELECT 
    CONCAT(first_name, ' ', last_name) AS Full_Name
FROM
    rental
        INNER JOIN
    customer USING (customer_id)
        INNER JOIN
    address USING (address_id)
        INNER JOIN
    city USING (city_id)
WHERE
    city = 'Arlington'
GROUP BY Full_Name
HAVING COUNT(rental_id) > 1;

-- Q8: Write a query to find the number of movies rented across each country. Display only those countries where at least one movie was rented. Arrange these countries in the alphabetical order.
SELECT 
    country, COUNT(*) AS Rented_Movies
FROM
    country
        INNER JOIN
    city USING (country_id)
        INNER JOIN
    address USING (city_id)
        INNER JOIN
    customer USING (address_id)
        INNER JOIN
    rental AS r USING (customer_id)
GROUP BY country
HAVING COUNT(rental_id) > 1
ORDER BY country;




