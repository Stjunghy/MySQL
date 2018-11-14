-- Start by using the Sakila Database
USE sakila;

-- 1a Display first & last name of all actors from the table
SELECT first_name, last_name FROM actor;

-- 1b Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name' FROM actor;


-- 2a Query to obtain ID number, first name, last name, and last name of actor 'Joe'
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

-- 2b Find all actors w/ last name containing letters 'GEN'
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';

-- 2c Find all actors w/ last name containing the letters 'Li', but oder rows by last name and first name
SELECT actor_id, last_name, first_name FROM actor WHERE last_name LIKE '%LI%';

-- 2d Using 'IN', display country_id and country columns of Afghan, Bangladesh, and China
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');



-- 3a Add 'middle name' column to actor table, between first & laxt name
ALTER TABLE actor 
ADD COLUMN middle_name VARCHAR(25)
AFTER first_name;

-- 3b Change the data type of 'middle_name column to 'blobs'

ALTER TABLE actor MODIFY middle_name Blob;

-- 3c Delete 'middle_name' column.

ALTER TABLE actor DROP COLUMN middle_name;



-- 4a List last names of actors and how many actors have that last name

SELECT last_name, COUNT(*) AS 'Number of Actors' FROM actor
GROUP BY last_name;

-- 4b List last names of actors and # of actors who have that last name, but only for names shared by at least 2 actors

SELECT last_name, COUNT(*) AS 'Number of Actors' FROM actor
GROUP BY last_name HAVING COUNT(*) >= 2;

-- 4c Write Query to fix the name of Harpo's second cousin's husband's yoga teacher

UPDATE actor
SET first_name = 'HARPO' WHERE first_name = 'Groucho' AND last_name = 'Williams';


-- 4d In a single query, if the first name of actor is HARPO, change it to GROUCHO

UPDATE actor
SET first_name = 'GROUCHO' WHERE actor_id = 172;

-- 5a Use query

DESCRIBE sakila.address;

-- 6a Use JOIN to display the first and last names as well as the address of each staff member, use tables 'staff' and 'address'

SELECT first_name, last_name, address FROM staff s Join address a ON s.address_id = a.address_id;


-- 6b Use Join to display total amount run up by each staff member in aug 2005, use tables 'staff', and 'payment'

SELECT payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%';


-- 6c List each film & number of actors who are listed for film, use tables 'film_actor' and 'film' inner join

SELECT f.title AS 'Film Title', COUNT(fa.actor_id) AS 'Number of Actors' FROM film_actor fa
INNER JOIN film f ON fa.film_id = f.film_id
GROUP BY f.title;

-- 6d How many copies of film 'Hunchback impossible' exist in inventory system

SELECT title, (
SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id )
AS 'Number of Copies' FROM film WHERE title = "Hunchback Impossible";


-- 6e Using tables 'payment' and 'customer' and 'JOIN' command, list the total paid by each customer, list alphabetically by last name;

SELECT c.first_name, c.last_name, sum(p.amount) AS 'Total Paid'
FROM customer c JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.last_name;


-- 7a

SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND title IN (
SELECT title
FROM film
WHERE language_id = 1 );

 
-- 7b Use subqueries to display all actors who appear in the film 'alone trip'

SELECT first_name, last_name FROM actor WHERE actor_id IN
(
SELECT actor_id FROM film_actor WHERE film_id IN
(
SELECT film_id FROM film WHERE title = 'Alone Trip' ));

-- 7c Use joins to retrive names and email addreses of all canadian customers

SELECT cus.first_name, cus.last_name, cus.email
FROM customer cus JOIN address a ON (cus.address_id = a.address_id)
JOIN city cty ON (cty.city_id = a.city_id)
JOIN country ON(country.country_id = cty.country_id)
WHERE country.country = 'Canada';

-- 7d Identify all movies categorized as family films

SELECT title, description FROM film WHERE film_id IN
(
SELECT film_id FROM film_category WHERE category_id IN
(
SELECT category_id FROM category WHERE name = 'Family'
));

-- 7e Display most frequnetly rented movies in descending order

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r JOIN inventory i ON (r.inventory_id = i.inventory_id)
JOIN film f ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY 'Times Rented' DESC;

-- 7f Write a query to display how much business in dollars each store brought insert

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (i.inventory_id = r.inventory_id)
JOIN store s ON (s.store_id = i.store_id)
GROUP BY s.store_id;

-- 7g Write a query to display for each store its store ID, city, and country

SELECT s.store_id, cty.city, country.country
FROM store s JOIN address a ON (s.address_id = a.address_id)
JOIN city cty ON (cty.city_id = a.city_id) 
JOIN country ON (country.country_id = cty.country_id);


-- 7h List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross'
FROM category c JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id) 
GROUP BY c.name ORDER BY gross LIMIT 5;


-- 8a 

CREATE VIEW genre_revenue AS 
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross'
FROM category c JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross LIMIT 5;

-- 8b How would you dsiplay the view created in 8a

SELECT * FROM genre_revenue;

-- 8c Write query to delete top five genres

DROP VIEW genre_revenue;







