-- Doubts:  8, 11, 
-- 1. Find out the selling cost average for packages developed in Pascal. 
select round(avg(scost * sold), 2)  as average_selling_cost_pascal
from Software
where developin = 'PASCAL';

-- 2. Display the names and ages of all programmers. 
select pname, datediff(year, dob, getdate()) as Age 
from programmer;

-- 3. Display the names of those who have done the DAP Course. 
select distinct(pname) as pname from Studies where course= 'DAP';

-- 4. Display the names and date of birth of all programmers born in January. 
Select pname, dob from Programmer 
where datepart(month, dob) = '01';

-- 5. What is the highest number of copies sold by a package? 
select max(sold) as max_sold_copies_by_a_package from Software;
select top 1 sold from Software order by sold desc;
select * from Software where sold = (select max(sold) from software);

-- 6. Display lowest course fee. 
select min(course_fee) as lowest_course_fee from Studies;

-- 7. How many programmers have done the PGDCA Course? 
Select count(*) as no_programmers_pgdca from Studies where course='PGDCA';

-- 8. How much revenue has been earned through sales of packages developed in C? Answer:
Select (sum(scost * SOLD)  - sum(dcost)) as revenue 
from Software     -- group by DEVELOPIN;
Where developin = 'C';

-- 9. Display the details of the software developed by Ramesh. 
select * from Software where PNAME = 'RAMESH';

-- 10. How many programmers studied at Sabhari? 
select distinct(pname) as no_programmers_Studied_at_Sabhari 
from Studies 
where institute = 'SABHARI';

-- 11. Display details of packages whose sales crossed the 2000 mark. 
select developin, sum(scost*sold) as total_sales from Software 
group by developin
having sum(scost*sold) > 2000;

-- 12. Display the details of packages for which development costs have been recovered.
Select developin, (sum(scost * SOLD)  - sum(dcost)) as revenue 
from Software 
group by DEVELOPIN
having (sum(scost * SOLD)  - sum(dcost)) > 0 ;

-- 13. What is the cost of the costliest software development in Basic?
Select max(dcost) from Software where developin='BASIC' 

-- 14. How many packages have been developed in dBase?
Select count(*) as no_packages_developed_in_dBase 
from Software 
where developin  = 'DBASE';

-- 15. How many programmers studied in Pragathi?
select count(*)  as number_of_studets_in_pragathi from Studies 
where INSTITUTE = 'PRAGATHI';

-- 16. How many programmers paid 5000 to 10000 for their course?
select count(distinct pname) from Studies 
where course_fee between 5000 and 10000;

-- 17. What is the average course fee?
Select avg(course_fee) as average_course_fee from Studies;

-- 18. Display the details of the programmers knowing C.
Select * from Programmer
Where prof1 ='C' or prof2='C';

-- 19. How many programmers know either COBOL or Pascal?
Select sum(case when prof1='COBOL' or prof1= 'PASCAL' then 1 else 0 end) +
		sum(case when prof2='COBOL' or prof2= 'PASCAL' then 1 else 0 end)  from Programmer ;

-- 20. How many programmers don’t know Pascal and C?
-- do not know c or pascal or both:
Select * from Programmer  
where not( (prof1='PASCAL' or prof2='PASCAL') or (prof1='C' or prof2='C') ) ;

-- both pascal and C not known: 
Select * from Programmer  
where not( (prof1='PASCAL' or prof2='PASCAL') and (prof1='C' or prof2='C') ) ;

-- 21. How old is the oldest male programmer?
Select top 1 *, datediff(year, dob, getdate()) as age from Programmer 
order by dob ;

-- 22. What is the average age of female programmers?
Select avg(datediff(year, dob, getdate())) as avg_female_programmer_age
from Programmer
where gender ='F';

-- 23. Calculate the experience in years for each programmer and display with their names in descending order.
Select pname, datediff(year, doj, getdate()) as experience_in_years 
from Programmer
order by pname desc;

-- 24. Who are the programmers who celebrate their birthdays during the current month?
Select pname, dob as dob_current_month from Programmer
where datepart(month, dob) = datepart(month, getdate());

-- 25. How many female programmers are there?
Select count(*) as number_of_female_programmers from Programmer
where gender = 'F';

-- 26. What are the languages studied by male programmers?
select distinct(prof1) as languages_studied_by_male from Programmer 
where gender = 'M'
union 
select distinct(prof2)  as languages_studied_by_male from Programmer 
where gender = 'M';

