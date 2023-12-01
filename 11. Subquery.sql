## Subquery

use hello;
Select * from office order by sub_dept;
Select min(emp_salary) from office;

select emp_name, emp_id from office where emp_Salary = 190000;

select  max(Emp_salary) from office;

select emp_name, emp_salary from office 
where emp_salary = 
( select  max(Emp_salary) from office);

select emp_name, emp_salary from office order by emp_salary;


select emp_name, emp_salary, emp_id from office where emp_salary = (Select max(emp_salary) from office);

select emp_name, emp_salary, emp_id from office where emp_salary = (select min(emp_salary) from office);


### Employees having salaries above average salary


select avg(emp_salary) from office;

select * from office where emp_salary > (select avg(emp_salary) from office) order by emp_salary;

## Display employees, where their salary are above average in their specific sub dept. 

select sub_dept, avg(emp_salary) from office group by sub_dept;

## Error as it cannot store the value
select emp_id, emp_name, emp_Salary, sub_dept from office
where emp_salary> (select sub_dept, avg(emp_salary) from office group by sub_dept);



## Correlated subquery  -> works similar to Self join 
## ( But Self join cannot store values) and we are using an aggregate function.

select emp_id, emp_name, emp_Salary, sub_dept from office as a 
where emp_salary>
( select avg(emp_salary) from office 
where sub_dept = a.sub_dept)
order by sub_dept;

## Window function - Over Clause (Partition by/ order by / Combination). Partition by means group by
## same query with avg salary column

select emp_id, emp_name, emp_salary, sub_dept, avg(emp_salary) 
over 
(partition by sub_dept) as avg_Salary 
from office;


## rank function


select * from marks;
create table marks ( id int, score int);

insert into marks values (1,70),(2,77),(3,60),(4,90),(5,77);
select * from marks order by score desc;

select *, rank() 
over
(order by score desc) 
as result from marks;

select *, dense_rank() over(order by score desc) as result from marks;

##  How will you give a dense rank to our office table based on salary


select *, dense_rank() over (order by emp_salary desc) as result from office;

create table sales ( Sales_employee varchar(20), Fin_Year Year(4), sale DEcimal(5,2));

insert into sales values 
("Aman", "2016", 150.00), 
("Aman", "2017", 100.00), 
("Aman", "2018", 200.00),
("Bablu", "2016", 100.00), 
("Bablu", "2017", 150.00),
("Bablu", "2018", 200.00),
("Chintu", "2016", 200.00),
("Chintu", "2017", 150.00),
("Chintu", "2018", 250.00);

select * from sales;




select *, dense_rank() over (partition by fin_year order by sale desc) as rnk from sales; 

select * from office;
select*, dense_rank() over (order by emp_salary desc) as result from office;

## Error
select*, dense_rank() over (order by emp_salary desc) as results from office where results = 5;

## CTE  - Common Table Expression

## CTE works in 3 steps  1) with dummy_name as    2) (original Query)    3) select required columns with the where condition 
## 


with dup as 
(select*, dense_rank() over (order by emp_salary desc) as results from office) 
select * from dup where results = 5;

## Query with the second highest salary based on dept.  ->> based on Partition

with dup as 
(select*, dense_rank() over (partition by sub_dept order by emp_salary desc)
 as results from office) 
 select * from dup where results = 2;


with s as 
(select*, dense_rank() over (partition by sub_dept order by emp_salary desc)
 as rnk from office) 
 select *,rnk from s where rnk in ( 1,3);

## Row NO. function -   Give row number based on salary in descending order.. 

select * from office order by emp_salary;


select *, row_number() over(order by emp_salary desc) as Sr_No from office;


select *, rank() over(order by emp_salary desc) as Rnk from office;
select *, dense_rank() over(order by emp_salary desc) as Results from office;

## Row no based on sub_dept


select *, row_number() over(partition by sub_dept order by emp_salary desc) as Sr_No from office;


## Lead Function

create table trains (Train_id int , station Varchar(20), Arr_Time Time);

insert into trains values
(110, "Pune", "10:00:00"),
(110, "Shivaji Nagar", "10:16:00"),
(110, "Khadki","10:21:00"),
(110, "Dapodi","10:26:00"),
(110, "Kasarwadi", "10:30:00"),
(110, "Pimpri", "10:33:00"),
(120, "Pune", "11:00:00"),
(120, "Shivaji Nagar", "11:16:00"),
(120, "Khadki","11:21:00"),
(120, "Dapodi","11:26:00"),
(120, "Kasarwadi", "11:30:00"),
(120, "Pimpri", "11:33:00");

select * from trains;

select *, lead(Arr_time,1) 
over (partition by train_id) 
as next_station_time 
from trains;


select *, lead(Arr_time,2) over (partition by train_id) as next_station_time from trains;

select *, lag(Arr_time,1) over (partition by train_id) as Last_station_time from trains;


## sub time CTE

with t as 
(select *, lead(Arr_time,1) over (partition by train_id) as next_station_time from trains)
select * ,subtime(next_station_time, Arr_time) as Transit_time from t;






## (Union / union all)- Happens on Row level - It adds rows at the bottom 

create table T2 (id int, Name varchar(20));

create table T3 (id int, Name Varchar(20));

insert into T2 values
(1,"Rocky"),
(2,"Rani"),
(3,"Bunty"),
(4,"bubli");

insert into T3 values
(1,"rocky"),
(2,"Thakur"),
(3, "gabbar"),
(5,"Veeru"),
(6,"Basanti");

select * from T2;
select * from T3;

Select * from T2 union select * from T3;
Select * from T2 union all select * from T3;


################################################################ END ######################################################

