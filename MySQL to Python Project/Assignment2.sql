/***********************************************
** File: Assignment2-PartB.sql
** Desc: Manipulating, Categorizing, Sorting and Grouping & Summarizing Data
** Author: Fiona Fei
** Date: 10.23.2021
************************************************/



######## QUESTION 1 ######## – { 10 Points }
# a) Show the list of databases.
show databases;

# b) Select sakila database.

USE sakila;

# c) Show all tables in the sakila database.
show tables; 


# d) Show each of the columns along with their data types for the actor table.
SHOW COLUMNS FROM `actor`;

# e) Show the total number of records in the actor table.
SELECT count(actor_id) as 'count' FROM actor;



# f) What is the first name and last name of all the actors in the actor table ?
# actor: first_name, last_name
select first_name,last_name
from actor;

# g) Insert your first name (in first name column) and middle initial ( in the last name column ) into the actors table.
insert into actor(first_name,last_name)
values
	('FIONA','F');

# h) Update your middle initial with your last name (in last name column) in the actors table.
update actor
set
	last_name = 'FEI'
where
	first_name = 'FIONA';
    
select first_name,last_name
from actor;


# i) Delete the new record from the actor table where the first name and last name matches yours.
DELETE FROM actor 
WHERE first_name = 'FIONA';

select first_name,last_name
from actor;

# j) Create a table payment_type with the following specifications and appropriate data types 

# Table Name : “Payment_type”
# Primary Key: "payment_type_id”
# Column: “Type”


create table Payment_type(
   payment_type_id INT NOT NULL AUTO_INCREMENT,
   Type VARCHAR(100) NOT NULL,
   PRIMARY KEY ( payment_type_id )
);

# Insert following rows in to the table:
# 1, “Credit Card” ; 2, “Cash”; 3, “Paypal” ; 4 , “Cheque”


INSERT INTO Payment_type(payment_type_id,Type)
VALUES(1,'Credit Card'),
	(2,'Cash'),
	(3,'Paypal'),
	(4,'Cheque');
    
# k) Rename table payment_type to payment_types.
RENAME TABLE Payment_type TO payment_types;

# l) Drop the table payment_types. 
DROP TABLE payment_types;


######## QUESTION 2 ######## – { 10 Points }
# a) List all the movies ( title & description ) that are rated PG-13 ?
select distinct title,description
from film
where rating = 'PG-13';


# b) List all movies that are either PG OR PG-13 using IN operator ?
SELECT *
FROM film
WHERE rating IN ('PG-13', 'PG');


# c) Report all payments greater than and equal to 2$ and Less than equal to 7$ ?
# Note : write 2 separate queries conditional operator and BETWEEN keyword

select *
FROM payment
WHERE amount between 2 and 7;

SELECT *
FROM payment
WHERE amount >= 2
AND amount <= 7;


# d) List all addresses that have phone number that contain digits 589. 
#A separate query for phone numbers that start with 140, and a third query 
#that ends with 589
# Note : write 3 different queries

SELECT *
from address
WHERE phone like '%589%';

SELECT *
from address
WHERE phone like '140%';

SELECT *
from address
WHERE phone like '%589';


# e) List all staff members ( first name, last name, email ) whose password is NULL ?




# f) Select all films that have title names like ZOO and rental duration 
# greater than or equal to 4




# g) What is the cost of renting the movie ACADEMY DINOSAUR for 2 weeks ?




# Note : use of column alias and watch for rental_duration value




# h) List all unique districts where the customers, staff, and stores are located
# Note : check for NOT NULL values




# i) List the top 10 newest customers across all stores based on customer_id




