USE dannys_diner;

SELECT 
    *
FROM
    members;

SELECT 
    *
FROM
    menu;

SELECT 
    *
FROM
    sales;

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
    s.customer_id, SUM(m.price) AS total_spent
FROM
    sales s
        JOIN
    menu m
GROUP BY customer_id
ORDER BY customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT 
    customer_id, COUNT(DISTINCT order_date) AS no_of_visits
FROM
    sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?

-- select *,
-- rank() over(partition by customer_id order by order_date) as first_item
-- from sales; #logic

select f.customer_id, m.product_name
from (select *,
rank() over(partition by customer_id order by order_date) as first_item
from sales) as f join menu m on f.product_id = m.product_id
where f.first_item = 1
order by customer_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
    m.product_name, COUNT(s.product_id) AS count_purchase
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY count_purchase DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

WITH popular_choice AS
(SELECT s.customer_id, m.product_name, count(s.product_id) AS ordered_count,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.customer_id) DESC) AS ranking
FROM sales s JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name)
SELECT customer_id, product_name, ordered_count
FROM popular_choice
WHERE ranking = 1 ;

-- 6. Which item was purchased first by the customer after they became a member?



-- 7. Which item was purchased just before the customer became a member?

select s.customer_id, s.product_id, s.order_date,
ROw_number() over(partition by customer_id) as first_order_mem,
dense_rank() over(partition by Count(order_date)) as order_bef_mem
from sales s join members mb on s.customer_id = mb.customer_id
where s.order_date < mb.join_date
group by s.customer_id, s.product_id, order_date;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT 
    s.customer_id,
    COUNT(s.product_id) AS total_items,
    SUM(m.price) AS amt_spent
FROM
    sales s
        JOIN
    members mb ON s.customer_id = mb.customer_id
        AND s.order_date < mb.join_date
        JOIN
    menu m ON m.product_id = s.product_id
GROUP BY s.customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select s.customer_id, sum(m.price), count(s.product_id)*10*price
from sales s join menu m on s.product_id = m.product_id
group by s.customer_id, s.product_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?

