--Simple Queries:
select * from employee;
select * from location;
select * from department;
select * from job;
--1. List all the employee details.
select * from employee;

--2. List all the department details.
select * from department;

--3. List all job details.
select * from job;

--4. List all the locations.
select * from location;

--5. List out the First Name, Last Name, Salary, Commission for all Employees.
select first_name, last_name, SALARY, COMM from employee;

--6. List out the Employee ID, Last Name, Department ID for all employees and alias
--Employee ID as "ID of the Employee", Last Name as "Name of the Employee", Department ID as "Dep_id".
select EMPLOYEE_ID as "ID of the Employee", LAST_NAME as "Name of the Employee", DEPARTMENT_ID as "Dep_id" from employee;

--7. List out the annual salary of the employees with their names only.
select CONCAT_WS(' ', FIRST_NAME, MIDDLE_NAME, LAST_NAME) as Full_Name, salary from employee;
--------------------------------------------------------------------------------------------------------------------------------------------------
--WHERE Condition:
--1. List the details about "Smith".
select * from employee where CONCAT_WS(' ', FIRST_NAME, MIDDLE_NAME, LAST_NAME)  like '%Smith%' ;

--2. List out the employees who are working in department 20.
select * from employee where DEPARTMENT_ID = 20; 

--3. List out the employees who are earning salaries between 3000 and4500.
select * from employee where salary between 3000 and 4500; 

--4. List out the employees who are working in department 10 or 20.
select * from employee where DEPARTMENT_ID in (10, 20);

--5. Find out the employees who are not working in department 10 or 30.
select * from employee where DEPARTMENT_ID not in (10, 20);

--6. List out the employees whose name starts with 'S'.
select * from employee where FIRST_NAME like 'S%' or LAST_NAME like 'S%';

--7. List out the employees whose name starts with 'S' and ends with 'H'.
select * from employee where LAST_NAME like 'S%H';

--8. List out the employees whose name length is 4 and start with 'S'.
select * from employee where LAST_NAME like 'S%' and len(Last_name) = 4;

--9. List out employees who are working in department 10 and draw salaries more than 3500.
select * from employee where DEPARTMENT_ID = 10 and SALARY > 3500;

--10. List out the employees who are not receiving commission.
select * from employee where comm is null or comm < 0;
--------------------------------------------------------------------------------------------------------------------------------------------------
--ORDER BY Clause:
--1. List out the Employee ID and Last Name in ascending order based on the Employee ID.
select EMPLOYEE_ID, LAST_NAME from employee order by EMPLOYEE_ID asc;

--2. List out the Employee ID and Name in descending order based on salary.
select EMPLOYEE_ID, CONCAT_WS(' ', FIRST_NAME, MIDDLE_NAME, LAST_NAME) as Name from employee  
order by salary desc;

--3. List out the employee details according to their Last Name in ascending-order.
select * from employee order by LAST_NAME asc;

--4. List out the employee details according to their Last Name in ascending order and then Department ID in descending order.
select * from employee order by LAST_NAME asc, DEPARTMENT_ID desc;
--------------------------------------------------------------------------------------------------------------------------------------------------
--GROUP BY and HAVING Clause:
--1. How many employees are in different departments in the organization?
select DEPARTMENT_ID, count(1) from employee 
group by DEPARTMENT_ID; 

--2. List out the department wise maximum salary, minimum salary and average salary of the employees.
select DEPARTMENT_ID, max(salary) as max_salary, min(salary) as min_salary, avg(salary) as avg_salary 
from employee 
group by DEPARTMENT_ID;

--3. List out the job wise maximum salary, minimum salary and average salary of the employees.
select job_id, max(salary), max(salary) as max_salary, min(salary) as min_salary, avg(salary) as avg_salary
from employee 
group by job_id

--4. List out the number of employees who joined each month in ascending order.
select datepart(month, hire_date) as joined_month, count(1) as number_of_employees
from employee 
group by datepart(month, hire_date) 
order by joined_month asc;

--5. List out the number of employees for each month and year in ascending order based on the year and month.
select datepart(year, hire_date) as joined_year, datepart(month, hire_date) as joined_month,  count(1) as no_of_employees 
from employee 
group by datepart(year, hire_date), datepart(month, hire_date) 
order by joined_year, joined_month;

--6. List out the Department ID having at least four employees.
select DEPARTMENT_ID, count(1) as no_of_employees 
from employee
group by DEPARTMENT_ID
having count(1) >=4;

--7. How many employees joined in the month of January?
select datepart(month, hire_date) as joined_month, count(1) as no_of_employees
from employee
group by datepart(month, hire_date) 
having datepart(month, hire_date) = '01';

