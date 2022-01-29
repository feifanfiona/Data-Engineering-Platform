/***********************************************
**  MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   Sakila Snowflake DDL - Assignment 3
** Desc:   ETL/DML for the Sakila Snowflake Dimensional model
** Auth:   Shreenidhi Bharadwaj
** Date:   02/24/2019
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/

---------------------------------------
USE SAKILA_SNOWFLAKE;


-- -----------------------------------------------------
-- Populate Time dimension
-- -----------------------------------------------------

INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

INSERT INTO numbers
SELECT 
    thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM
    numbers_small thousands,
    numbers_small hundreds,
    numbers_small tens,
    numbers_small ones
LIMIT 1000000;


INSERT INTO dim_date (date_Id, date)
SELECT 
    number,
    DATE_ADD('2005-01-01',
        INTERVAL number DAY)
FROM
    numbers
WHERE
    DATE_ADD('2005-01-01',
        INTERVAL number DAY) BETWEEN '2005-01-01' AND '2017-01-01'
ORDER BY number;

SET SQL_SAFE_UPDATES = 0;
UPDATE dim_date 
SET 
    timestamp = UNIX_TIMESTAMP(date),
    day_of_week = DATE_FORMAT(date, '%W'),
    weekend = IF(DATE_FORMAT(date, '%W') IN ('Saturday' , 'Sunday'),
        'Weekend',
        'Weekday'),
    month = DATE_FORMAT(date, '%M'),
    year = DATE_FORMAT(date, '%Y'),
    month_day = DATE_FORMAT(date, '%d');

UPDATE dim_date 
SET 
    week_starting_monday = DATE_FORMAT(date, '%v');

-- -----------------------------------------------------
-- Copy Data from sakila database 
-- -----------------------------------------------------
# dim_actor table 
# insert data into the dim_actor table from sakila models actor table 
INSERT INTO sakila_snowflake.dim_actor (    
	actor_id,
    actor_first_name,
    actor_last_name,
    actor_last_update)
(SELECT 
    actor_id,
    first_name,
    last_name,
    last_update
FROM
    sakila.actor);
    
# dim_staff table
# insert data into the dim_staff table from sakila models staff table 
INSERT INTO sakila_snowflake.dim_staff (    
	staff_id,
    staff_first_name,
    staff_last_name,
    staff_store_id,
    staff_last_update)
(SELECT 
    staff_id,
    first_name,
    last_name,
    store_id,
    last_update
FROM
    sakila.staff);


# dim_location_country
# insert data into the dim_location_country table from sakila models country table 
INSERT INTO sakila_snowflake.dim_location_country (    
	location_country_id,
    location_country_name,
    location_country_last_update)
(SELECT 
    country_id,
    country,
    last_update
FROM
    sakila.country);

# dim_location_city
# insert data into the dim_location_city table from sakila model city table 
INSERT INTO sakila_snowflake.dim_location_city(
	location_country_key,
	location_city_id,
    location_city_name,
    location_city_last_update) 
(SELECT
    location_country_key,
    city_id,
	city,
    s_city.last_update
FROM
    sakila.country as s_country, 
    sakila.city as s_city,
    sakila_snowflake.dim_location_country as dim_country
WHERE
	s_city.country_id = s_country.country_id AND
    s_city.country_id = dim_country.location_country_id);


# dim_location_address
# insert data into the dim_location_address table from sakila model city table 
INSERT INTO sakila_snowflake.dim_location_address(
	location_city_key,
	location_address_id,
    location_address,
    location_address_postal_code,
    location_address_last_update)
(SELECT
	dim_city.location_city_key,
	address_id,
    address,
    postal_code,
    last_update
FROM
    sakila.address as s_address,
    sakila_snowflake.dim_location_city as dim_city
WHERE
    s_address.city_id = dim_city.location_city_id);


# dim_store table
# insert data into the dim_store table from sakila models staff table 
INSERT INTO sakila_snowflake.dim_store (    
	location_address_key,
    store_last_update,
    store_id,
    store_manager_staff_id,
    store_manager_first_name,
    store_manager_last_name)
(SELECT 
    s_addr.location_address_key,
    s_store.last_update,
    s_store.store_id,
    manager_staff_id,
    first_name,
    last_name
FROM
    sakila.store as s_store,
    dim_location_address as s_addr,
    sakila.staff as s_staff
WHERE 
	s_store.address_id = s_addr.location_address_id  AND
    s_staff.staff_id = s_store.manager_staff_id);


# dim_customer
INSERT INTO sakila_snowflake.dim_customer (    
	location_address_key,
    customer_last_update,
    customer_id,
    customer_first_name,
    customer_last_name,
    customer_email,
    customer_active,
    customer_created)
(SELECT
    location_address_key,
    last_update,
    customer_id,
    first_name,
    last_name,
    email,
    active,
    create_date
FROM
    sakila.customer as s_cust,
    dim_location_address as s_addr
WHERE 
	s_cust.address_id = s_addr.location_address_id);



# dim_film
# insert data into the dim_store table from sakila models staff table 
INSERT INTO sakila_snowflake.dim_film (    
	film_id,
    film_last_update,
    film_title,
    film_description,
    film_release_year,
    film_language,
    film_rental_duration,
    film_rental_rate,
    film_duration,
    film_replacement_cost,
    film_rating_code,
    film_rating_text,
    film_has_trailers,
    film_has_commentaries,
    film_has_deleted_scenes,
    film_has_behind_the_scenes,
    film_in_category_action,
    film_in_category_animation,
    film_in_category_children,
    film_in_category_classics,
    film_in_category_comedy,
    film_in_category_documentary,
    film_in_category_drama,
    film_in_category_family,
    film_in_category_foreign,
    film_in_category_games,
    film_in_category_horror,
    film_in_category_music,
    film_in_category_new,
    film_in_category_scifi,
    film_in_category_sports,
    film_in_category_travel )
(
select f.film_id,
    f.last_update,
    f.title,
    f.description,
    f.release_year,
    l.name,
    f.rental_duration AS film_rental_duration,
    f.rental_rate AS film_rental_rate,
    f.length AS film_duration,
    f.replacement_cost AS film_replacement_cost,
    f.rating AS film_rating_code,
    f.special_features AS film_rating_text,   
	case when  f.special_features like '%Commentaries%' then 1 else 0 end film_has_Commentaries,
    case when  f.special_features like '%Trailers%' then 1 else 0 end film_has_trailers,
    case when  f.special_features like '%Deleted Scenes%' then 1 else 0 end film_has_deleted_scenes,
    case when  f.special_features like '%Behind the Scenes%' then 1 else 0 end film_has_behind_the_scenes,
	case when  c.name ='Action' THEN 1 ELSE 0 END AS film_in_category_action,
	case when  c.name ='Animation' THEN 1 ELSE 0 END AS film_in_category_animation,
	case when  c.name ='Children' THEN 1 ELSE 0 END AS film_in_category_children,
	case when  c.name ='Classics' THEN 1 ELSE 0 END AS  film_in_category_classics,
	case when  c.name ='Comedy' THEN 1 ELSE 0 END AS  film_in_category_comedy,
	case when  c.name ='Documentary' THEN 1 ELSE 0 END AS  film_in_category_documentary,
	case when  c.name ='Drama' THEN 1 ELSE 0 END AS film_in_category_drama,
	case when  c.name ='Family' THEN 1 ELSE 0 END AS film_in_category_family,
	case when  c.name ='Foreign' THEN 1 ELSE 0 END AS film_in_category_foreign,
	case when  c.name ='Games' THEN 1 ELSE 0 END AS film_in_category_games,
	case when  c.name ='Horror' THEN 1 ELSE 0 END AS film_in_category_horror,
	case when  c.name ='Music' THEN 1 ELSE 0 END AS  film_in_category_music,
	case when  c.name ='New' THEN 1 ELSE 0 END AS film_in_category_new,
	case when  c.name ='Scifi' THEN 1 ELSE 0 END AS film_in_category_scifi,
	case when  c.name ='Sports' THEN 1 ELSE 0 END AS film_in_category_sports,
	case when  c.name ='Travel' THEN 1 ELSE 0 END AS film_in_category_travel 
  from sakila.category c , sakila.film f, sakila.film_category fc, sakila.language l
  where  f.film_id = fc.film_id  and
  f.language_id = l.language_id and
  c.category_id = fc.category_id);
#  and f.film_id=19
# ) 


  
# group by f.film_id, f.title ....
  
# dim_actor_bridge
INSERT INTO sakila_snowflake.dim_film_actor_bridge (    
	film_key,
    actor_key
)
(SELECT
     film_key,
     actor_key
FROM
    sakila.film_actor s_fa,
    dim_actor d_a, 
    dim_film d_f
WHERE 
	s_fa.actor_id = d_a.actor_id AND
	s_fa.film_id = d_f.film_id);


# The below query might take over 30 seconds to complete and you might get an "Error Code: 2013. 
# Lost connection to MySQL server during query" error
# Please follow the instructions below:
#   - In the application menu, select Edit > Preferences > SQL Editor.
#   - Look for the MySQL Session section and increase the DBMS connection read time out value.
#   - Save the settings, quit MySQL Workbench and reopen the connection.

-- -----------------------------------------------------
-- Write Fact table fact_rental DML script here
-- -----------------------------------------------------

# fact_rental
# insert data into the fact_rental table from sakila model city table 

INSERT INTO sakila_snowflake.fact_rental(
	rental_id,
    rental_last_update,
	customer_key,
    staff_key,
    film_key,
    store_key,
    rental_date_key,
    return_date_key,
    count_returns,
    count_rentals,
    rental_duration,
    dollar_amount)
    
SELECT
    r.rental_id,
    r.last_update,
    (select dc.customer_key from dim_customer dc where dc.customer_id = r.customer_id),
    (select ds.staff_key from dim_staff ds where ds.staff_id = r.staff_id),
    (select df.film_key from dim_film df where df.film_id = i.film_id),
    (select dst.store_key from dim_store dst where dst.store_id = i.store_id),
    (select dd.date_Id from dim_date dd where dd.date = date(r.rental_date)) as rental_date,
    (select dd.date_Id from dim_date dd where dd.date = date(r.return_date)) as return_date,
    count(r.return_date),
    count(r.rental_date),
    #calculate date difference
    ABS(DATEDIFF(r.rental_date, r.return_date)) AS rental_duration,
    #calculate dollar amount
    (SELECT (ABS(DATEDIFF(r.rental_date, r.return_date)) * df.film_rental_rate) FROM dim_film df WHERE df.film_id = i.film_id)

	#select from multiple tables
	FROM
    sakila.rental  r
    inner join sakila.inventory i using (inventory_id)
    inner join sakila.film f using (film_id)
    inner join sakila.payment p using (rental_id)
    inner join dim_date d on d.date = DATE(r.rental_date)
    left join dim_date di on di.date = date(r.rental_date)
	
    #Group by rental id
	group by rental_id;



#SELECT ABS(DATEDIFF(r.rental_date, r.return_date)) AS rental_duration FROM sakila.rental r

