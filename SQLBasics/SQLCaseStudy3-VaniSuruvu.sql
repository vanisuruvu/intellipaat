--Problem Statement:
--You are the database developer of an international bank. You are responsible for managing the bank’s database. You want to use the data to answer a few
--questions about your customers regarding withdrawal, deposit and so on, especially about the transaction amount on a particular date across various
--regions of the world. Perform SQL queries to get the key insights of a customer.
--Dataset:
--The 3 key datasets for this case study are:
--a. Continent: The Continent table has two attributes i.e., region_id and region_name, where region_name consists of different continents such as
--Asia, Europe, Africa etc., assigned with the unique region id. 
--b. Customers: The Customers table has four attributes named customer_id, region_id, start_date and end_date which consists of 3500 records.
--c. Transaction: Finally, the Transaction table contains around 5850 records and has four attributes named customer_id, txn_date, txn_type and txn_amount.--1. Display the count of customers in each region who have done the transaction in the year 2020.
select * from customers;
-- alter table continent alter column region_id int
select * from continent; 
select * from Transaction1;

select region_name, count(distinct c.customer_id) as no_of_customers
from customers c 
join Continent ct on c.region_id = ct.region_id
join transaction1 t on t.customer_id = c.customer_id 
group by region_name;

select distinct customer_id from customers;

--2. Display the maximum and minimum transaction amount of each transaction type.
select txn_type, max(txn_amount) as max_txn_amount, min(txn_amount) as min_txn_amount 
from transaction1 group by txn_type;

--3. Display the customer id, region name and transaction amount where transaction type is deposit and transaction amount > 2000.
select c.customer_id, region_name, txn_amount
from customers c
join transaction1 t on c.customer_id = t.customer_id
join continent ct on c.region_id = ct.region_id
where txn_type = 'deposit' and txn_amount > 200;

--4. Find duplicate records in the Customer table. 
select *
from (
    select c.*, 
        row_number() over(partition by customer_id, region_id, start_date, end_date order by customer_id) rn
    from Customers c
) c
where rn > 1
order by customer_id, region_id, start_date, end_date

--5. Display the customer id, region name, transaction type and transaction amount for the minimum transaction amount in deposit.
select  c.customer_id, region_name, txn_type, txn_amount 
from  transaction1 t 
join customers c on c.customer_id = t.customer_id
join continent ct on c.region_id = ct.region_id
where txn_amount in (select min(txn_amount) from transaction1 where txn_type= 'deposit') 
and txn_date between start_date  and end_date;

--6. Create a stored procedure to display details of customers in the Transaction table where the transaction date is greater than Jun 2020.
create procedure getCustomersAfterJun2020 as 
select distinct t.*
from -- customers c  join 
transaction1 t  -- on c.customer_id = t.customer_id
where txn_date > '06-01-2020'
order by t.customer_id;

exec getCustomersAfterJun2020;

--7. Create a stored procedure to insert a record in the Continent table.
select * from Continent;

create procedure insertContinent as
insert into continent (region_id, region_name) values (6, 'Antarctica')

execute insertContinent

--8. Create a stored procedure to display the details of transactions that happened on a specific day.
create procedure getTransactionByDate( @txnDate date) as 
select * from transaction1 
where txn_date = @txnDate ;

execute getTransactionByDate @txnDate = '2020-10-01'; 

--9. Create a user defined function to add 10% of the transaction amount in a table.
select * from transaction1; 
create function add10percentAmount (@txnAmount int)  
returns int as 
begin 
return  @txnAmount*1.10 
end

select *, dbo.add10percentAmount( txn_amount ) from transaction1 ;

--10. Create a user defined function to find the total transaction amount for a given transaction type.
create function totalAmount (@txnType varchar(50))  
returns int as 
begin  
declare @output int
set @output = (select sum(txn_amount) from transaction1 where txn_type = @txnType);
return @output
end

select dbo.totalAmount('deposit');

--11. Create a table value function which comprises the columns 
--    customer_id, region_id ,txn_date , txn_type , txn_amount which will retrieve data from the above table.
create or alter function getTable() 
returns table as  
return 
	select distinct t.customer_id, ct.region_id, t.txn_date, t.txn_type, t.txn_amount
	from transaction1 t 
	left join customers c on c.customer_id = t.customer_id
	join continent ct on ct.region_id = c.region_id
	where txn_date between start_date and end_date
--	order by t.customer_id
select * from getTable();

