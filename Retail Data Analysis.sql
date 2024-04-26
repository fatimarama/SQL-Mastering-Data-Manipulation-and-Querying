use assignment_2; -- created a new schema

set sql_safe_updates = 0;

-- [Question 1] find out top 5 customers with the most orders

select customer_id, count(order_id) as number_of_orders
from orders
group by customer_id
order by number_of_orders desc, customer_id
limit 5;

-- [Question 2] find out the top 3 most sold items

select item_id, count(order_id) as quantity_sold
from orders
group by item_id
order by quantity_sold desc, item_id
limit 3;

-- [Question 3] show customers and total order only for customers with more than 4 orders

select customer_id, count(order_id) as number_of_orders
from orders
group by customer_id
having number_of_orders>4
order by number_of_orders desc, customer_id;

-- [Question 4] only show records for customers that live on oak st, pine st or cedar st and belong to either anyville or anycity

select *
from customers
where (address like "%oak st%" or address like "%pine st%" or address like "%cedar st%") and (city in ("anyville", "anycity"));

-- [Question 5] In a simple select query, create a column called price_label in which label each item's price as:
-- low price if its price is below 10
-- moderate price if its price is between 10 and 50
-- high price if its price is above 50
-- "unavailable" in all other cases

-- order this query by price in descending order

select *, 
case 
	when item_price<10 then "low price"
    when item_price>=10 and item_price<=50 then "moderate price"
    when item_price>50 then "high price"
    else "unavailable"
    end as price_label
from items
order by item_price desc;
	
    
-- [Question 6] Using DDL commands, add a column called stock_level to the items table.

alter table items
add column stock_level varchar(255);

-- [Question 7] Update this column in the following way:
-- low stock if the amount is below 20
-- moderate stock if the amount is between 20 and 50
-- high stock if the amount is over 50

update items
set stock_level=
case 
	when amount_in_stock<20 then "low stock"
    when amount_in_stock between 20 and 50 then "moderate stock"
    when amount_in_stock>50 then "high stock"
end;

-- [Question 8] from the customers table, delete the column country

alter table customers
drop column country;

-- [Question 9] find out the total no of customers in anytown without using group by and having

select count(customer_id) as total_customers_in_anytown
from customers
where city="anytown";

-- [Question 10] use DDL commands to add a column to the customers table called street. add this column directly after the address column
-- hint: google how to add a column before/after another column in MySQL 

alter table customers
add column street varchar(255) after address;

-- [Question 11] update this column by extracting the street name from address
-- (hint: MySQL also has mid/left/right functions the same as excel. You can first test these with SELECT before using UPDATE)

select mid(address, 5) as street_number
from customers;

update customers
set street=mid(address, 5);

-- [Question 12] Find out the number of customers per city per street. 
-- order the results in ascending order by city and then descending order by street

select city, street, count(customer_id) as number_of_customers
from customers
group by city, street
order by city, street desc;

-- [Question 13] in the orders table, update shipping date and order date to the correct format. also change the data types of these columns to date. 
-- (try to change both columns in one update statement and one alter statement)

select *
from orders;

update orders
set shipping_date=str_to_date(shipping_date, "%d/%m/%Y"), 
	order_date=str_to_date(order_date,"%d/%m/%Y");
    
alter table orders
modify shipping_date date, 
modify order_date date;

-- [Question 14] write a query to get order id, order date, shipping date and difference in days between order date and shipping date for each order
-- (google which function in MySQL can help you do this)
-- what do you observe in the results?

select order_id, order_date, shipping_date, datediff(shipping_date, order_date) as difference_in_days
from orders; 
-- there is one day difference between shipping dates and orders dates, orders are dispatched one day after the order is placed

-- [Question 15] find out items priced higher than the avg price of all items (hint: you will need to use a subquery here)

select round(avg(item_price),2)
from items; -- extra query, just to see the average price

select *
from items
where item_price > (select avg(item_price) from items);

-- [Question 16] using inner joins, get customer_id, first_name, last_name, order_id, order_date, item_id, item_name and item_price
-- (hint: you will need to join all three tables)

select c.customer_id, c.first_name, c.last_name, o.order_id, o.order_date, i.item_id, i.item_name, i.item_price
from customers c
join orders o
	on c.customer_id=o.customer_id
join items i
	on o.item_id=i.item_id;
