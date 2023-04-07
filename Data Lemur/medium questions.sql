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
/*Question: Assume you are given the following tables on Walmart transactions and products. Find the number of unique product combinations that are purchased in the same transaction.
For example, if there are 2 transactions where apples and bananas are bought, and another transaction where bananas and soy milk are bought, my output would be 2 to represent the 2 unique combinations.

Assumptions:

For each transaction, a maximum of 2 products is purchased.
You may or may not need to use the products table.

THE GOAL: Find the number of unique product combinations purchased in a single transaction

step 1: Do a self join with the transactions table 
- Put an additional joining condition t1.column > t2.column this helps to create unique combinations of t1.product_id, t2.product_id 
and ensures that the product IDs are sorted in descending order (you can also use <).

step 2: Next, we will use the DISTINCT and CONCAT() functions to combine both product IDs into a single cell and return the unique combinations.

step 3: Finally, we conduct a count to obtain the number of unique pairs.

FINAL QUERY: */

select 
COUNT(DISTINCT CONCAT(t1.product_id, t2.product_id))
from transactions as t1 
inner join transactions as t2
on t1.transaction_id = t2.transaction_id 
and t1.product_id > t2.product_id;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
