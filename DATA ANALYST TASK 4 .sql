## checking Dataset is properly loaded 
select * from customers 

select * from orders

---SELECT AND WHERE CALUSE
select * from orders where total_amount>300;
select * from customers where country = 'India';

--- ORDER BY CLAUSE
select * from orders order by total_amount DESC;
select * from customers order by name ASC;

--- GROUP BY CLAUSE 
select customer_id, sum(total_amount)as total_spent
from orders group by customer_id;


select country, count(*)as customer_count
from customers group by country;

select customer_id, sum(total_amount) as total_spent
from orders group by customer_id 
having sum(total_amount)> 500
order by total_spent desc 
limit 5;

--- INNER JOIN

select customers.customer_id,customers.name,orders.order_id,orders.total_amount
from customers
inner join orders
on customers.customer_id = orders.customer_id



---LEFT JOIN

select customers.customer_id,customers.name,orders.order_id,orders.total_amount
from customers
left join orders
on customers.customer_id = orders.customer_id


--- RIGHT JOIN

select customers.customer_id,customers.name,orders.order_id,orders.total_amount
from customers
right join orders
on customers.customer_id = orders.customer_id

---SUBQUERY SELECT to find total orders by customer

select customers.customer_id,customers.name,
(select count(*)
from orders
where orders.customer_id=customers.customer_id)
AS order_count 
from customers;


--- SUBQUERY IN WHERE TO FIND SPENDS MORE THE RS 1000


select name
from customers
where customer_id in(
select customer_id
from orders
group by customer_id
having sum(total_amount)>1000
);

---SUBQUERY IN FROM TO FIND TOP % CUSTOMERS AS PER TOTAL SPENDS 

select*
from(
select customer_id,
sum(total_amount) as total_spent 
from orders
group by customer_id)
as customer_spending
order by total_spent DESC
limit 5;


--- Creating index for query optimization

---spends up JOINS and WHERE filters

create index idx_orders_customer_id on orders(customer_id);

---for fast filtering by country
create index idx_customers_country on customers(country);

--- for range/threshold queries
create index idx_orders_total_amount on orders(total_amount);


--- using idx_orders_customer_id, country , range
select * from orders where customer_id=23;

select * from customers where country= 'India';

select * from orders where total_amount=300;

---Min to found smallest order per customer, and order amount

select min(total_amount) as lowest_order from orders;

select min(total_amount) as lowest_order from orders
group by customer_id;

--- max to find ou largest value and highest order per customer

select max(total_amount) as highest_order from orders;

select max(total_amount) as highest_order from orders
group by customer_id;

--- sum to find total revenue and amount per customer 

select sum(total_amount) as total_revenue from orders;

select sum(total_amount) as total_revenue from orders
group by customer_id;


--- avg to find out average vale and spend per customer

select avg(total_amount) as avg_order from orders;

select avg(total_amount) as avg_order from orders
group by customer_id;


--- view 

---customer order summary

create view customer_order_summary as
select
customers.customer_id,
customers.name,
customers.country,
count(orders.order_id) as total_order,
sum(orders.total_amount)as total_spent,
avg(orders.total_amount)as avg_order_value,
max(orders.total_amount)as highest_order,
min(orders.total_amount)as lowest_order
from customers
left join orders
on customers.customer_id=orders.customer_id
group by customers.customer_id,customers.name,customers.country;


select * from customer_order_summary where total_spent>1000;

