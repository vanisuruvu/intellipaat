--Problem Statement:
--How to get details about customers by querying a database?
--Topics:
--In this project, you will work on downloading a database and restoring it on the
--server. You will then query the database to get customer details like name, phone
--number, email ID, sales made in a particular month, increase in month-on-month
--sales and even the total sales made to a particular customer.
--Highlights:
--Table basics and data types
--Various SQL operators
--Various SQL functions

use AdventureWorks2019
--Perform the following with help of the above database:
--a. Get all the details from the person table including email ID, phone number and phone number type
select p.BusinessEntityID, p.FirstName, ea.EmailAddress, pp.PhoneNumber, pnt.Name 
from person.person p
join person.EmailAddress ea on p.BusinessEntityID = ea.BusinessEntityID
join person.PersonPhone pp on pp.BusinessEntityID = p.BusinessEntityID
join person.PhoneNumberType pnt on pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;

--b. Get the details of the sales header order made in May 2011
select * from sales.SalesOrderHeader where datepart(month,OrderDate) = '05' and datepart(year, OrderDate) = '2011';

--c. Get the details of the sales details order made in the month of May 2011
select * from sales.SalesOrderDetail sod 
join sales.SalesOrderHeader soh on soh.SalesOrderID = sod.SalesOrderID
where datepart(month,OrderDate) = '05' and datepart(year, OrderDate) = '2011';


--d. Get the total sales made in May 2011
select sum(orderQty * UnitPrice * 1-UnitPriceDiscount ) as total_sales
from sales.SalesOrderDetail sod 
join sales.SalesOrderHeader soh on soh.SalesOrderID = sod.SalesOrderID
where datepart(month,OrderDate) = '05' and datepart(year, OrderDate) = '2011';

--e. Get the total sales made in the year 2011 by month order by increasing sales
select datepart(year,OrderDate) as Year, datepart(month,OrderDate) as month, sum(orderQty * UnitPrice * 1-UnitPriceDiscount ) as total_sales
from sales.SalesOrderDetail sod 
join sales.SalesOrderHeader soh on soh.SalesOrderID = sod.SalesOrderID
where  datepart(year, OrderDate) = '2011'
group by datepart(year,OrderDate), datepart(month,OrderDate)
order by sum(orderQty * UnitPrice * 1-UnitPriceDiscount ) asc;

--f. Get the total sales made to the customer with FirstName = 'Gustavo' and LastName = 'Achong'
select sum(orderQty * UnitPrice * 1-UnitPriceDiscount +TaxAmt) as total_sales from sales.SalesOrderDetail sod
join sales.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
join person.person p on p.BusinessEntityID = soh.CustomerID
where FirstName = 'Gustavo' and LastName = 'Achong';

select * from sales.SalesOrderDetail;
select * from sales.SalesOrderHeader where rowguid= 'D4C132D3-FCB5-4231-9DD5-888A54BEC693';
select * from sales.SalesOrderHeader  where AccountNumber = 'AW00000291';

select * from sales.customer where CustomerID = 291; -- AccountNumber AW00000291
select * from person.person where FirstName = 'Gustavo' and LastName = 'Achong'; -- businessEntityID -- 291
select * from sales.SalesOrderDetail where rowguid= 'D4C132D3-FCB5-4231-9DD5-888A54BEC693'; 
 -- rowguid -- 'D4C132D3-FCB5-4231-9DD5-888A54BEC693'