--8. How many employees joined in the month of January or September?
select datepart(month, hire_date) as joined_month, coalesce(count(1),0) as no_of_employees
from employee
group by datepart(month, hire_date) 
having datepart(month, hire_date) in ('01','09');

--9. How many employees joined in 1985?
select datepart(year, hire_date) as joined_year, count(1) as no_of_employees
from employee
group by datepart(year, hire_date) 
having datepart(year, hire_date) = '1985';

--10. How many employees joined each month in 1985?
select datepart(year, hire_date) as joined_year, datepart(month, hire_date) as joined_month, count(1) as no_of_employees
from employee
group by datepart(year, hire_date), datepart(month, hire_date)
having datepart(year, hire_date) = '1985';

--11. How many employees joined in March 1985?
select datepart(year, hire_date) as joined_year, datepart(month, hire_date) as joined_month, count(1) as no_of_employees
from employee
group by datepart(year, hire_date), datepart(month, hire_date)
having datepart(year, hire_date) = '1985' and datepart(month, hire_date) = '03';

--12. Which is the Department ID having greater than or equal to 3 employees joining in April 1985?
select department_id, datepart(year, hire_date) as joined_year, datepart(month, hire_date) as joined_month, count(1) as no_of_employees
from employee
group by department_id, datepart(year, hire_date), datepart(month, hire_date)
having datepart(year, hire_date) = '1985' and datepart(month, hire_date) = '04' and count(1) >=3;

--------------------------------------------------------------------------------------------------------------------------------------------------
--Joins:
--1. List out employees with their department names.
select e.*, d.name from EMPLOYEE e join DEPARTMENT d on e.DEPARTMENT_ID = d.Department_Id;

--2. Display employees with their designations.
select employee.*, j.designation from EMPLOYEE
join job j on j.job_id = employee.job_id;

--3. Display the employees with their department names and regional groups.
select e.*, d.name,  l.City
from employee e join DEPARTMENT d on e.DEPARTMENT_ID = d.Department_Id
join LOCATION l on l.Location_ID = d.location_id;

--4. How many employees are working in different departments? Display with department names.
select name, count(1) from employee e
full outer join DEPARTMENT d  on e.DEPARTMENT_ID = d.Department_Id 
group by name;

--5. How many employees are working in the sales department?
select count(*) as no_of_employees from employee e
join DEPARTMENT d  on e.DEPARTMENT_ID = d.Department_Id 
where name = 'Sales';

--6. Which is the department having greater than or equal to 5 employees? Display the department names in ascending order.
select d.Department_Id, count(*) as no_of_employees  from employee e 
full outer join DEPARTMENT d on d.Department_Id = e. DEPARTMENT_ID
group by d.Department_Id 
having count(*) > = 5;

--7. How many jobs are there in the organization? Display with designations.
select distinct j.job_id, Designation from employee e 
full outer join job j on j.Job_ID = e.JOB_ID;

--8. How many employees are working in "New York"?
select count(*) as number_of_employees from employee e 
join DEPARTMENT d on d.Department_Id = e. DEPARTMENT_ID
join location l  on l.Location_ID = d.Department_Id
where city = 'New York';

--9. Display the employee details with salary grades. Use conditional statement to create a grade column.
select *, case when salary <1000 then 'Low Salary'
			when salary < 2000 then 'Medium Salary'
			when salary > 2000 then 'High Salary' end as Salary_Grade
from employee;

--10. List out the number of employees grade wise. Use conditional statement to create a grade column.
with cte as (select EMPLOYEE_ID,  case when salary <1000 then 'Low Salary'
			when salary < 2000 then 'Medium Salary'
			when salary > 2000 then 'High Salary' end as Salary_Grade
from employee)
select Salary_Grade, count(*) as no_of_employees
from cte join EMPLOYEE on cte.EMPLOYEE_ID = EMPLOYEE.EMPLOYEE_ID
group by Salary_Grade;

--11. Display the employee salary grades and the number of employees between 2000 to 5000 range of salary.
with cte as (select EMPLOYEE_ID,  case when salary <1000 then '<1000'
			when salary < 2000 then '1000 and 2000'
			when salary > 2000 then '2000 and 5000'
			when salary > 5000 then 'High Salary' end as Salary_Grade
from employee)
select Salary_Grade, count(*) as no_of_employees
from cte join EMPLOYEE on cte.EMPLOYEE_ID = EMPLOYEE.EMPLOYEE_ID
group by Salary_Grade;

