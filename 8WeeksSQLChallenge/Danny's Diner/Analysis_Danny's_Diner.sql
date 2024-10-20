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
                      ORDER BY Count(s.product_id) desc) ranking
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

With cte as (select s.customer_id, m.product_name, s.order_date, mm.join_date,
dense_rank() over(partition by s.customer_id ORDER BY s.order_date) as ranking
from members mm join sales s
on mm.customer_id = s.customer_id
join menu m on s.product_id = m.product_id
where s.order_date >= mm.join_date)
select customer_id, product_name, join_date, order_date
from cte 
where ranking=1;

-- OR

select customer_id, product_name 
from (select s.customer_id, m.product_name, mm.join_date, s.order_date,
dense_rank() over(partition by s.customer_id order by s.order_date) as ranking
from members mm join sales s
on mm.customer_id = s.customer_id
join menu m on s.product_id = m.product_id
where s.order_date >= mm.join_date) AS after_member
where ranking =1;

-- 7. Which item was purchased just before the customer became a member?
-- using dense_rank to access all the items in the first order in case there were more than 1. 
select customer_id, product_name, join_date, order_date
from (select s.customer_id, m.product_name,  s.order_date, mm.join_date, 
dense_rank() over(partition by s.customer_id order by s.order_date desc) as ranking
from members mm join sales s
on mm.customer_id = s.customer_id
join menu m on s.product_id = m.product_id
where s.order_date < mm.join_date) AS after_member
where ranking =1;

-- 8. What is the total items and amount spent for each member before they became a member?

select s.customer_id, count(s.product_id) as total_items, concat('$ ',sum(m.price)) as amount_spent
from menu m join sales s on m.product_id = s.product_id
join members mm on s.customer_id=mm.customer_id
where s.order_date < mm.join_date
group by s.customer_id
order by customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

select s.customer_id, 
	SUm(case
		when m.product_name = "sushi" then 2*10*m.price
        else 10*m.price
	END) as points_earned
from sales s
join menu m
on s.product_id = m.product_id
GROUP BY customer_id
ORDER BY customer_id;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?
with cte as (
select mm.join_date, mm.customer_id,
		DAte_add(mm.join_date, INTERVAL 7 DAy)
        as last_day
        from members mm)
select s.customer_id,
	sum(case
			when s.order_date between s.order_date and last_day then 2*10*m.price
            when s.order_date not between s.order_date and last_day AND product_name="sushi" then 2*10*m.price
            when s.order_date not between s.order_date and last_day AND product_name <> "sushi" then 10*m.price
            END) as points_earned
from menu m join sales s on m.product_id=s.product_id
join cte on s.customer_id = cte.customer_id
AND order_date <='2021-01-31'
AND order_date >=join_date
group by customer_id
order by customer_id;