--12. Create a TRY...CATCH block to print a region id and region name in a single column.
begin try 
	select concat(region_id, region_name ) as Region
	from Continent 
end try
begin catch
	print error_message()
end catch

--13. Create a TRY...CATCH block to insert a value in the Continent table.
begin try 
begin transaction 
	insert into continent (region_id, region_name) values (7, 'New Continent')
	commit transaction
end try
begin catch
	print error_message()
	rollback transaction
end catch

--14. Create a trigger to prevent deleting a table in a database.
IF EXISTS(SELECT * FROM sys.triggers WHERE NAME = N'Tr_DropTableSecurity' AND PARENT_CLASS_DESC = N'DATABASE')
BEGIN
	print 'hello'
	DROP TRIGGER Tr_DropTableSecurity
	ON DATABASE
END
GO
--  https://www.c-sharpcorner.com/article/prevent-tables-from-being-created-dropped-or-altered-in-sql-server/ 
create trigger tr_preventDeleteTable 
on database
for drop_table
as
begin
	PRINT 'You should ask your DBA or disable the trigger ''tr_preventDeleteTable'' to drop the table!'
	ROLLBACK TRANSACTION
end
go

enable TRIGGER tr_preventDeleteTable
ON DATABASE
GO

create table test (id int)
drop table test
go

disable TRIGGER tr_preventDeleteTable
ON DATABASE
GO

--15. Create a trigger to audit the data in a table.
create table tblOrders
(
  OrderID integer Identity(1,1) primary key,
  OrderApprovalDateTime datetime,
  OrderStatus varchar(20)
)

create table tblOrdersAudit
(
  OrderAuditID integer Identity(1,1) primary key,
  OrderID integer,
  OrderApprovalDateTime datetime,
  OrderStatus varchar(20),
  UpdatedBy nvarchar(128),
  UpdatedOn datetime
)
go
  
create trigger tblTriggerAuditRecord on tblOrders
after update, insert, delete
as
begin
  insert into tblOrdersAudit 
  (OrderID, OrderApprovalDateTime, OrderStatus, UpdatedBy, UpdatedOn )
  select i.OrderID, i.OrderApprovalDateTime, i.OrderStatus, SUSER_SNAME(), getdate() 
  from  tblOrders t 
  inner join inserted i on t.OrderID=i.OrderID 
end
go

insert into tblOrders values (NULL, 'Pending')
go

select * from tblOrders
select * from tblOrdersAudit

update tblOrders 
set OrderStatus='Approved', 
OrderApprovalDateTime=getdate()  
where OrderID=1
go

select * from tblOrders
select * from tblOrdersAudit order by OrderID, OrderAuditID
go

delete from tblOrders where orderId = 2
go

select * from tblOrders
select * from tblOrdersAudit order by OrderID, OrderAuditID
go


--16. Create a trigger to prevent login of the same user id in multiple pages.
-- PLEASE CLARIFY IF THIS IS CORRECT 
-- or if it needs to be worked on a login table for a website?
CREATE OR ALTER TRIGGER trgLoginConnection 
ON ALL SERVER WITH EXECUTE AS N'sa'  
FOR LOGON  
AS  
BEGIN  
IF ORIGINAL_LOGIN() = N'sa' AND  
    (SELECT COUNT(*) FROM sys.dm_exec_sessions  
            WHERE is_user_process = 1 AND  
                original_login_name = N'sa') > 100000  
			ROLLBACK;  
END;

--17. Display top n customers on the basis of transaction type.
with cte as (select *, DENSE_RANK() over(partition by txn_type order by txn_amount desc) as drank from transaction1 )select distinct c.*, t.txn_type, t.txn_amount, drank from cte left join transaction1 t on t.txn_amount =cte.txn_amount and t.customer_id= cte.customer_idleft join customers c on c.customer_id = t.customer_idwhere drank <= 5 and t.txn_date between start_date and end_dateorder by t.txn_type, t.txn_amount;--18. Create a pivot table to display the total purchase, withdrawal and deposit for all the customers.use Aug27select txn_type, sum(txn_amount) as total from transaction1group by txn_typeSelect 'total' As TotalCost,[withdrawal],[deposit],[purchase]
from (
Select txn_type,txn_amount
From transaction1
) As SourceTbl
Pivot
(
sum(txn_amount)
for txn_type in ([withdrawal],[deposit],[purchase])
) As PvtTbl

