/*Question ID: ID 10351
Difficulty: Medium

Question: 
Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their activity rank. Order records by the total emails in descending order. Sort users with the same number of emails in alphabetical order.
In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails.

Table: google_gmail_emails
column_name | data type
id:           int
from_user:    varchar
to_user:      varchar
day:          int

Query:*/
select 
from_user,
count(*) as total_emails,
row_number() over(order by count(*) desc, from_user) as row_n 
from google_gmail_emails
group by 1
;


----------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 10315

Question: Write a query that identifies cities with higher than average home prices when compared to the national average. Output the city names.

Table: zillow_transactions
column_name   | data type
id:               int
state:            varchar
city:             varchar
street_address:   varchar
mkt_price:        int

Query: */
Select 
city
from zillow_transactions
group by 1
having avg(mkt_price) > (Select avg(mkt_price) from zillow_transactions);

/*Results: 
city
Mountain View
Santa Clara
San Francisco*/

-------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 10301

Question: Given a list of projects and employees mapped to each project, calculate by the amount of project budget allocated to each employee . 
The output should include the project title and the project budget rounded to the closest integer. Order your list by projects with 
the highest budget per employee first.

Table1: ms_projects
column   | data type
id:         int
title:      varchar
budget:     int

Table2: ms_emp_projects
column     | data type
emp_id:       int
project_id:   int

Query:*/

with base as(
select
p.*,
e.emp_id
from ms_projects as p
join ms_emp_projects as e   
on p.id = e.project_id)
select
title,
round((budget/count(emp_id)::float)::numeric,0) as ratio 
from base
group by 1, budget
order by 2 desc;

/*Results: **First 5 rows only**
tite      | ratio
Project8	  24642
Project49	  24387
Project15 	24058
Project10	  23794
Project19	  22493*/

----------------------------------------------------------------------------------------------------------------------------------

/*Question ID: ID 10030

Question: You have a dataset of wines. Find the total revenue made by each winery and variety that has at least 90 points. Each wine in the winery, variety pair should be at least 90 points in order for that pair to be considered in the calculation.
Output the winery and variety along with the corresponding total revenue. Order records by the winery in ascending order and total revenue in descending order.

Table: winemag_p1
id: int
country: varchar
description: varchar
designation: varchar
points: int
price: float
province: varchar
region_1: varchar
region_2: varchar
variety: varchar
winery: varchar

Query:*/

select winery,
variety,
sum(price) as total_revenue
from winemag_p1
group by 1,2
having min(points) >= 90
order by 1 asc, 3 desc
 ;
 
 /* Please note that the results of this query is long and I only included the first 5 records
 
 Results:
 winery   	        variety	                total_revenue
Aveleda	            Alvarinho	                 13
Bollig-Lehnert	    Riesling	                 27
Boudreaux Cellars	  Cabernet Sauvignon	      100
Ca' du RabajaŠ	     Nebbiolo	                24
Chateau Souverain    Cabernet Sauvignon     	35*/

----------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 10053

Question:
Find the top 5 businesses with the most check-ins.
Output the business id along with the number of check-ins.

Table: yelp_checkin

business_id: varchar
weekday: varchar
hour: datetime
checkins: int

Query:*/
select
* 
from yelp_checkin
order by checkins desc
limit 5;

/*Results: 
business_id	              weekday	hour	checkins
4k3RlMAMd46DZ_JyZU0lMg	     Sat	21:00	137
TkEMlu88OZn9TKZyeY9CJg	      Mon	02:00	39
4p6Wce7Ed707QS2-yQkvZw	      Sat	01:00	31
Ehy00JWQixgoXzisVKhvag	      Wed	01:00	22
ujgpePdD8Q-fP1mPFnw0Qw	      Tue	16:00	17*/

----------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 10070

Question: Find the winning teams of DeepMind employment competition.
Output the team along with the average team score.
Sort records by the team score in descending order.

Table1: google_competition_participants

member_id: int
team_id: int

Table2: google_competition_scores

member_id: int
member_score: float

Query: */
select 
p.team_id as team_id,
AVG(s.member_score) as team_score_sum
from google_competition_participants as p 
inner join google_competition_scores as s 
on p.member_id = s.member_id
group by 1
order by 2 desc;

/*Results:
team_id	 team_score_sum
9	       0.816
4	       0.79
14     	0.786
15     	0.784
10     	0.778
*/

----------------------------------------------------------------------------------------------------------------------------------

/* Question ID: ID 10089

Question: Find the number of customers without an order.

Table1: orders

id:  int
cust_id:   int
order_date:  datetime
order_details: varchar
total_order_cost:  int

Table2: customers
id: int
first_name: varchar
last_name:  varchar
city: varchar
address: varchar
phone_number: varchar

Query: */

