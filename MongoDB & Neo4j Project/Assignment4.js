db.customers.find({})
   .projection({})
   .sort({_id:-1})
   .limit(100)
   
   
/* 1. List total number of customers living in california ? */
   
db.customers.find({ District: "California" }).count()


/* 2. List all movies that are rated NC-17 */

db.films.find({Rating:"NC-17"})


/* 3. List the count of movies by category */

db.films.aggregate([ {"$group": {_id:"$Category", count:{$sum:1}}} ])

/* 4. Find the top 2 movies with movie length greater than 25mins OR which has commentaries as a special feature*/
db.films.find(
    {$or: [{Length:{$gt: '25'}}, {'Special Features':{'$regex':"Commentaries"}} ]}, 
    {Title: 1, Length:1, 'Special Features':1}).limit(2)


/* 5. Find the top 10 customers based on number of rentals */
db.customers.aggregate(
    {$project:{item:1,
    "First Name":1,"Last Name":1,
    numberRental: {$size: "$Rentals"}}}).sort({numberRental: -1}).limit(10)
 



/* 6. Provide 5 additional queries and indicate the specific business use cases they address
Note: Insights should not be a flavor of the previously addressed queries within Assignment 4. */

/* 1. List the count of movies by special features */

db.films.aggregate([ {"$group": {_id:"$special features", count:{$sum:1}}} ])

/* 2. Find the top 10 films based on number of actors */
    
db.films.aggregate(
    {$project:{item:1,
    "Title":1,
    numberActor: {$size: "$Actors"}}}).sort({numberActor: -1}).limit(10)
 

/* 3. List all customers that are from China */

db.customers.find({Country:"China"})



/* 4. Count the number of customers with last name Grey */

db.customers.find({"Last Name": "GREY"}).count()

/* 5. Sort the films by rental duration */

db.films.find().sort({"Rental Duration": 1})
