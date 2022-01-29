use hotel;

# list hotels with start rating betwen 4 and 5 in descend order. 
SELECT 
    hotel_name, star_rating
FROM
    hotel_ny
#GROUP BY hotel_ny.hotel_name
HAVING star_rating BETWEEN 4 AND 5
ORDER BY hotel_ny.star_rating DESC;

# count number of restaurants group by borough
SELECT 
    r.borough_name, COUNT(r.restaurant_name) AS total_count
FROM
    restaurant_ny AS r
        
GROUP BY r.borough_name
ORDER BY total_count DESC;

# count number of restaurant group by grade
SELECT 
    r.grade, COUNT(r.restaurant_name) AS total_count
FROM
    restaurant_ny AS r
        
GROUP BY r.grade
ORDER BY total_count DESC;