-- 27. What is the average salary?
Select avg(salary) as average_salary from Programmer;

-- 28. How many people draw a salary between 2000 to 4000?
select count(*) as count_of_people_sal_between_2k_to_4k
from Programmer 
where salary between 2000 and 4000;

-- 29. Display the details of those who don’t know Clipper, COBOL or Pascal.
Select * from Programmer
where not( prof1  in ('Clipper', 'COBOL', 'Pascal') or prof2  in ('Clipper', 'COBOL', 'Pascal'));

-- 30. Display the cost of packages developed by each programmer.
Select pname, sum(DCOST) as cost_of_packages from Software
group by PNAME
order by pname;

-- 31. Display the sales value of the packages developed by each programmer.
select PNAME, sum(sold*scost) sale_value 
from Software
group by pname;

-- 32. Display the number of packages sold by each programmer.
select PNAME, sum(sold) number_of_packages_sold 
from Software
group by pname
order by pname;

-- 33. Display the sales cost of the packages developed by each programmer language wise.
select PNAME, developin, sum(sold) number_of_packages_sold_langauge_wise
from Software
group by pname, DEVELOPIN
order by pname;

-- 34. Display each language name with the average development cost, average selling cost and average price per copy.
select developin, sum(sold) as number_of_copies, avg(dcost) as avg_development_cost, 
			avg(sold*scost) as avg_selling_cost, 
			case when sum(sold)=0 then avg(sold*scost - dcost) 
				else avg(sold*scost - dcost)/sum(sold) end as avg_price_per_copy  
from Software
group by developin;

-- 35. Display each programmer’s name and the costliest and cheapest packages developed by him or her.
select pname, max(dcost) as costliest, min(dcost) as cheapest from Software
group by pname
order by PNAME;

-- 36. Display each institute’s name with the number of courses and the average cost per course.
select INSTITUTE, count( course) as number_of_courses, avg(course_fee)/count(course) as avg_cost_per_course
from Studies
group by INSTITUTE;

-- 37. Display each institute’s name with the number of students.
select institute, count(distinct pname) as number_of_students 
from Studies
group by INSTITUTE;

-- 38. Display names of male and female programmers along with their gender.
Select pname, gender from Programmer order by gender;

-- 39. Display the name of programmers and their packages.
Select pname, salary from Programmer;

-- 40. Display the number of packages in each language except C and C++.
select developin, count(title) as number_of_packages from Software
where developin not in ('C', 'CPP')
group by developin;

-- 41. Display the number of packages in each language for which development cost is less than 1000.
select developin, count(*) as number_of_packages_in_language
from Software
group by developin
having sum(dcost) < 1000;

-- 42. Display the average difference between SCOST and DCOST for each package.
select avg(scost*sold) - avg(dcost) as average_difference from Software;

--  43. Display the total SCOST, DCOST and the amount to be recovered for each programmer whose cost has not yet been recovered.
select pname, -(sum(scost*sold)-sum(dcost)) as amount_to_be_recovered from Software 
group by PNAME
having (sum(scost*sold)-sum(dcost)) < 0;

-- 44. Display the highest, lowest and average salaries for those earning more than 2000.
Select max(salary) as highest_salary, min(salary) as lowest_salary, 
		avg(salary) as avg_salary  from Programmer
where salary >= 2000;

-- 45. Who is the highest paid C programmer?
Select top 1 * from Programmer
where prof1='C' or prof2='C'
order  by salary desc ;

-- 46. Who is the highest paid female COBOL programmer?
Select top 1 * from Programmer
where (prof1='COBOL' or prof2='COBOL') 
order  by salary desc ;

-- 47. Display the names of the highest paid programmers for each language.
with cte1 as 
(Select prof1 as prof, max(salary)  as max_salary from Programmer group by prof1
union
Select prof2 as prof, max(salary)  as max_salary from Programmer group by prof2 ),
cte2 as (select prof, max(max_salary) as max_salary 
		from cte1
		group by prof) 
select pname, cte2.prof, salary from Programmer, cte2
where (prof1 = cte2.prof or prof2 = cte2.prof)
and salary = cte2.max_salary
order by prof;


-- 48. Who is the least experienced programmer?
Select top 1 * from Programmer
order by doj desc;

