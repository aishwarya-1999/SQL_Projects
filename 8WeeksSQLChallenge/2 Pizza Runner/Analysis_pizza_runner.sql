-- A. Pizza Metrics

USE pizza_runner;

-- How many pizzas were ordered?

SELECT 
    COUNT(*) as total_orders
FROM
    customer_orders;

-- How many unique customer orders were made?

SELECT 
    COUNT(DISTINCT (order_id)) AS uniqe_order
FROM
    customer_orders;

-- How many successful orders were delivered by each runner?

SELECT 
    runner_id, COUNT(order_id) AS num_orders
FROM
    runner_orders
GROUP BY runner_id;

-- How many of each type of pizza was delivered?

SELECT 
    pizza_id, COUNT(order_id) AS num_orders
FROM
    customer_orders
GROUP BY pizza_id;

-- How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
	c.customer_id, p.pizza_name, count(c.order_id) as num_orders
FROM
	pizza_names p
JOIN customer_orders c on p.pizza_id = c.pizza_id
GROUP BY c.customer_id, p.pizza_name    
ORDER BY c.customer_id;

-- What was the maximum number of pizzas delivered in a single order?

SELECT order_id, pizza_count
FROM (SELECT order_id, count(pizza_id) as pizza_count,
	DENSE_RANK() OVER(ORDER BY count(pizza_id) DESC) AS ranks
FROM customer_orders
GROUP BY order_id) as x
WHERE ranks=1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?



-- How many pizzas were delivered that had both exclusions and extras?



-- What was the total volume of pizzas ordered for each hour of the day?



-- What was the volume of orders for each day of the week?


-- B. Runner and Customer Experience

-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)



-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?



-- Is there any relationship between the number of pizzas and how long the order takes to prepare?



-- What was the average distance travelled for each customer?



-- What was the difference between the longest and shortest delivery times for all orders?



-- What was the average speed for each runner for each delivery and do you notice any trend for these values?



-- What is the successful delivery percentage for each runner?



-- C. Ingredient Optimisation

-- What are the standard ingredients for each pizza?



-- What was the most commonly added extra?



-- What was the most common exclusion?



-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"



-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?



-- D. Pricing and Ratings

-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
-- how much money has Pizza Runner made so far if there are no delivery fees?



-- 2. What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra



-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset - generate a schema for this new table and insert your 
-- own data for ratings for each successful customer order between 1 to 5.



-- 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas



-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
-- how much money does Pizza Runner have left over after these deliveries?

-- E. Bonus Questions

-- If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?