select
count(id)
from customers
where id NOT IN (select cust_id
from orders
where customers.id = orders.cust_id)

/* Results:
9
*/

----------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 9876
Question: Find the top two hotels with the most negative reviews.
Output the hotel name along with the corresponding number of negative reviews.
Sort records based on the number of negative reviews in descending order.*/

with negatives as(
select
hotel_name,
count(negative_review) as negative_revs,
rank() over(order by count(negative_review) desc) as rankings
from hotel_reviews
where negative_review <> 'No Negative'
group by 1
order by 2 desc)
select
hotel_name,
negative_revs
from negatives
where rankings <= 2;

------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 10008

Question: Find the sum of numbers whose index is less than 5 and the sum of numbers whose index is greater than 5. Output each result on a separate row.

Table: transportation_numbers

index: int
number: int

Query: */

select 
sum(case when index < 5 then number else 0 end) as num 
from transportation_numbers
UNION ALL
select
sum(case when index > 5 then number else 0 end) as num 
from transportation_numbers;

/* Results: 
num
16
16
*/

------------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 2000

Question: Write a query that returns binary description of rate type per loan_id. 
The results should have one row per loan_id and two columns: for fixed and variable type.

Table: submissions

   id	balance	interest_rate	rate_type	loan_id
   1	 5229.12	 8.75	variable	2
   2	 12727.52	 11.37	fixed	4
   3	 14996.58	 8.25	fixed	9
   4	 21149	    4.75	variable	7
   5 	14379	    3.75	variable	5
   
Query:
*/
select 
loan_id,
case when rate_type = 'fixed' then 1 else 0 end as fixed,
case when rate_type = 'variable' then 1 else 0 end as variable 
from submissions;

/*Results:
loan_id	 fixed	variable
2        	0	     1
4	        1	     0
9	        1	     0
7	        0	     1
5        	0	     1
*/
------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2001

Question: Write a query that returns the rate_type, loan_id, loan balance , and a column that shows with what percentage 
the loan's balance contributes to the total balance among the loans of the same rate type.

Table: submissions
id: int
balance: float
interest_rate: float
rate_type: varchar
loan_id: int

Query: */

select
loan_id,
rate_type,
balance,
balance/(Select SUM(balance) 
from submissions 
where rate_type = 'fixed') * 100.0 as balance_share
from submissions
where rate_type = 'fixed'
UNION ALL
select
loan_id,
rate_type,
balance,
balance/(Select SUM(balance) 
from submissions 
where rate_type = 'variable') * 100.0 as balance_share
from submissions
where rate_type = 'variable';
/*
Results: 
loan_id	    rate_type	balance	  balance_share
4	           fixed	    12727.52	  45.908
9	           fixed	    14996.58	  54.092
2	           variable	 5229.12	   11.131
7	           variable	 21149	     45.019
5	           variable	  14379	    30.608

------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2019

Question: 
Return the top 2 users in each company that called the most. Output the company_id, user_id, and the user's rank. 
If there are multiple users in the same rank, keep all of them.

Table: rc_calls

user_id: int
date: datetime
call_id: int

Table: rc_users
user_id: int
status: varchar
company_id: int

Query: */
with call_logs as(
select
u.company_id as company_id,
c.user_id as user_id,
count(c.call_id) as calls
from rc_calls as c
inner join rc_users as u 
on c.user_id = u.user_id
group by 1,2),
ranks as(
select
company_id,
user_id,
dense_rank() over(partition by company_id
        order by calls desc) as ranking
from call_logs)
select
*
from ranks
where ranking <= 2;

/*Results:
company_id	user_id	ranking
     1	     1859	     1
     1	     1854	     2
     1	     1525	     2
     2	     1891	     1
     2	     1181	     1
*/
------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2092

Question: For each day, find the top 3 merchants with the highest number of orders on that day. 
In case of a tie, multiple merchants can share the same place but on each day, there should always be at least 1 merchant on the first, second and third place.
Output the date, the name of the merchant and their place in the daily ranking.

Note: I will not be displaying the tables, because there's too many entries on it but I will display the table namess.

Tables: oordash_orders, doordash_merchants

Query: */
with order_dates as(
select 
o.order_timestamp::date as order_date,
m.name as name,
count(o.id) as order_count
from doordash_orders as o 
inner join doordash_merchants as m 
on o.merchant_id = m.id
group by 1,2),
date_ranks as(
select
order_date,
name,
dense_rank() over(partition by order_date
order by order_count desc) as ranking
from order_dates)
select
*
from date_ranks
where ranking <= 3;

