 ------------------------------------------------------------------------------Summarizing Data with SQL-----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------Summary Statistics---------------------------------------------------------------------------------------------

SELECT *
FROM pets;

--32) How many rows are in the `pets` table?

SELECT count(*) AS numrows
FROM pets;

--33) How many female pets are in the `pets` table?

SELECT Count(*) as numfemale
FROM pets
WHERE sex = 'F';

--34) How many female cats are in the `pets` table?

SELECT Count(*) as numfemalecats
FROM pets
WHERE sex = 'F' AND species = 'cat';

--35) What's the mean age of pets in the `pets` table?

SELECT avg(age) as meanage
FROM pets;

--36) What's the mean age of dogs in the `pets` table?

SELECT avg(age) as meanagedogs
FROM pets
WHERE species = 'dog';

--37) What's the mean age of male dogs in the `pets` table?

SELECT avg(age) as meanagedogs
FROM pets
WHERE species = 'dog' AND sex = 'M';

--38) What's the count, mean, minimum, and maximum of pet ages in the `pets` table?
--    * _NOTE:_ SQLite doesn't have built-in formulas for standard deviation or median!

SELECT count(age) as TotalAnimals, avg(age) AS MeanAnimalAge, min(age) AS MinAnimalAge, max(age) AS MaxAnimalAge 
FROM pets;

--39) Repeat the previous problem with the following stipulations:
--    * Round the average to one decimal place.
--    * Give each column a human-readable column name (for example, "Average Age")

SELECT count(age) as 'Total Animals', round(avg(age),1) AS 'Average Age', min(age) AS 'Min Age', max(age) AS 'Max Age' 
FROM pets;

--40) How many rows in `employees_null` have missing salaries?

SELECT count(*) AS 'Missing Salary'
FROM employees_null
WHERE salary IS NUll;

--41) How many salespeople in `employees_null` having _nonmissing_ salaries?

SELECT count(*) AS 'Not Missing Salary'
FROM employees_null
WHERE salary IS NOT NUll;

--42) What's the mean salary of employees who joined the company after 2010? Go back to the usual `employees` table for this one.
--    * _Hint:_ You may need to use the `CAST()` function for this. To cast a string as a float, you can do `CAST(x AS REAL)`


SELECT AVG(salary) FROM employees
WHERE cast(startdate as datetime) > 2010;

--43) What's the mean salary of employees in Swiss Francs?
--    * _Hint:_ Swiss Francs are abbreviated "CHF" and 1 USD = 0.97 CHF.

select cast(round(avg(cast(salary * 0.97 as CHF)),2) as text) || ' CHF'  as 'Mean salary in Swiss Francs' from employees;

--44) Create a query that computes the mean salary in USD as well as CHF. Give the columns human-readable names (for example "Mean Salary in USD"). Also, format them with comma delimiters and currency symbols.
--    * _NOTE:_ Comma-delimiting numbers is only available for integers in SQLite, so rounding (down) to the nearest dollar or franc will be done for us.
--   * _NOTE2:_ The symbols for francs is simply `Fr.` or `fr.`. So an example output will look like `100,000 Fr.`.

select '$' || printf('%,d' ,avg(salary)) as 'Mean Salary in USD', printf('%,d', avg(cast(salary * 0.97 as CHF))) || ' Fr.' as 'Mean Salary in CHF' from employees;

-----------------------------------------------------------------------------------------Aggregating Statistics with GROUP BY-----------------------------------------------------------------------------------------------------
--45) What is the average age of `pets` by species?

select species, round(avg(age), 2) as 'Average Age' 
from pets
group by species;

--46) Repeat the previous problem but make sure the species label is also displayed! Assume this behavior is always being asked of you any time you use `GROUP BY`.

---I already did that above because it didn't look right> I did not read head while answering the questions.

--47) What is the count, mean, minimum, and maximum age by species in `pets`?

select species, count(species) 'Number of animals', round(avg(age), 2) as 'Mean Age', min(age) as 'Min Age', max(age) as 'Max Age'
from pets
group by species;

--48) Show the mean salaries of each job title in `employees`.

select job as 'Job Type',round(avg(salary), 2)
from employees
group by job;


--49) Show the mean salaries in New Zealand dollars of each job title in `employees`.
--    * _NOTE:_ 1 USD = 1.65 NZD.

select job as 'Job Type', round(avg(cast(salary * 1.65 as NZD)), 2) as 'New Zealand dollars'
from employees
group by job;

--50) Show the mean, min, and max salaries of each job title in `employees`, as well as the numbers of employees in each category.

select job as 'Job Type',round(avg(salary), 2), min(salary) as 'Min salary', max(salary) as 'Max salary', count(job) as 'Number of Job Types'
from employees
group by job;


--51) Show the mean salaries of each job title in `employees` sorted descending by salary.

select job as 'Job Type',round(avg(salary), 2)
from employees
group by job
order by round(avg(salary), 2) desc;

--52) What are the top 5 most common first names among `employees`?

select firstname
from employees
group by firstname
order by count(firstname) desc
limit 5;

--53) Show all first names which have exactly 2 occurrences in `employees`.

select firstname
from employees
group by firstname
having count(firstname) = 2;

--54) Take a look at the `transactions` table to get a idea of what it contains. Note that a transaction may span multiple rows if different items are purchased as part of the same order. 
--The employee who made the order is also given by their ID.

select *
from transactions;

--55) Show the top 5 largest orders (and their respective customer) in terms of the numbers of items purchased in that order.

select order_id, customer
from transactions
group by order_id
order by sum(quantity) desc
limit 5;

--56) Show the total cost of each transaction.
--    * _Hint:_ The `unit_price` column is the price of _one_ item. The customer may have purchased multiple.
--    * _Hint2:_ Note that transactions here span multiple rows if different items are purchased.

select order_id, customer, cast(unit_price * quantity as total_cost) as total_cost
from transactions
group by order_id;

--57) Show the top 5 transactions in terms of total cost.

select order_id, customer, cast(unit_price * quantity as total_cost) as total_cost
from transactions
group by order_id
order by total_cost desc
limit 5;

--58) Show the top 5 customers in terms of total revenue (ie, which customers have we done the most business with in terms of money?)

select customer, sum(cast(unit_price * quantity as total_cost)) as total_revenue
from transactions
group by customer
order by total_revenue desc
limit 5;

--59) Show the top 5 employees in terms of revenue generated (ie, which employees made the most in sales?)

select employee_id ,sum(cast(unit_price * quantity as total_cost)) as total_revenue
from transactions
group by employee_id
order by total_revenue desc
limit 5;

--60) Which customer worked with the largest number of employees?
--    * _Hint:_ This is a tough one! Check out the `DISTINCT` keyword.

select customer, count(employee_id) as 'number of employees'
from transactions
group by customer
order by count(employee_id) desc
limit 1;

--61) Show all customers who've done more than $80,000 worth of business with us.

select customer, sum(cast(unit_price * quantity as total_revenue)) as total_revenue
from transactions
group by customer
having total_revenue > 80000;

