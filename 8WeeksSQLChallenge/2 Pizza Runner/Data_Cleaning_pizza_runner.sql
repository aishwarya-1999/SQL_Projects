use pizza_runner;

select *
from customer_orders;

CREATE temporary table cust_orders(
	select order_id,
    customer_id,
    pizza_id,
    case
    When exclusions = '' then exclusions = 0
    when exclusions = 'null' then exclusions = 0
    ELSe exclusions
    end as clean_exclusions,
    case
    When extras = '' then extras = 0
    when extras = 'null' then extras = 0
    ELSe extras
    end as clean_extras,
    order_time
    from customer_orders
    );