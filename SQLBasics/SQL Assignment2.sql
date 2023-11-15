CREATE TABLE customers ( 
	customer_id int Primary Key, 
	first_name varchar(50) NOT NULL, 
	last_name varchar(50) NOT NULL, 
	email varchar(100), 
	"address" varchar(100), 
	city char(50), 
	"state" char(25), 
	zip char(10) 
);

Insert into customers values
(1, 'White', 'Clover', 'white.clover@gmail.com', '305 - 14th Ave. S. Suite 3B', 'Seattle', 'WA', '98128'), 
(2, 'Wilman', 'Kala', 'wilman.kala@gmail.com', 'Keskuskatu 45', 'Helsinki', 'MA', '21240'),
(3, 'Wolski', 'Anna', 'wolski.anna@gmail.com', 'ul. Filtrowa 68	', 'Walla', 'GA', '01-012'),
(4, 'Karl', 'Jablonski', 'karl.jablonski.clover@gmail.com', 'Gateveien 15', 'Liverpool', 'WA', '4306'),
(5, 'Matti', 'Karttunen', 'matti.karttunen@gmail.com', 'Skagen 21', 'Stavanger', 'Norway', '4006');

Select first_name, last_name from Customers;

Select * 
from Customers
where first_name like 'G%' and city ='SanJose';

Select * 
from Customers
where lower(email) like '%gmail%';

Select * 
from Customers
where last_name not like '%A';

----------------------------------------------------------------------
-- Assignment: Different Types of Joins
CREATE TABLE Orders ( 
	order_id int Primary Key, 
	order_date date NOT NULL, 
	amount int, 
	customer_id int
);

insert into orders values
(1, '02-01-2023', 1234, 1),
(2, '02-02-2023', 234, 2),
(3, '03-21-2023', 134, 1),
(4, '03-01-2023', 123, 5),
(5, '05-01-2023', 124, 2);

Select customers.*, order_id, order_date, amount
from customers inner join orders on orders.customer_id = customers.customer_id;

Select customers.*, order_id, order_date, amount
from customers left join orders on orders.customer_id = customers.customer_id;

Select customers.*, order_id, order_date, amount
from customers right join orders on orders.customer_id = customers.customer_id;

Select customers.*, order_id, order_date, amount
from customers full outer join orders on orders.customer_id = customers.customer_id;

update orders set amount = 100 where customer_id = 3;

----- functions
-- 1. Use the inbuilt functions and find the minimum, maximum and average amount from the orders table 
select min(amount) as minimum_amount, max(amount) as maximum_amount, avg(amount) as average_amount from orders;

-- 2. Create a user-defined function which will multiply the given number with10
CREATE FUNCTION dbo.multiply_by_10 (@amount int)
RETURNS int
AS
BEGIN
RETURN (@amount *10)
END;

Select dbo.multiply_by_10( amount ) from orders;

--- 3. Use the case statement to check if 100 is less than 200, greater than 200 or equal to 200 and print the corresponding value.
select case when 100 < 200 then 'less than 200'
			when 100 = 200 then 'equal to 200'
			when 100 > 200 then 'greater than 200'
			-- when 100 >= 200 then 'greater than 200'
		end  as comment_100;

select amount, case when amount < 100 then 'Less than 100'
					when amount < 200 then 'Less than 200 and greater than 100'
					when amount = 200 then 'Equal to 200'
					when amount > 200 then 'Greater than 200'
				else 'invalid amount' 
				end as comments
from orders;

EXEC master.sys.sp_MSset_oledb_prop;


-- 4. Using a case statement, find the status of the amount. 
-- Set the status of the amount as high amount, low amount or medium amount based upon the condition. 
select amount, case when amount <= 100 then 'Low Amount'
					when amount < 200 then 'medium Amount'
					when amount >= 200 then 'High Amount'
				else 'invalid amount' 
				end as comments
from orders;

CREATE FUNCTION dbo.greater_than_amount(@amount int)
RETURNS TABLE
AS RETURN 
		(SELECT amount 
		FROM orders
		WHERE amount >= @amount );

-- drop function dbo.greater_than_amount;

Select * from dbo.greater_than_amount(100) ;

Select * from Orders order by amount desc;

create table Employee_details1 (
	Emp_id int,
	Emp_name varchar(75),
	Emp_salary int
);

select * into Employee_details2 
from Employee_details1 
Where 1=2;

Select * from Employee_details1;
select * from Employee_details2;

Select * from Employee_details1
Union
Select * from Employee_details2;


Select * from Employee_details1
INTERSECT
Select * from Employee_details2;

Select * from Employee_details1
EXCEPT
Select * from Employee_details2;

----------------------- 
-- transactions, exception handling
create view customer_san_jose as
select * from customers
where city = 'San Jose';

-- 2. Inside a transaction, update the first name of the customer to Francis where the last name is Jordan: 
begin try 
begin transaction 
update customers set first_name = 'Francis' 
Where last_name = 'Jordan';
commit transaction
print 'transaction successful';
end try
begin catch
print 'transaction rolled back';
rollback transaction
end catch

begin transaction 
update customers set first_name = 'Francis' 
Where last_name = 'Jordan';
rollback transaction

update customers set first_name = 'Alex' where last_name = 'Jordan';

begin try 
begin transaction 
select 100/0;
commit transaction
print 'transaction successful';
end try
begin catch
print error_message();
rollback transaction
end catch

select * from Orders;

begin try 
begin transaction 
insert into Orders values(6, '2023-09-15', 342,1);
commit transaction
print 'transaction successful';
end try
begin catch
rollback transaction
print 'transaction rolled back';
end catch

SELECT TRIM('0 ' FROM '    0000SQL Tu000torial!    ') AS TrimmedString;
select trim('0 ' from '  000abc 00def 000') 
select substring('peter singh', replace('peter singh', ' ','') , len('peter singh'));
select substring('namehello name1hello', charindex(' ', 'namehello name1hello'), len('namehello name1hello') - charindex('namehello name1hello', ' ')+1);
select charindex('name name1', ' ')
