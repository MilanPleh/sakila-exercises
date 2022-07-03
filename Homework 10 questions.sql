-- Which actors have the first name ‘Scarlett’
SELECT * 
FROM actor 
WHERE first_name = 'Scarlett';

-- Which actors have the last name ‘Johansson’
SELECT 
    *
FROM
    actor
WHERE
    last_name = 'Johansson';

-- How many distinct actors last names are there?
SELECT COUNT(DISTINCT last_name) 
FROM actor;

-- Which last names are not repeated?
SELECT DISTINCT(last_name)
FROM actor;

-- Which last names appear more than once?
SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- Which actor has appeared in the most films?
SELECT actor.actor_id, actor.first_name, actor.last_name,
COUNT(actor_id) AS film_count
FROM actor JOIN film_actor USING (actor_id)
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;

-- Is ‘Academy Dinosaur’ available for rent from Store 1?
SELECT 
    f.title, f.film_id, i.inventory_id, s.store_id
FROM
    film AS f
        JOIN
    inventory AS i ON f.film_id = i.film_id
        JOIN
    store AS s ON s.store_id = i.store_id
WHERE
    title = 'Academy Dinosaur'
        AND s.store_id = 1;

-- Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today .
SELECT 
    r.rental_date,
    f.title,
    i.film_id,
    s.store_id,
    c.first_name,
    c.last_name,
    st.first_name,
    st.last_name
FROM
    store AS s
        JOIN
    staff AS st ON s.store_id = st.store_id
        JOIN
    customer AS c ON s.store_id = c.store_id
        JOIN
    inventory AS i ON s.store_id = i.store_id
        JOIN
    film AS f ON f.film_id = i.film_id
        JOIN
    rental AS r ON st.staff_id = r.staff_id
WHERE
    c.first_name = 'Mary'
        AND f.title = 'Academy Dinosaur';

-- When is ‘Academy Dinosaur’ due?
SELECT 
    rental_duration AS rental_due, title
FROM
    film
WHERE
    title = 'Academy Dinosaur';

-- What is that average running time of all the films in the sakila DB?
SELECT Avg(Average) as totalAverage FROM
(SELECT avg(length) as Average, film_id, title
FROM film
GROUP BY film_id
ORDER BY Average) as AVERAGEE;

-- What is the average running time of films by category?
SELECT avg(length), category_id 
FROM film
JOIN film_category 
ON film.film_id = film_category.film_id
GROUP BY category_id
ORDER BY avg(length) DESC;