-- 49. Who is the most experienced male programmer knowing PASCAL?
Select top 1 * from Programmer
where (prof1 = 'PASCAL'  OR prof2 = 'PASCAL')
order by doj ;

-- 50. Which language is known by only one programmer?
with cte as (select prof1 as prof, pname from programmer 
union 
select prof2 as prof, pname from programmer)
select prof from cte 
group by prof 
having count(prof) =1;

-- 51. Who is the above programmer referred in 50?
with cte1 as (select prof1 as prof, pname from programmer 
union 
select prof2 as prof, pname from programmer),
cte2 as(select prof from cte1 
group by prof 
having count(prof) =1)
select * from Programmer,cte2 where prof1 = cte2.prof or prof2=cte2.prof;

-- 52. Who is the youngest programmer knowing dBase?
select top 1 * from programmer
where prof1='DBASE' or prof2='DBASE'
order by dob desc;

-- 53. Which female programmer earning more than 3000 does not know C, C++, Oracle or dBase?
select * from programmer
where salary > 3000 
	AND (prof1 not in ('C', 'CPP', 'ORACLE', 'DBASE') and prof2 not in ('C', 'CPP', 'ORACLE', 'DBASE'))
	AND GENDER = 'F';

-- 54. Which institute has the most number of students?
select  institute from studies 
group by institute 
having count(*) = (select top 1 count(*) from studies group by institute order by count(*) desc);

-- 55. What is the costliest course?
select top 1 course as costliest_course from studies order by course_fee desc;

-- 56. Which course has been done by the most number of students?
select  course from studies 
group by course 
having count(*) = (select top 1 count(*) from studies group by course order by count(*) desc);

-- 57. Which institute conducts the costliest course?
select top 1 institute as costliest_course_institute 
from studies
order by course_fee desc;

-- 58. Display the name of the institute and the course which has below average course fee.
select institute, course from studies where course_fee < 
(select avg(course_fee) from studies);

-- 59. Display the names of the courses whose fees are within 1000 (+ or -) of the average fee.
with cte as (select avg(course_fee) as avg_course_fee from studies)
select distinct institute, course from Studies, cte
where course_fee between avg_course_fee-1000 and avg_course_fee+1000;

-- 60. Which package has the highest development cost?
select top 1 title from Software order by dcost desc;

-- 61. Which course has below average number of students?
with cte as (select course, count(*) as number_of_students from Studies
group by course)
, cte2 as (select avg(number_of_students) as avg_students from cte )
select course, number_of_students 
from cte, cte2
where number_of_students < avg_students;

-- 62. Which package has the lowest selling cost?
select top 1 title, SCOST from Software
order by scost ;

-- 63. Who developed the package that has sold the least number of copies?
select pname as least_copies_developed_by, * from Software 
where sold = (select min(sold) from Software);

-- 64. Which language has been used to develop the package which has the highest sales amount?
select developin, * from Software
where scost*sold = (select max(scost*sold) from Software);

-- 65. How many copies of the package that has the least difference between development and selling cost were sold?
select sold as copies, * from Software 
where (scost*sold-dcost) = (select min(scost*sold-dcost) from software);

-- 66. Which is the costliest package developed in Pascal?
select top 1 title as costliest_package, * from software 
where developin = 'PASCAL'
order by scost desc;

-- 67. Which language was used to develop the most number of packages?
with cte as (select developin, count(*)  as number_of_packages from Software 
group by developin)
select developin from cte where number_of_packages=
( select  max(number_of_packages) from cte);

-- 68. Which programmer has developed the highest number of packages?
select top 1 pname, count(*) as number_of_packages from Software
group by pname
order by count(*) desc;

-- 69. Who is the author of the costliest package?
select pname from Software where dcost = 
(select max(dcost) from software); 

-- 70. Display the names of the packages which have sold less than the average number of copies.
select title, sold from software where 
sold < (select avg(sold) from software);

-- 71. Who are the authors of the packages which have recovered more than double the development cost?
select pname, (scost*sold - dcost*2) as recovered
from Software
where (scost*sold - dcost*2) > 0;

-- 72. Display the programmer names and the cheapest packages developed by them in each language.
with cte as (select developin, min(dcost) as min_dcost from Software 
group by DEVELOPIN)
select pname, title from Software s, cte c
where s.developin = c.DEVELOPIN and c.min_dcost = s.DCOST;

