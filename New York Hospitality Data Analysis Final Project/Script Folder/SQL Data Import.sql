create database hotel;
use hotel;
create table address(address_id int,
      address_name char(40)
                        );
#drop table address;


#select * from address;    
create table hotel_properties_ny(hotel_property_id int,
        postcode int,
                                owner_id int,
                                borough_code int,
        latitude double,
                                longtitude double,
        address_id int
                        );     
                        
#select * from hotel_properties; 
#drop table hotel_properties;

create table owner(owner_id int,
      owner_name char(250)
                        );

#select * from properties_owner;  
#drop table properties_owner;

create table Borough(borough_code int,
      borough_name char(40)
                        );

#select * from airbnb_borough;  
#drop table airbnb_borough;

create table Host(host_id int,
      host_name char(40)
                        );

#select * from airbnb_host;  
#drop table airbnb_host;
create table airbnb_name(airbnb_id int,
      airbnb_name char(250)
                        );

#select * from airbnb_name;  
#drop table airbnb_name;
create table airbnb_ny(airbnb_id int,
       host_id int,
       borough_code int,
                            latitude double,
                            longitude double,
                            room_type char(40),
                            price int,
                            minimum_nights int,
                            number_of_reviews int,
                            calculated_host_listings_count int,
                            availability_365 int
                        );
     
#drop table airbnb_ny_all;
#select * from airbnb_ny_all;  

create table restaurant_name(restaurant_id int,
      restaurant_name char(50)
                        );

#select * from restaurant_name;  
#drop table restaurant_name;
create table restaurant_ny(claim_number int,
      restaurant_name char(50),
                        borough_name char(40),
                        address char(40),
                        zipcode int,
                        inspection_date char(10),
                        grade char(5)
                        );

#select * from restaurant_ny;  
#drop table restaurant_ny;
create table hotel_ny(hotel_id int,
      hotel_name char(250),
                        address_id int,
                        city char(40),
                        postal_code int,
                        latitude double,
                        longtitude double,
                        star_rating double,
                        high_rate double,
                        low_rate double
                        );

#select * from restaurant_name; 
#drop table hotel_ny;