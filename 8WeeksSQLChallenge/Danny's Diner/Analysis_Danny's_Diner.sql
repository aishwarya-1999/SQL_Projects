USE dannys_diner;


SELECT *
FROM members;


SELECT *
FROM menu;


SELECT *
FROM sales;

-- 1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id,
       SUM(m.price) AS amount_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT s.customer_id,
       COUNT(order_date) AS visit_count
FROM sales s
GROUP BY s.customer_id;

-- 3. What was the first item from the menu purchased by each customer?
 WITH cte AS
  (SELECT s.customer_id,
          m.product_name,
          s.order_date,
          dense_rank() over(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS ranking
   FROM sales s
   JOIN menu m ON s.product_id = m.product_id)
SELECT customer_id,
       product_name
FROM cte
WHERE ranking = 1
GROUP BY customer_id,
         product_name;

-- OR

SELECT customer_id,
       product_name
FROM
  (SELECT s.customer_id,
          m.product_name,
          s.order_date,
          dense_rank() over(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS ranking
   FROM sales s
   JOIN menu m ON s.product_id = m.product_id) AS derived
WHERE ranking = 1
GROUP BY customer_id,
         product_name;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name AS most_purchased,
       count(s.order_date) AS purchase_count
FROM menu m
JOIN sales s ON m.product_id = s.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;

-- OR

SELECT most_purchased,
       purchase_count
FROM
  (SELECT m.product_name AS most_purchased,
          count(s.product_id) AS purchase_count,
          rank() over(
                      ORDER BY count(s.product_id) DESC) AS ranking
   FROM menu m
   JOIN sales s ON m.product_id = s.product_id
   GROUP BY most_purchased) popular
WHERE ranking = 1;

-- 5. Which item was the most popular for each customer?

SELECT customer_id,
       most_ordered
FROM
  (SELECT s.customer_id,
          m.product_name AS most_ordered,
          Count(s.product_id) AS purchase_count,
          Rank() OVER(PARTITION BY s.customer_id
                      ORDER BY Count(s.product_id) DESC) ranking
   FROM sales s
   JOIN menu m ON s.product_id = m.product_id GROUP  BY customer_id,
                                                        m.product_name) popular
WHERE ranking = 1;

-- OR
 WITH cte AS
  (SELECT s.customer_id,
          m.product_name,
          count(s.product_id) AS purchase_count,
          rank() over(PARTITION BY s.customer_id
                      ORDER BY count(s.product_id) DESC) AS ranking
   FROM sales s
   JOIN menu m ON s.product_id = m.product_id
   GROUP BY s.customer_id,
            m.product_name)
SELECT customer_id,
       product_name,
       purchase_count
FROM cte
WHERE ranking = 1;

-- 6. Which item was purchased first by the customer after they became a member?
 WITH cte AS
  (SELECT s.customer_id,
          m.product_name,
          s.order_date,
          mm.join_date,
          dense_rank() over(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS ranking
   FROM members mm
   JOIN sales s ON mm.customer_id = s.customer_id
   JOIN menu m ON s.product_id = m.product_id
   WHERE s.order_date >= mm.join_date)
SELECT customer_id,
       product_name,
       join_date,
       order_date
FROM cte
WHERE ranking=1;

-- OR

SELECT customer_id,
       product_name
FROM
  (SELECT s.customer_id,
          m.product_name,
          mm.join_date,
          s.order_date,
          dense_rank() over(PARTITION BY s.customer_id
                            ORDER BY s.order_date) AS ranking
   FROM members mm
   JOIN sales s ON mm.customer_id = s.customer_id
   JOIN menu m ON s.product_id = m.product_id
   WHERE s.order_date >= mm.join_date) AS after_member
WHERE ranking =1;

-- 7. Which item was purchased just before the customer became a member?
-- using dense_rank to access all the items in the first order in case there were more than 1.

SELECT customer_id,
       product_name,
       join_date,
       order_date
FROM
  (SELECT s.customer_id,
          m.product_name,
          s.order_date,
          mm.join_date,
          dense_rank() over(PARTITION BY s.customer_id
                            ORDER BY s.order_date DESC) AS ranking
   FROM members mm
   JOIN sales s ON mm.customer_id = s.customer_id
   JOIN menu m ON s.product_id = m.product_id
   WHERE s.order_date < mm.join_date) AS after_member
WHERE ranking =1;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id,
       count(s.product_id) AS total_items,
       concat('$ ', sum(m.price)) AS amount_spent
FROM menu m
JOIN sales s ON m.product_id = s.product_id
JOIN members mm ON s.customer_id=mm.customer_id
WHERE s.order_date < mm.join_date
GROUP BY s.customer_id
ORDER BY customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT s.customer_id,
       SUm(CASE
               WHEN m.product_name = "sushi" THEN 2*10*m.price
               ELSE 10*m.price
           END) AS points_earned
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
-- not just sushi - how many points do customer A and B have at the end of January?
WITH cte AS
  (SELECT mm.join_date,
          mm.customer_id,
          DAte_add(mm.join_date, INTERVAL 7 DAY) AS last_day
   FROM members mm)
SELECT s.customer_id,
       sum(CASE
               WHEN s.order_date BETWEEN s.order_date AND last_day THEN 2*10*m.price
               WHEN s.order_date NOT BETWEEN s.order_date AND last_day
                    AND product_name="sushi" THEN 2*10*m.price
               WHEN s.order_date NOT BETWEEN s.order_date AND last_day
                    AND product_name <> "sushi" THEN 10*m.price
           END) AS points_earned
FROM menu m
JOIN sales s ON m.product_id=s.product_id
JOIN cte ON s.customer_id = cte.customer_id
AND order_date <='2021-01-31'
AND order_date >=join_date
GROUP BY customer_id
ORDER BY customer_id;