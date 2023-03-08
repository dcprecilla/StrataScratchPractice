/*Question: ID 10171
Difficulty: Hard

Postgresql SQL Dialect

Question: 
Find the genre of the person with the most number of oscar winnings.
If there are more than one person with the same number of oscar wins, 
return the first one in alphabetic order based on their name. Use the names as keys when joining the tables.

Table1: oscar_nominees
---------------------------
year:       | int
category:   | varchar
nominee:    | varchar
movie:      | varchar
winner:     | bool
id:         | int
---------------------------

Table2: nominee_information
---------------------------
name:            |varchar
amg_person_id:   |varchar
top_genre:       |varchar
birthday:        |datetime
id:              |int
-----------------------------


Query:*/

with winner as(
select 
nominee,
count(*) as wins
from oscar_nominees
where winner = TRUE
group by 1
order by 2 desc,1 asc),
oscar_rank as(
select
*,
rank() over(order by wins desc, nominee asc) as ranking
from winner)
select
i.top_genre
from nominee_information as i 
inner join oscar_rank as r 
on i.name = r.nominee
where r.ranking = 1;

/*Results:
Drama
*/
------------------------------------------------------------------------------------------------------
/*Question ID: ID 10145

Question: Make a pivot table to find the highest payment in each year for each employee.
Find payment details for 2011, 2012, 2013, and 2014.
Output payment details along with the corresponding employee name.
Order records by the employee name in ascending order

Table1: sf_public_salaries

id:   int
employeename:   varchar
jobtitle:   varchar
basepay:    float
overtimepay:    float
otherpay:   float
benefits:   float
totalpay:   float
totalpaybenefits:   float
year:   int
notes:  datetime
agency: varchar
status: varchar

Query: */

select 
employeename,
MAX(CASE WHEN year = 2011 then totalpay else 0 end) as pay_2011,
MAX(CASE WHEN year = 2012 then totalpay else 0 end) as pay_2012,
MAX(CASE WHEN year = 2013 then totalpay else 0 end) as pay_2013,
MAX(CASE WHEN year = 2014 then totalpay else 0 end) as pay_2014
from sf_public_salaries
group by 1
order by 1 asc;

/*Results:
employeename	    pay_2011	pay_2012	pay_2013	pay_2014
Aaron Schmidt	      0	        91903.92	  0	        0
Adina M Diamond 	  0	          0	        0	    58496.19
Alan K Tolbert	    0 	        0	        0	    2070.29
Alexander M Lamond	0	          0	        0	    106319.44
Alicia Brown	      0	          2386.55	  0 	      0
*/

------------------------------------------------------------------------------------------------------
/*Question ID: ID 9855

Question: Find the 5th highest salary without using TOP or LIMIT.

Table: worker
worker_id: int
first_name: varchar
last_name: varchar
salary: int
joining_date: datetime
department: varchar

Query: */
with ranks as(
select 
worker_id,
salary,
rank() over(order by salary desc) as ranking 
from worker)
select
salary 
from ranks 
where ranking = 5

/*Results:
100000
*/
------------------------------------------------------------------------------------------------------
/*Question ID: ID 10017
Question: Find how the number of drivers that have churned changed in each year compared to the previous one. 
Output the year (specifically, you can use the year the driver left Lyft) along with the corresponding number of churns in that year, 
the number of churns in the previous year, and an indication on whether the number has been increased (output the value 'increase'), 
decreased (output the value 'decrease') or stayed the same (output the value 'no change').

Tables: lyft_drivers

Query: */
with churners as(
select 
extract(year from end_date) as year_driver_churned,
count(*) churned
from lyft_drivers
where end_date is not null
group by 1),
lags as(
select
year_driver_churned,
churned,
COALESCE(LAG(churned) over(order by year_driver_churned),0) as prev_churn_count 
from churners)
select
*,
CASE WHEN churned > prev_churn_count THEN 'increase'
    WHEN churned < prev_churn_count THEN 'decrease'
    ELSE 'no change'
    END as comments
from lags;

/*Results:
year_driver_churned	        churned	          prev_churn_count	      comments
2015	                        5	                   0	                increase
2016	                        5	                  5                 	no change
2017	                        8                  	5	                  increase
2018	                        25	                8	                  increase
2019                      	    7	                 25	               decrease

------------------------------------------------------------------------------------------------------
/*Question ID: ID 10013
Question: Find the advertising channel with the smallest maximum yearly spending that still brings in more than 1500 customers each year.

Table: uber_advertising

Query: */
with ads as(
select
advertising_channel,
SUM(money_spent) as total_money
from uber_advertising
group by 1
HAVING MIN(customers_acquired) >= 1500
ORDER BY 2 asc
LIMIT 1)
select
advertising_channel
from ads;

/*Results:
advertising_channel
tv
*/
------------------------------------------------------------------------------------------------------
/*Question ID: ID 9983
Question:Find the median total pay for each job. Output the job title and the corresponding total pay, and sort the results from highest total pay to lowest.

Table: sf_public_salaries

Query:*/
select 
jobtitle,
percentile_cont(0.5) WITHIN GROUP(ORDER BY totalpay) as median_salary
from sf_public_salaries
group by 1
order by 2 desc;

/*Results: 
jobtitle	                                        median_salary
GENERAL MANAGER-METROPOLITAN TRANSIT AUTHORITY	       399211.275
CAPTAIN III (POLICE DEPARTMENT)                     	196494.14
SENIOR PHYSICIAN SPECIALIST	                            178760.58

------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2036
Question: Write a query that returns a list of the bottom 2% revenue generating restaurants. Return a list of restaurant IDs and their total revenue from when customers placed orders in May 2020.
You can calculate the total revenue by summing the order_total column. And you should calculate the bottom 2% by partitioning the total revenue into evenly distributed buckets.

Table: doordash_delivery

Query: */
with orders as(
select 
restaurant_id,
sum(order_total) as total
from doordash_delivery
group by 1
order by 2),
ranks as(
select
*,
cume_dist() over(order by total)
from orders)
select
restaurant_id,
total
from ranks
where cume_dist < 0.03;

/* Results:
restaurant_id	total
90	            14.16
26	            14.65
*/
------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2037
Question: Check if there is a correlation between average total order value and average time in minutes between placing the order and delivering the order per restaurant.


Tables: doordash_delivery

Query: */
with avg_time as(
select 
AVG(EXTRACT(epoch from delivered_to_consumer_datetime) - EXTRACT(epoch from customer_placed_order_datetime))::float/60 as avg_time_mins,
avg(order_total) as avg_total
from doordash_delivery
group by restaurant_id)
select
corr(avg_time_mins,avg_total)
from avg_time;

/* Results:
corr
0.859 */

------------------------------------------------------------------------------------------------------