--12. Display all employees in sales or operation departments.
select * from employee e 
join department d on d.Department_Id =e.DEPARTMENT_ID
where name in('Sales', 'Operations');
--------------------------------------------------------------------------------------------------------------------------------------------------
--SET Operators:
--1. List out the distinct jobs in sales and accounting departments.
select distinct j.Designation as designation from job j 
join employee e on j.Job_ID = e.JOB_ID
join DEPARTMENT d on d.Department_Id = e.DEPARTMENT_ID
where d.name in ('Sales')
UNION
select distinct j.Designation as designation from job j 
join employee e on j.Job_ID = e.JOB_ID
join DEPARTMENT d on d.Department_Id = e.DEPARTMENT_ID
where d.name in ('Accounting');

--2. List out all the jobs in sales and accounting departments.
select j.Designation from job j 
join employee e on j.Job_ID = e.JOB_ID
join DEPARTMENT d on d.Department_Id = e.DEPARTMENT_ID
where d.name in ('Sales')
UNION ALL
select j.Designation from job j 
join employee e on j.Job_ID = e.JOB_ID
join DEPARTMENT d on d.Department_Id = e.DEPARTMENT_ID
where d.name in ('Accounting');

--3. List out the common jobs in research and accounting departments in ascending order.
select distinct j.Designation from job j 
join employee e on j.Job_ID = e.JOB_ID
join DEPARTMENT d on d.Department_Id = e.DEPARTMENT_ID
where d.name in ('Research')
INTERSECT
select distinct j.Designation from job j 
join employee e on j.Job_ID = e.JOB_ID
join DEPARTMENT d on d.Department_Id = e.DEPARTMENT_ID
where d.name in ('Accounting')
Order by j.Designation asc;

--------------------------------------------------------------------------------------------------------------------------------------------------
--Subqueries:
--1. Display the employees list who got the maximum salary.
select * from employee where salary = (select max(salary) from employee);

--2. Display the employees who are working in the sales department.
select * from employee where DEPARTMENT_ID = (select DEPARTMENT_ID from DEPARTMENT where name = 'Sales');

--3. Display the employees who are working as 'Clerk'.
select * from employee where job_id = (select job_id from job where Designation = 'Clerk');

--4. Display the list of employees who are living in "New York".
select * from employee where DEPARTMENT_ID in (select Department_Id from department where Location_Id in 
				(select location_id  from location where city = 'New York'));

--5. Find out the number of employees working in the sales department.
select count(*) as number_of_employees 
from employee where DEPARTMENT_ID in (select DEPARTMENT_ID from DEPARTMENT where name = 'Sales');

--6. Update the salaries of employees who are working as clerks on the basis of 10%.
begin transaction
update employee set salary = salary*1.1 
where job_id in (select job_id from job where Designation = 'clerk');

select * from employee

rollback transaction

--7. Delete the employees who are working in the accounting department.
begin transaction
delete from employee where DEPARTMENT_ID in (select DEPARTMENT_ID from DEPARTMENT where name = 'Accounting');
select * from employee

rollback transaction

--8. Display the second highest salary drawing employee details.
with cte as (select employee_id, DENSE_RANK() over (order by salary desc) as salary_rank from employee)
select * from employee e join cte on e.EMPLOYEE_ID = cte.EMPLOYEE_ID where salary_rank = 2;

--9. Display the nth highest salary drawing employee details.
with cte as (select employee_id, DENSE_RANK() over (order by salary desc) as salary_rank from employee)
select * from employee e join cte on e.EMPLOYEE_ID = cte.EMPLOYEE_ID where salary_rank = 3;
-- 3rd highest salary drawing employee...

--10. List out the employees who earn more than every employee in department 30.
select * from employee where salary > 
(select max(salary) from employee where DEPARTMENT_ID =30)

--11. List out the employees who earn more than the lowest salary in department.Find out whose department has no employees.
select * from employee where salary > 
(select min(salary) from employee where DEPARTMENT_ID in
	(select d.DEPARTMENT_ID from department d left join employee e on e.DEPARTMENT_ID = d.Department_Id where e.DEPARTMENT_ID is null))

--12. Find out which department has no employees.
select d.* from department d left join employee e  on d.Department_Id = e.DEPARTMENT_ID 
where e.DEPARTMENT_ID is null

--13. Find out the employees who earn greater than the average salary for their department.
select * from employee e where salary > (select avg(salary) from employee g where DEPARTMENT_ID in 
				(select DEPARTMENT_ID from employee h where h.DEPARTMENT_ID =e.DEPARTMENT_ID));