select * from software order by developin;
-- 73. Display the language used by each programmer to develop the highest selling and lowest selling package.
with cte as (select min(scost) as min_scost, max(scost) as max_scost from software)
, cte2 as (select distinct  (coalesce((case when scost = max_scost then developin end) , '')) as  high_selling_language , 
	  coalesce((case when scost = min_scost then developin end)  , '') as low_selling_language
from software, cte 
where min_scost is not null or max_scost is not null)
select string_agg(high_selling_language, '') as high_selling , string_agg(low_selling_language, '') as low_selling from cte2;

-- 74. Who is the youngest male programmer born in 1965?
select top 1 * from Programmer
where datepart(year, dob) = 1965
and gender = 'm'
order by dob desc;

-- 75. Who is the oldest female programmer who joined in 1992?
select * from Programmer
where datepart(year, doj) = 1992
and gender = 'f'
and doj = (select  min(doj) from Programmer
			where datepart(year, doj) = 1992
	and gender = 'f'); 

-- 76. In which year was the most number of programmers born?
with cte as (select datepart(year, dob) as year_of_birth, count(*) as number_of_programmers 
		from Programmer group by datepart(year, dob)) 
select year_of_birth, number_of_programmers from cte 
	where number_of_programmers=( select max(number_of_programmers )from cte);

-- 77. In which month did the most number of programmers join?
with cte as (select datepart(month, doj) as month_of_joining, count(*) as number_of_programmers 
		from Programmer group by datepart(month, doj)) 
select month_of_joining, number_of_programmers from cte 
	where number_of_programmers=( select max(number_of_programmers )from cte);

-- 78. In which language are most of the programmer’s proficient?
with cte as (select prof1 as prof from programmer union all select prof2 as prof from programmer)
, cte2 as (select prof, count(*) as total from cte group by prof)
select prof from cte2 where total = (select max(total) from cte2);

-- 79. Who are the male programmers earning below the average salary of female programmers?
select * from Programmer
where gender = 'm' and salary < (select avg(salary) from Programmer where gender='f');

-- 80. Who are the female programmers earning more than the highest paid?
select * from Programmer
where gender = 'f' and salary >= (select max(salary) from programmer 
--		where gender = 'm'
		);

-- 81. Which language has been stated as the proficiency by most of the programmers? (same as Q78)
with cte as (select prof1 as prof from programmer union all select prof2 as prof from programmer)
, cte2 as (select prof, count(*) as total from cte group by prof)
select prof from cte2 where total = (select max(total) from cte2);

-- 82. Display the details of those who are drawing the same salary.
with cte as (select salary, count(*) as same_salary_count from programmer group by salary)
select * from programmer, cte where cte.salary= Programmer.salary and same_salary_count >=2;

-- 83. Display the details of the software developed by the male programmers earning more than 3000.
select s.* from programmer
join software s on s.PNAME = Programmer.PNAME
where gender = 'm'
and salary > 3000;

-- 84. Display the details of the packages developed in Pascal by the female programmers.
select s.* from programmer
join software s on s.PNAME = Programmer.PNAME
where gender = 'f'
and DEVELOPIN='PASCAL';

-- 85. Display the details of the programmers who joined before 1990.
select * from programmer
where doj < '01-01-1990';

-- 86. Display the details of the software developed in C by the female programmers at Pragathi.
select s.* from programmer p
join software s on p.pname = s.pname
join studies st on st.pname = p.pname
where gender = 'f' and INSTITUTE = 'Pragathi'
	and DEVELOPIN = 'C';

-- 87. Display the number of packages, number of copies sold and sales value of each programmer institute wise.
select institute, p.pname,  count(title) as number_of_packages,  sum(sold) as copies_sold, sum(scost) as sale_value
from programmer p
join software s on p.pname = s.pname
join studies st on st.pname = p.pname
group by INSTITUTE, p.pname;

-- 88. Display the details of the software developed in dBase by male programmers 
-- who belong to the institute in which the most number of programmers studied.
select * from programmer p
join software s on p.pname = s.pname
join studies st on st.pname = p.pname
where DEVELOPIN= 'DBASE' and GENDER ='M'
	and INSTITUTE = (select top 1 INSTITUTE from studies group by institute order by count(*) desc);

