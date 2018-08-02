#1a. Display the first and last names of all actors from the table actor.
#use sakila;
#select * from actor;

select first_name, last_name
from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name,' ',last_name) as 'Actor Name'
from actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT ACTOR_ID, FIRST_NAME, LAST_NAME
FROM ACTOR
WHERE FIRST_NAME = 'JOE';

#2b. Find all actors whose last name contain the letters GEN:
SELECT *
FROM ACTOR
WHERE LAST_NAME LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT LAST_NAME, FIRST_NAME
FROM ACTOR 
WHERE LAST_NAME LIKE '%LI%';

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM COUNTRY;

SELECT COUNTRY_ID, COUNTRY
FROM COUNTRY
WHERE COUNTRY IN ('AFGHANISTAN', 'BANGLADESH','CHINA');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE ACTOR ADD COLUMN MIDDLE_NAME VARCHAR (25) AFTER FIRST_NAME;
SELECT * FROM ACTOR;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE ACTOR MODIFY COLUMN MIDDLE_NAME BLOB;

#3c. Now delete the middle_name column
ALTER TABLE actor
DROP COLUMN MIDDLE_NAME;

SELECT * FROM ACTOR;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT LAST_NAME, COUNT(LAST_NAME) AS '# OF ACTORS WITH LAST_NAME'
FROM ACTOR
GROUP BY LAST_NAME;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT LAST_NAME, COUNT(LAST_NAME)
FROM ACTOR
GROUP BY LAST_NAME
HAVING COUNT(LAST_NAME) > 1;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT * 
FROM ACTOR
WHERE LAST_NAME = 'WILLIAMS';

UPDATE ACTOR 
SET FIRST_NAME = 'HARPO'
WHERE FIRST_NAME = 'GROUCHO'; 

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE ACTOR 
SET FIRST_NAME = 'GROUCHO'
WHERE FIRST_NAME = 'HARPO'; 

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
SELECT * FROM ADDRESS;
SHOW CREATE TABLE ADDRESS;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT * FROM STAFF;

SELECT S.FIRST_NAME, S.LAST_NAME, A.ADDRESS
FROM STAFF S
INNER JOIN ADDRESS A
ON S.ADDRESS_ID=A.ADDRESS_ID;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT * FROM PAYMENT;

SELECT S.FIRST_NAME, S.LAST_NAME, SUM(P.AMOUNT) AS 'TOTAL AMOUNT', P.PAYMENT_DATE 
FROM STAFF S
JOIN PAYMENT P 
ON S.STAFF_ID=P.STAFF_ID
WHERE P.PAYMENT_DATE = '2005-08%';
#****THERE ARE NO TRANSACTIONS IN AUGUST 2005 FOR THE STAFF MEMBERS

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT * FROM FILM_ACTOR;

SELECT F.TITLE, COUNT(ACTOR_ID) AS '# OF ACTORS PER FILM'
FROM film F
INNER JOIN FILM_ACTOR FA
ON F.FILM_ID=FA.FILM_ID
GROUP BY F.TITLE;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM INVENTORY;
SELECT * FROM FILM;

SELECT F.TITLE, COUNT(I.FILM_ID) AS '# OF COPIES'
FROM FILM F
INNER JOIN INVENTORY I
ON F.FILM_ID=I.FILM_ID
WHERE I.FILM_ID = 439;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT * FROM PAYMENT;
SELECT * FROM CUSTOMER;

SELECT C.FIRST_NAME, C.LAST_NAME, SUM(P.AMOUNT) AS 'TOTAL PAID'
FROM CUSTOMER C
JOIN PAYMENT P 
ON C.CUSTOMER_ID=P.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY LAST_NAME;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT *
FROM film
WHERE TITLE LIKE 'K%' OR TITLE LIKE'Q%'
AND language_id IN 
(
	SELECT language_id
	FROM LANGUAGE
	WHERE NAME IN ('ENGLISH')
);

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT *
FROM ACTOR WHERE ACTOR_ID IN 
	(SELECT ACTOR_ID
	FROM FILM_ACTOR 
	WHERE FILM_ID = 17); 


#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT C.FIRST_NAME, C.LAST_NAME, C.EMAIL, CO.COUNTRY
FROM CUSTOMER C
INNER JOIN ADDRESS A
ON C.ADDRESS_ID=A.ADDRESS_ID
INNER JOIN CITY CI
ON A.CITY_ID=CI.CITY_ID
INNER JOIN COUNTRY CO
ON CI.COUNTRY_ID=CO.COUNTRY_ID
WHERE CO.COUNTRY = 'CANADA';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT F.TITLE, C.NAME
FROM FILM_CATEGORY FC
INNER JOIN FILM F
ON FC.FILM_ID=F.FILM_ID
INNER JOIN CATEGORY C
ON C.CATEGORY_ID=FC.CATEGORY_ID
WHERE C.NAME = 'FAMILY';

#7e. Display the most frequently rented movies in descending order.
SELECT R.RENTAL_ID, I.INVENTORY_ID, F.FILM_ID, F.TITLE, COUNT(I.FILM_ID) AS '# OF RENTED MOVIES'
FROM INVENTORY I
INNER JOIN RENTAL R
ON I.INVENTORY_ID=R.INVENTORY_ID
INNER JOIN FILM F
ON I.FILM_ID=F.FILM_ID
GROUP BY F.TITLE
ORDER BY COUNT(I.FILM_ID) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
#SELECT * FROM STORE;
SELECT S.STORE_ID, SUM(P.AMOUNT) AS 'REVENUE'
FROM STORE S
INNER JOIN ADDRESS A
ON S.ADDRESS_ID=A.ADDRESS_ID
INNER JOIN CUSTOMER C
ON C.ADDRESS_ID=A.ADDRESS_ID
INNER JOIN PAYMENT P 
ON P.CUSTOMER_ID=C.CUSTOMER_ID
GROUP BY S.STORE_ID;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT S.STORE_ID,CI.CITY,CO.COUNTRY
FROM COUNTRY CO
INNER JOIN CITY CI
ON CO.COUNTRY_ID=CI.COUNTRY_ID
INNER JOIN ADDRESS A 
ON A.CITY_ID=CI.CITY_ID
INNER JOIN STORE S
ON A.ADDRESS_ID=S.ADDRESS_ID;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT C.NAME, SUM(P.AMOUNT) AS 'GROSS REVENUE'
FROM CATEGORY C
INNER JOIN FILM_CATEGORY FC
ON C.CATEGORY_ID=FC.CATEGORY_ID
INNER JOIN INVENTORY I
ON FC.FILM_ID=I.FILM_ID
INNER JOIN RENTAL R
ON I.INVENTORY_ID=R.INVENTORY_ID
INNER JOIN PAYMENT P
ON P.RENTAL_ID=R.RENTAL_ID
GROUP BY C.NAME
ORDER BY SUM(P.AMOUNT) DESC LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW TOP5_GENRE_GROSS_REV AS
	SELECT C.NAME, SUM(P.AMOUNT) AS 'GROSS REVENUE'
	FROM CATEGORY C
	INNER JOIN FILM_CATEGORY FC
	ON C.CATEGORY_ID=FC.CATEGORY_ID
	INNER JOIN INVENTORY I
	ON FC.FILM_ID=I.FILM_ID
	INNER JOIN RENTAL R
	ON I.INVENTORY_ID=R.INVENTORY_ID
	INNER JOIN PAYMENT P
	ON P.RENTAL_ID=R.RENTAL_ID
	GROUP BY C.NAME
	ORDER BY SUM(P.AMOUNT) DESC LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM top5_genre_gross_rev;
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top5_genre_gross_rev;