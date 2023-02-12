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

Results: 
city
Mountain View
Santa Clara
San Francisco

-------------------------------------------------------------------------------------------------------------------------------------
Question ID: ID 10301

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

Query:

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

Results: **First 5 rows only**
tite      | ratio
Project8	  24642
Project49	  24387
Project15 	24058
Project10	  23794
Project19	  22493

----------------------------------------------------------------------------------------------------------------------------------

Question ID: ID 10030

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

Query:

select winery,
variety,
sum(price) as total_revenue
from winemag_p1
group by 1,2
having min(points) >= 90
order by 1 asc, 3 desc
 ;
 
 * Please note that the results of this query is long and I only included the first 5 records
 
 Results:
 winery   	        variety	                total_revenue
Aveleda	            Alvarinho	                 13
Bollig-Lehnert	    Riesling	                 27
Boudreaux Cellars	  Cabernet Sauvignon	      100
Ca' du RabajaŠ	     Nebbiolo	                24
Chateau Souverain    Cabernet Sauvignon     	35

----------------------------------------------------------------------------------------------------------------------------------
Question ID: ID 10053

Question:
Find the top 5 businesses with the most check-ins.
Output the business id along with the number of check-ins.

Table: yelp_checkin

business_id: varchar
weekday: varchar
hour: datetime
checkins: int

Query:
select
* 
from yelp_checkin
order by checkins desc
limit 5;

Results: 
business_id	              weekday	hour	checkins
4k3RlMAMd46DZ_JyZU0lMg	     Sat	21:00	137
TkEMlu88OZn9TKZyeY9CJg	      Mon	02:00	39
4p6Wce7Ed707QS2-yQkvZw	      Sat	01:00	31
Ehy00JWQixgoXzisVKhvag	      Wed	01:00	22
ujgpePdD8Q-fP1mPFnw0Qw	      Tue	16:00	17

----------------------------------------------------------------------------------------------------------------------------------



