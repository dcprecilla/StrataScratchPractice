/*Question: This is the same question as problem #11 in the SQL Chapter of Ace the Data Science Interview!
Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction 
of every user. Output the user id, spend and transaction date.
table name: transactions
*/

with third as(
SELECT 
*,
DENSE_RANK() OVER(PARTITION BY user_id
                ORDER BY transaction_date) as ranking
FROM transactions)
SELECT
user_id,
spend,
transaction_date
from third 
where ranking = 3;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
