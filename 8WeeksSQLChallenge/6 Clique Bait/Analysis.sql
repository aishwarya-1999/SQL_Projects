-- Using the available datasets - answer the following questions using a single query for each one:

-- How many users are there?
-- How many cookies does each user have on average?
-- What is the unique number of visits by all users per month?
-- What is the number of events for each event type?
-- What is the percentage of visits which have a purchase event?
-- What is the percentage of visits which view the checkout page but do not have a purchase event?
-- What are the top 3 pages by number of views?
-- What is the number of views and cart adds for each product category?
-- What are the top 3 products by purchases?
-- 3. Product Funnel Analysis
-- Using a single SQL query - create a new output table which has the following details:

-- How many times was each product viewed?
-- How many times was each product added to cart?
-- How many times was each product added to a cart but not purchased (abandoned)?
-- How many times was each product purchased?
-- Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

-- Use your 2 new output tables - answer the following questions:

-- Which product had the most views, cart adds and purchases?
-- Which product was most likely to be abandoned?
-- Which product had the highest view to purchase percentage?
-- What is the average conversion rate from view to cart add?
-- What is the average conversion rate from cart add to purchase?
-- 3. Campaigns Analysis
-- Generate a table that has 1 single row for every unique visit_id record and has the following columns:

-- user_id
-- visit_id
-- visit_start_time: the earliest event_time for each visit
-- page_views: count of page views for each visit
-- cart_adds: count of product cart add events for each visit
-- purchase: 1/0 flag if a purchase event exists for each visit
-- campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
-- impression: count of ad impressions for each visit
-- click: count of ad clicks for each visit
-- (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)
-- Use the subsequent dataset to generate at least 5 insights for the Clique Bait team - bonus: prepare a single A4 infographic that the team can use for their management reporting sessions, be sure to emphasise the most important points from your findings.

-- Some ideas you might want to investigate further include:

-- Identifying users who have received impressions during each campaign period and comparing each metric with other users who did not have an impression event
-- Does clicking on an impression lead to higher purchase rates?
-- What is the uplift in purchase rate when comparing users who click on a campaign impression versus users who do not receive an impression? What if we compare them with users who just an impression but do not click?
-- What metrics can you use to quantify the success or failure of each campaign compared to eachother?
-- Conclusion
-- This case study is based off my many years working with Digital datasets in consumer banking and retail supermarkets - all of the datasets are designed based off real datasets I’ve come across in challenging problem solving scenarios and the questions reflect similar problems which I worked on.

-- Campaign analysis is almost everywhere in the data world, especially in marketing, digital, UX and retail industries - and being able to analyse views, clicks and other digital behaviour is a critical skill to have in your toolbelt as a data professional!