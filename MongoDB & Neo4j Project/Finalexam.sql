# RELATIONAL DATABASE : SAKILA
use sakila;


# Q1  List the top 10 customers ( first Name / Last Name ) based on number of rentals and name the top customer
SELECT 
    c.first_name, c.last_name, COUNT(r.rental_id) AS rentalNum
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY rentalNum DESC
LIMIT 10;

# Q2. List the most popular categories of movies based on number of rentals
SELECT 
    c.name, COUNT(r.rental_id) AS rentalNum
FROM
    category AS c
        INNER JOIN
    film_category fc ON c.category_id = fc.category_id
        INNER JOIN
    inventory i ON i.film_id = fc.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
GROUP BY c.name
ORDER BY rentalNum DESC
LIMIT 1;

#Q3. Find the customer name, customer phone and movie title for rentals that are overdue (assume rentals are allowed for 7 days max)
SELECT 
    c.first_name, c.last_name, a.phone, f.title, DATEDIFF(r.return_date, r.rental_date) as rental_period
FROM
    customer c
        INNER JOIN
    address a ON c.address_id = a.address_id
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
        INNER JOIN
    inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN
    film f ON f.film_id = i.film_id
    where DATEDIFF(r.return_date, r.rental_date)> 7;
    
    
#Q4. Show a full list of all the actors with their full name in 1 column

SELECT 
    CONCAT(first_name, last_name) AS actors_name
FROM
    actor;

#Q5. Find movies whose title ends with a
SELECT 
    title
FROM
    film
WHERE
    title LIKE '%a';

#Q6. Customers who did not order any movies
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    customer_id NOT IN (SELECT 
            customer_id
        FROM
            rental);
    

#Q7. Distinct count of all movies that are either PG-13 OR PG grouped by rating  
SELECT 
    COUNT(title)
FROM
    film
WHERE
    rating = 'PG-13' OR rating = 'PG'
GROUP BY rating;

#Q8. List all customers that live in the Nepal
SELECT 
    c.first_name, c.last_name
FROM
    customer c
        INNER JOIN
    address a ON c.address_id = a.address_id
        INNER JOIN
    city ON city.city_id = a.city_id
        INNER JOIN
    country co ON co.country_id = city.country_id
WHERE
    co.country = 'Nepal';

#Q9. What is the revenue generated by each employee ?
SELECT 
    s.first_name, s.last_name, SUM(p.amount)
FROM
    staff s
        INNER JOIN
    rental r ON r.staff_id = s.staff_id
        INNER JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY s.staff_id;

#Q10. List the inventory available in store to rent, for each of the movies
SELECT 
    f.title, COUNT(i.inventory_id) AS inventory
FROM
    inventory i
        INNER JOIN
    store s ON i.store_id = s.store_id
        INNER JOIN
    film f ON f.film_id = i.film_id
GROUP BY f.title;


