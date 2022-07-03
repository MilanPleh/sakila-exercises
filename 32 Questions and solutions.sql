-- 1a. Display the first and last names of all actors from the table actor.
SELECT 
    first_name, last_name
FROM
    actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS Actor_Name
FROM
    actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, “Joe.” What is one query would you use to obtain this information?
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name 
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name.
ALTER table actor
ADD column middle_name VARCHAR(25) AFTER first_name;

SELECT * FROM actor;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER table actor
MODIFY column middle_name BLOB;

-- 3c. Now delete the middle_name column.
ALTER table actor 
DROP column middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) as NumberOfLN
from actor
GROUP BY last_name
ORDER BY NumberOfLN DESC;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) as NumberOfLN
from actor 
GROUP BY last_name
HAVING COUNT(last_name)>2
ORDER BY NumberOfLN;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo’s second cousin’s husband’s yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER!
SELECT *
FROM actor
WHERE first_name = 'GROUCHO' OR first_name = 'HARPO';

UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM address as a
JOIN staff as s
ON a.address_id = s.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, p.amount, p.payment_date, s.staff_id
FROM payment as p 
INNER JOIN staff as s 
WHERE p.payment_date LIKE '2005-08%'
ORDER BY p.amount DESC;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.film_id, COUNT(fa.actor_id) as numberOFactors, f.title 
FROM film as f
INNER JOIN film_actor as fa 
ON f.film_id = fa.film_id
GROUP BY f.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, COUNT(f.film_id) as NumberOfCopies
FROM film as f 
INNER JOIN inventory as i
ON f.film_id = i.film_id 
WHERE title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) as Total
FROM customer as c
INNER JOIN payment as p 
ON c.customer_id = p.customer_id
GROUP BY c.last_name
ORDER BY c.last_name; 

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT l.name as Movie_Language, f.title FROM film as f
INNER JOIN language as l 
    ON l.language_id = f.language_id 
WHERE f.language_id in
	(SELECT l.language_id
	FROM language as l
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");
-- or
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT a.first_name, a.last_name, f.title, fa.actor_id 
FROM actor as a
INNER JOIN film_actor as fa
    ON a.actor_id = fa.actor_id 
INNER JOIN film as f 
ON f.film_id = fa.film_id
WHERE (a.first_name) AND (a.last_name) in
	(SELECT title
	FROM film
	WHERE title = "Alone Trip");
    
SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

 
-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT co.country, c.first_name, c.last_name, c.email
FROM customer as c
INNER JOIN address as a
ON c.address_id = a.address_id
INNER JOIN city as ct
ON a.city_id = ct.city_id
INNER JOIN country as co
ON ct.country_id = co.country_id 
WHERE co.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT f.film_id, f.title, cat.category_id, cat.name 
FROM category as cat
INNER JOIN film_category as fc
USING (category_id)
INNER JOIN film as f
USING (film_id)
WHERE cat.name = 'Family'
ORDER BY f.film_id;

-- 7e. Display the most frequently rented movies in descending order.

 SELECT f.film_id, f.title, COUNT(r.rental_id) 
 FROM payment as p
 INNER JOIN rental as r 
 USING(rental_id)
 INNER JOIN inventory as i 
 USING(inventory_id)
 INNER JOIN film as f
 USING(film_id)
 GROUP BY f.film_id
 ORDER BY COUNT(r.rental_id) DESC;
 
-- 7f. Write a query to display how much business, in dollars, each store brought in.
-- store1, payment3, staff2
SELECT SUM(pay.amount) as total_amount, s.store_id
FROM store as s
INNER JOIN staff as st
ON s.store_id = st.store_id
INNER JOIN payment as pay 
ON pay.staff_id = st.staff_id
GROUP BY s.store_id; 

-- 7g. Write a query to display for each store its store ID, city, and country.
-- store so adress, address so city, city so country
SELECT st.store_id, c.city, c.city_id, ct.country, ct.country_id
FROM store as st
INNER JOIN address as ad
ON st.address_id = ad.address_id
INNER JOIN city as c
ON c.city_id = ad.city_id
INNER JOIN country as ct
ON ct.country_id = c.country_id;

-- 7h. List the top five genres in gross revenue in descending order.
-- payment so rental, inventory so film_category, category so film category
SELECT cat.category_id, cat.name, SUM(pay.amount) as Gross_Revenue, inv.store_id
FROM payment as pay
INNER JOIN rental as r 
USING (rental_id)
INNER JOIN inventory as inv
USING (inventory_id)
INNER JOIN film_category as fc
USING (film_id)
INNER JOIN category as cat
USING (category_id) 
GROUP BY category_id 
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven’t solved 7h, you can substitute another query to create a view.

CREATE VIEW Top_Five_Genres AS
SELECT cat.category_id, cat.name, SUM(pay.amount) as Gross_Revenue, inv.store_id
FROM payment as pay
INNER JOIN rental as r 
USING (rental_id)
INNER JOIN inventory as inv
USING (inventory_id)
INNER JOIN film_category as fc
USING (film_id)
INNER JOIN category as cat
USING (category_id) 
GROUP BY category_id 
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * 
FROM Top_Five_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW Top_Five_Genres;