/*Results:
order_date	  name	         ranking
2022-01-14	 Thai Lion	        1
2022-01-14	 Sushi Bay	        2
2022-01-14	 Treehouse Pizza	  3
2022-01-15 	Thai Lion	        1
2022-01-15	 Meal Raven	       1
*/
------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 10039

Question: Find the vintage years of all wines from the country of Macedonia. The year can be found in the 'title' column. 
Output the wine (i.e., the 'title') along with the year. The year should be a numeric or int data type.

Table: winemag_p2

Query: */
select
title,
TRIM(regexp_replace(title, '[[:alpha:],(),'''',-]', '','g')) as year
from winemag_p2
where lower(country) = 'macedonia';

/*Results

Title	                                  year
Macedon 2010 Pinot Noir (Tikves)	      2010
Stobi 2011 Macedon Pinot Noir (Tikves)	2011
Stobi 2011 Veritas Vranec (Tikves)	    2011
Bovin 2008 Chardonnay (Tikves)	        2008
Stobi 2014 uilavka (Tikves)	            2014
*/

------------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 9607

Question: Find the most expensive products on Amazon for each product category. Output category, product name and the price (as a number)

Tables:  innerwear_amazon_com

Query: */
With products as(
select
product_category,
product_name,
replace(price,'$',''):: float as new_price 
from innerwear_amazon_com),
prices as(
select
product_category,
MAX(new_price) as max_price
from products
group by 1)
select
prices.product_category,
products.product_name,
prices.max_price
from products, prices
where products.product_category = prices.product_category
and products.new_price = prices.max_price;

/*Results:
product_category	   product_name	                                 max_price
Bras	                Wacoal Women's Retro Chic Underwire Bra	      69.99
Panties	             Calvin Klein Women's Ombre 5 Pack Thong	      59.99
*/
------------------------------------------------------------------------------------------------------------------------------------------
/* 
Question ID: ID 2096

Question: Find the number of actions that ClassPass workers did for tasks completed in January 2022. The completed tasks are these rows in 
the asana_actions table with 'action_name' equal to CompleteTask. Note that each row in the dataset indicates how many actions of a certain 
type one user has performed in one day and the number of actions is stored in the 'num_actions' column.
Output the ID of the user and a total number of actions they performed for tasks they completed.
If a user from this company did not complete any tasks in the given period of time, you should still output their ID and the number 0 in the second column.

Tables: asana_users, asana_actions

Query: */
with classpass as(
select *
from asana_users
where company = 'ClassPass'),
actions as(
select
user_id,
sum(num_actions) as n_actions
from asana_actions
where extract(year from date) = 2022
and extract(month from date) = 01
and action_name = 'CompleteTask'
group by 1)
select
c.user_id,
coalesce(a.n_actions,0)
from classpass as c 
left join actions a 
on c.user_id = a.user_id;

/*Results:
user_id	 coalesce
161	      23
163      	0
164	      35
*/

------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 9789

Question:
Find the total number of approved friendship requests in January and February.

Table:  facebook_friendship_requests

Query: */

select 
count(date_approved) as num_approved
from facebook_friendship_requests
where date_approved is not null
and extract(month from date_approved) in (1,2);

/* Results:
3
*/
------------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 2104

Question: Which user flagged the most distinct videos that ended up approved by YouTube? Output, in one column, their 
full name or names in case of a tie. In the user's full name, include a space between the first and the last name.

Tables: user_flags, flag_review

Query: */
with users as(
select 
CONCAT(user_firstname,' ',user_lastname) as username,
count(distinct video_id) as flags
from user_flags as f
join (
select
*
from 
flag_review
where reviewed_by_yt = true
and reviewed_outcome = 'APPROVED') as av 
on f.flag_id = av.flag_id
where user_firstname is not null 
and user_lastname is not null
group by 1
having count(distinct video_id) > 1
order by 2)
select username
from users;

/*Results:
username
Mark May
Richard Hasson
*/
------------------------------------------------------------------------------------------------------------------------------------------
/* Question ID: ID 10161
Question:Rank each host based on the number of beds they have listed. The host with the most beds should be ranked 1 and the host with the least number of beds should be ranked last. Hosts that have the same number of beds should have the same rank but there should be no gaps between ranking values. A host can also own multiple properties.
Output the host ID, number of beds, and rank from highest rank to lowest.

Tables: airbnb_apartments

Query: */
select 
host_id,
SUM(n_beds) as beds,
dense_rank() over(order by sum(n_beds) desc) as ranking
from airbnb_apartments
group by 1;

/*Results:
host_id	beds	ranking
10      	16	  1
3       	8	   2
6       	6	   3
5	       5	   4
7	       4	   5*/

------------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 10083
Question: Find contract starting dates of the top 5 most paid Lyft drivers. Consider drivers who are still working with Lyft.

Table: lyft_drivers

Query: */
with dates as(
select 
*,
rank() over(order by yearly_salary desc) as payments
from lyft_drivers
where end_date is null
)
select
start_date
from dates
where payments <= 5;

/*Results:
start_date
2017-04-08
2018-11-04
2018-06-09
2018-07-22
2017-05-07
*/
------------------------------------------------------------------------------------------------------------------------------------------
/* Question ID: ID 10152

Question: You have been asked to find the employees with the highest and lowest salary.
Your output should include the employee's ID, salary, and department, as well as a column salary_type that categorizes the output by:

'Highest Salary' represents the highest salary

'Lowest Salary' represents the lowest salary

Tables: worker

Query: */
with ranking as(
select 
worker_id,
salary,
department,
DENSE_RANK() OVER(ORDER BY salary DESC) as highest,
DENSE_RANK() OVER(ORDER BY salary) as lowest
from worker),
salary_summary as(
select
worker_id,
salary,
department,
CASE WHEN highest = 1 THEN 'Highest Salary' END as salary_type
from ranking
union 
select
worker_id,
salary,
department,
CASE WHEN lowest = 1 THEN 'Lowest Salary' END as salary_type
from ranking)
select
*
from salary_summary
where salary_type is not null
order by salary DESC;


/*Results:
worker_id	salary	department	salary_type
4	        500000	Admin	Highest Salary
5	        500000	Admin	Highest Salary
10	       65000	HR	Lowest Salary */

------------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 9899
Question: Calculate the percentage of the total spend a customer spent on each order. 
Output the customer’s first name, order details, and percentage of the order cost to their total spend across all orders.

Assume each customer has a unique first name (i.e., there is only 1 customer named Karen in the dataset) and that customers place at most only 1 order a day.
Percentages should be represented as decimals

Tables: customers, orders

Query: */
with cust_order as(
select 
c.first_name,
o.order_details,
o.total_order_cost
from orders as o
join customers as c
on o.cust_id = c.id)
select
first_name,
order_details,
total_order_cost/SUM(total_order_cost) OVER(PARTITION BY first_name)::numeric as percentage
from cust_order;

/*Results:
first_name	order_details	percentage
Eva	Coat	0.61
Eva	Slipper	0.098
Eva	Shirts	0.293
Farida	Coat	0.385
*/

------------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 10134
Question: Calculate the percentage of spam posts in all viewed posts by day. A post is considered a spam if a string "spam" is
inside keywords of the post. Note that the facebook_posts table stores all posts posted by users. The facebook_post_views table is an action
table denoting if a user has viewed a post.

Tables: facebook_posts, facebook_post_views
Query: */

with spam_post as(
select 
p.post_date,
SUM(CASE WHEN p.post_keywords ilike '%spam%' THEN 1 ELSE 0 END) as spams,
COUNT(v.*) as views 
from facebook_posts as p 
join facebook_post_views as v 
on p.post_id = v.post_id 
group by 1)
select 
post_date,
ROUND(spams/views:: numeric * 100) as spam_share
from spam_post;

/* Results:
post_date	   spam_share
2019-01-01	    100
2019-01-02	     50
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 9700
Question: Find the rules used to determine each grade. Show the rule in a separate column in the format of 'Score > X AND Score <= Y => Grade = A' where X and Y are 
the lower and upper bounds for a grade. Output the corresponding grade and its highest and lowest scores along with the rule. Order the result based on the grade in ascending order.

Tables:  los_angeles_restaurant_health_inspections

Query: */
with grade_score as(
select 
grade,
MIN(score) as min_score,
MAX(score) as max_score
from los_angeles_restaurant_health_inspections
group by 1)
select 
grade,
min_score,
max_score,
CASE WHEN (min_score > 89 and max_score <= 100) THEN 'Score > 89 AND Score <= 100 => Grade = A'
    WHEN (min_score > 79 and max_score <= 88) THEN 'Score > 79 AND Score <= 88 => Grade = B'
    ELSE 'Score > 69 AND Score <= 79 => Grade = C' END as rule 
    from grade_score
    order by grade ;

/*
Results: 
grade	min_score	max_score	rule
A	90	100	Score > 89 AND Score <= 100 => Grade = A
B	80	88	Score > 79 AND Score <= 88 => Grade = B
C	70	79	Score > 69 AND Score <= 79 => Grade = C
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Question ID: ID 10090
Question: 
Find the percentage of shipable orders.
Consider an order is shipable if the customer's address is known.

Tables: Orders, Customers

Query: */
with cust_orders as(
select 
count(id) as order_count,
(Select count(o.id) from orders as o 
join customers as c 
on o.cust_id = c.id
where c.address is not null) as address_cust
from orders )
select 
address_cust/order_count::numeric * 100 as pct
from cust_orders;

/*Results:
28
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2010
Question: 
List the top 10 users who accumulated the most sessions where they had more streaming sessions than viewing.
Return the user_id, number of streaming sessions, and number of viewing sessions.

Tables: twitch_sessions

Query: */
with views_stream as(
select 
user_id,
SUM(CASE WHEN session_type = 'streamer' then 1 else 0 end) as streaming,
SUM(CASE WHEN session_type = 'viewer' then 1 else 0  end) as viewer 
from twitch_sessions
group by 1)
select 
*
from views_stream
where streaming > viewer
order by streaming
limit 10;

/* Results:
user_id	 streaming	 viewer
0	          2	        1
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2015
Question: What cities recorded the largest growth and biggest drop in order amount between March 11, 2019, and April 11, 2019. 
Just compare order amounts on those two dates. Your output should include the names of the cities and the amount of growth/drop.

tables:  postmates_orders, postmates_markets

query: */
with march_april as(
select 
m.name,
SUM(case when order_timestamp_utc::date = '2019-03-11' then amount else 0 end) as march, 
SUM(case when order_timestamp_utc::date = '2019-04-11' then amount else 0 end) as april
from postmates_orders as o 
join postmates_markets as m 
on o.city_id = m.id
group by 1),
ranks as(
select 
name, 
april - march::numeric as diff,
dense_rank() over(order by april-march::numeric asc) as ranking
from march_april)
select 
name, 
diff
from ranks
where ranking = (select min(ranking) from ranks)
or ranking = (select max(ranking) from ranks);

/*
results:
name	diff
Boston	-530.26
Seattle	192.74
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2155

Question: Following a recent advertising campaign, the marketing department wishes to classify its efforts based on the total number of units sold for each product.
You have been tasked with calculating the total number of units sold for each product and categorizing ad performance based on the following criteria for items sold:

Outstanding: 30+
Satisfactory: 20 - 29
Unsatisfactory: 10 - 19
Poor: 1 - 9

Your output should contain the product ID, total units sold in descending order, and its categorized ad performance.

Query: 
*/
with units as(
select 
product_id, 
SUM(quantity) as sold 
from marketing_campaign 
group by 1)
select 
*, 
CASE WHEN sold <= 9 THEN 'Poor'
    WHEN sold >= 10 and sold <= 19 THEN 'Unsatisfactory'
    WHEN sold >= 20 and sold <= 29 THEN 'Satisfactory'
    ELSE 'Outstanding' END as perf
from units 
order by 2 desc;

/*Results: 
product_id	sold	perf
105	41	Outstanding
102	29	Satisfactory
114	23	Satisfactory
118	22	Satisfactory
120	21	Satisfactory
117	20	Satisfactory
119	19	Unsatisfactory

---------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Question ID: ID 2117
Question: What is the last name of the employee or employees who are responsible for the most orders?

Tables: shopify_orders, shopify_employees
Query: 
*/
with employee_purchases as(
select 
e.id, 
e.first_name, 
e.last_name,
count(o.order_id) as orders,
rank() over(order by count(o.order_id) desc) as ranking
from shopify_orders as o 
join shopify_employees as e on o.resp_employee_id = e.id
group by 1,2,3)
select 
last_name
from employee_purchases
where ranking = 1;

/*Results:
last_name
Holmes
Wadsworth
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Question ID: ID 2152
Question: It's time to find out who is the top employee. You've been tasked with finding the employee (or employees, in the case of a tie) who have received the most votes.
A vote is recorded when a customer leaves their 10-digit phone number in the free text customer_response column of their sign up response (occurrence of any number sequence with exactly 10 digits is considered as a phone number)
Output the top employee and the number of customer responses that left a number.

Tables: customer_responses 

Query:*/
with top as(
select 
employee_id,
SUM(CASE WHEN customer_response ~ '\d{10}' THEN 1 ELSE 0 end) as phone,
rank() over(order by SUM(CASE WHEN customer_response ~ '\d{10}' THEN 1 ELSE 0 end) desc) as ranking
from customer_responses
group by 1
)
select 
employee_id,
phone
from top
where ranking = 1

/* Results: 
employee_id	phone
1001	         3
1006	         3

*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------



















































