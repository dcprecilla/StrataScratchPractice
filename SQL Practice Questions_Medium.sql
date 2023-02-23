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





