-- 89. Display the details of the software developed by the male programmers
-- born before 1965 and female programmers born after 1975.
select s.* from programmer p
join software s on p.pname = s.pname
where (gender = 'M' and datepart(year, dob) < 1965 ) 
	or (GENDER='F' and datepart(year, dob) > 1975);

-- 90. Display the details of the software that has been developed in the
-- language which is neither the first nor the second proficiency of the programmers.
select s.* from software s 
join programmer p on p.pname = s.pname
where prof1 != DEVELOPIN and prof2 != DEVELOPIN;

-- 91. Display the details of the software developed by the male students at Sabhari.
select s.* from software s 
join programmer p on p.pname = s.pname
join studies st on st.pname = s.pname
where gender='m' and institute = 'Sabhari';

-- 92. Display the names of the programmers who have not developed any packages.
select p.pname 
from programmer p left join software s  on p.pname = s.pname
where s.pname is null;

-- 93. What is the total cost of the software developed by the programmers of Apple?
select sum(dcost)  from software s 
join programmer p on p.pname = s.pname
join studies st on st.pname = s.pname
where institute = 'APPLE';

-- 94. Who are the programmers who joined on the same day?
with cte as (select doj, count(*) as sameday_join from programmer group by doj)
select * from programmer, cte where cte.doj= Programmer.doj and sameday_join >=2;

-- 95. Who are the programmers who have the same Prof2?
with cte as (select prof2, count(*) as same_prof2 from programmer group by prof2)
select * from programmer, cte where cte.prof2= Programmer.prof2 and  same_prof2 >=2;

-- 96. Display the total sales value of the software institute wise.
select institute, sum(scost*sold) as total_sales_value
from software s join studies st on st.pname = s.pname
group by INSTITUTE;

-- 97. In which institute does the person who developed the costliest package study?
select institute from programmer p join studies st on st.pname = p.pname
join software s on s.pname= p.pname
where dcost = (select max(dcost) from software);

-- 98. Which language listed in Prof1, Prof2 has not been used to develop any package?
with cte as (select prof1 as prof from programmer 
union 
select prof2 as prof from programmer)
select prof from cte left join software on cte.prof = software.developin  
where developin is null

-- 99. How much does the person who developed the highest selling package
-- earn and what course did he/she undergo?
select st.pname, course from studies st join software s on s.pname = st.pname
where scost = (select max(scost) from software);

-- 100. What is the average salary for those whose software sales is more than 50,000?
select avg(salary) from programmer where pname in 
(select s.pname from software s
join programmer p on p.pname = s.pname
where scost*sold > 50000);

-- 101. How many packages were developed by students who studied in  institutes that charge the lowest course fee?
select count(*) from software where pname in
(select pname from studies where course_fee = 
		(select min(course_fee) from studies));

-- 102. How many packages were developed by the person who developed the
-- cheapest package? Where did he/she study?
(select st.INSTITUTE, st.pname, count(*) as number_of_packages from software 
join studies st on st.pname = software.pname
where dcost = 
		(select min(dcost) from software) group by st.INSTITUTE, st.pname);

-- 103. How many packages were developed by female programmers earning
-- more than the highest paid male programmer?
select count(*) as number_of_packages_by_female from programmer 
where gender = 'f' and pname in (select pname from programmer where salary 
			> (select max(salary) from programmer where gender = 'm'));

-- 104. How many packages are developed by the most experienced programmers from BDPS?
select count(*) from programmer 
where doj in (select min(doj) from programmer where pname in
	 (select pname from studies where INSTITUTE = 'bdps'));

-- 105. List the programmers (from the software table) and the institutes they studied at.
select s.pname, st.INSTITUTE from software s 
left join studies st on st.pname = s.pname;

-- 106. List each PROF with the number of programmers having that PROF
-- and the number of the packages in that PROF.
with cte as (select prof1 as prof from programmer 
union
select prof2 as prof from programmer)
, cte2 as (select prof, count(*) as  number_of_programmers
from programmer p, cte c where p.prof1=c.prof or p.prof2=c.prof
group by prof)
select prof, number_of_programmers, count(*) as number_of_packages from cte2
join software s on s.DEVELOPIN = cte2.prof
group by prof, number_of_programmers;

-- 107. List the programmer names (from the programmer table) and the number of packages each has developed.
select  p.pname , count(developin) from programmer  p
left join software s on s.pname=p.pname
group by p.pname;

