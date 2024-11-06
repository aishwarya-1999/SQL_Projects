-- Each question can be answered using a single query - but as you are writing the SQL to solve each individual problem, keep in mind how you would generate all of these metrics in a single SQL script which the Balanced Tree team can run each month.

-- High Level Sales Analysis
-- What was the total quantity sold for all products?
-- What is the total generated revenue for all products before discounts?
-- What was the total discount amount for all products?
-- Transaction Analysis
-- How many unique transactions were there?
-- What is the average unique products purchased in each transaction?
-- What are the 25th, 50th and 75th percentile values for the revenue per transaction?
-- What is the average discount value per transaction?
-- What is the percentage split of all transactions for members vs non-members?
-- What is the average revenue for member transactions and non-member transactions?
-- Product Analysis
-- What are the top 3 products by total revenue before discount?
-- What is the total quantity, revenue and discount for each segment?
-- What is the top selling product for each segment?
-- What is the total quantity, revenue and discount for each category?
-- What is the top selling product for each category?
-- What is the percentage split of revenue by product for each segment?
-- What is the percentage split of revenue by segment for each category?
-- What is the percentage split of total revenue by category?
-- What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
-- What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
-- Reporting Challenge
-- Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

-- Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.

-- He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

-- Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)

-- Bonus Challenge
-- Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.

-- Hint: you may want to consider using a recursive CTE to solve this problem!

-- Conclusion
-- Sales, transactions and product exposure is always going to be a main objective for many data analysts and data scientists when working within a company that sells some type of product - Spoiler alert: nearly all companies will sell products!

-- Being able to navigate your way around a product hierarchy and understand the different levels of the structures as well as being able to join these details to sales related datasets will be super valuable for anyone wanting to work within a financial, customer or exploratory analytics capacity.

-- Hopefully these questions helped provide some exposure to the type of analysis we perform daily in these sorts of roles!