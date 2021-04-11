# https://www.c-sharpcorner.com/blogs/a-scenario-based-sql-interview-queries-test-modeltraining
# https://www.complexsql.com/real-time-scenarios-in-sql-queries/
# https://www.toptal.com/sql/interview-questions
# https://www.java-success.com/%E2%99%A6-sql-scenarios-based-interview-questions-answered/

use org;

select * from worker;

select first_name as worker_name from worker;

select upper(first_name) from worker;

select distinct(department) from worker;

select substring(first_name,1,3) from worker; # first 3 character from name

Select INSTR(FIRST_NAME, BINARY'a') from Worker where FIRST_NAME = 'Amitabh'; # find out position of a in amitabh

Select LTRIM(DEPARTMENT) from Worker;
Select RTRIM(DEPARTMENT) from Worker;

select distinct length(department) from worker;

select replace(first_name,'a','A') from worker;

select concat(first_name ," ", last_name) as complete_name from worker;

Select * from Worker order by FIRST_NAME asc;

Select * from Worker order by FIRST_NAME asc,DEPARTMENT desc;

select * from worker where first_name in ('Vipul','Satish');

select * from worker where department like "ADMIN%"; # Starts with Admin

Select * from Worker where FIRST_NAME like '%a%'; # contains a in first name

Select * from Worker where FIRST_NAME like '_____h'; # ends with h and contains 6 alphabets only

Select * from Worker where SALARY between 100000 and 500000; # lies between two range

Select * from Worker where year(JOINING_DATE) = 2014 and month(JOINING_DATE) = 2;

select concat(first_name ," ", last_name) as worker_name, salary from worker where salary between 50000 and 100000;

select count(WORKER_ID) No_Of_Workers, department from worker group by department order by No_Of_Workers; ## Important query .... fetch the no. of workers for each department in the descending order

select DISTINCT W.FIRST_NAME, T.WORKER_TITLE from worker w inner join title t on w.worker_id = t.WORKER_REF_ID where worker_title = "Manager"; # print details of the Workers who are also Managers.

SELECT WORKER_TITLE, AFFECTED_FROM, COUNT(*)
FROM Title
GROUP BY WORKER_TITLE, AFFECTED_FROM
HAVING COUNT(*) > 1; # duplicates 

SELECT * FROM Worker WHERE MOD(WORKER_ID, 2) <> 0; # odd rows

select * into workerclone from worker; # create new table from existing table.

SELECT * INTO WorkerClone FROM Worker WHERE 1 = 0; # Only structure

CREATE TABLE WorkerClone LIKE Worker; # In Mysql

SELECT * FROM Worker 
INTERSECT 
SELECT * FROM WorkerClone; # INtersection of two tables

SELECT * FROM Worker
MINUS
SELECT * FROM Title;

SELECT * FROM Worker ORDER BY Salary DESC LIMIT 10; # top 10 records

-- SELECT TOP 10 * FROM Worker ORDER BY Salary DESC; # SQL Server

-- SELECT * FROM (SELECT * FROM Worker ORDER BY Salary DESC) WHERE ROWNUM <= 10; # Works in oracle

SELECT first_name , Salary FROM Worker ORDER BY Salary DESC LIMIT 4,1; # limit n-1, 1  2nd highest salary

SELECT Salary FROM Worker W1 WHERE 4 = (SELECT COUNT( DISTINCT ( W2.Salary ) ) FROM Worker W2 WHERE W2.Salary >= W1.Salary); # 2nd highest salary

select w1.worker_id, w1.first_name, w1.salary from worker w1, worker w2 where w1.salary = w2.salary and w1.worker_id != w2.worker_id; # Same salary

Select max(Salary) from Worker where Salary not in (Select max(Salary) from Worker); # second max salary

# show one row twice in results from a table

select FIRST_NAME, DEPARTMENT from worker W where W.DEPARTMENT='HR' 
union all 
select FIRST_NAME, DEPARTMENT from Worker W1 where W1.DEPARTMENT='HR';

SELECT * FROM WORKER WHERE WORKER_ID <= (SELECT count(WORKER_ID)/2 from Worker); # first 50% records.

SELECT DEPARTMENT, COUNT(WORKER_ID) as 'Number of Workers' FROM Worker GROUP BY DEPARTMENT HAVING COUNT(WORKER_ID) < 5; # fetch the departments that have less than five people in it

SELECT DEPARTMENT, COUNT(DEPARTMENT) as 'Number of Workers' FROM Worker GROUP BY DEPARTMENT; # No of people in department

Select * from Worker where WORKER_ID = (SELECT max(WORKER_ID) from Worker); # for last record

Select * from Worker where WORKER_ID = (SELECT min(WORKER_ID) from Worker); # to get first row

SELECT * FROM Worker WHERE WORKER_ID <=5
UNION
SELECT * FROM (SELECT * FROM Worker W order by W.WORKER_ID DESC) AS W1 WHERE W1.WORKER_ID <=5; # fetch the last five records from a table

SELECT t.DEPARTMENT,t.FIRST_NAME,t.Salary from(SELECT max(Salary) as TotalSalary,DEPARTMENT from Worker group by DEPARTMENT) as TempNew 
Inner Join Worker t on TempNew.DEPARTMENT=t.DEPARTMENT 
 and TempNew.TotalSalary=t.Salary; # print the name of employees having the highest salary in each department

SELECT distinct Salary from worker a WHERE 3 >= (SELECT count(distinct Salary) from worker b WHERE a.Salary <= b.Salary) order by a.Salary desc; # fetch 3 maximum salary

SELECT DEPARTMENT, sum(Salary) from worker group by DEPARTMENT; # fetch departments along with the total salaries paid for each of them

