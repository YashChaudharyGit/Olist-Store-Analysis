use pro;
#KPI-1
-- Union the results of the two queries
WITH WeekdayWeekendStats AS (
    SELECT 
        'Weekday' AS day_type,
        DATE(o.order_purchase_timestamp) AS order_date,
        SUM(p.payment_value) AS total_payment,
        COUNT(o.order_id) AS total_orders,
        AVG(p.payment_value) AS average_payment
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE DAYOFWEEK(o.order_purchase_timestamp) BETWEEN 2 AND 6
    GROUP BY order_date
    UNION ALL
    SELECT 
        'Weekend' AS day_type,
        DATE(o.order_purchase_timestamp) AS order_date,
        SUM(p.payment_value) AS total_payment,
        COUNT(o.order_id) AS total_orders,
        AVG(p.payment_value) AS average_payment
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE DAYOFWEEK(o.order_purchase_timestamp) IN (1, 7)
    GROUP BY order_date
)

-- Calculate grand totals
SELECT 
    day_type,
    SUM(total_payment) AS grand_total_payment,
    SUM(total_orders) AS grand_total_orders,
    AVG(average_payment) AS grand_average_payment
FROM WeekdayWeekendStats
GROUP BY day_type;

#KPI-2
SELECT p.order_id, r.review_score, p.payment_type
FROM olist_order_payments_dataset as p
JOIN olist_order_reviews_dataset as r ON p.order_id = r.order_id
WHERE r.review_score = 5 AND p.payment_type = 'credit_card';

select * from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
select * from olist_orders_dataset;
select * from olist_order_items_dataset;
desc olist_products_dataset;
desc olist_customers_dataset;
desc olist_order_items_dataset;
desc olist_order_payments_dataset;
desc olist_order_reviews_dataset;
desc olist_orders_dataset;
desc olist_sellers_dataset;

#KPi-3
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_approved_at)) AS avg_delivery_days
FROM olist_orders_dataset
WHERE order_id IN (
    SELECT order_id
    FROM olist_order_items_dataset
    WHERE product_id IN (
        SELECT product_id
        FROM olist_products_dataset
        WHERE product_category_name = 'pet_shop'
    )
);


# KPI-4
SELECT 
    AVG(OI.price) AS avg_price,
    AVG(P.payment_value) AS avg_payment_value
FROM olist_order_items_dataset OI
JOIN olist_orders_dataset O ON OI.order_id = O.order_id
JOIN olist_customers_dataset OC ON O.customer_id = OC.customer_id
JOIN olist_order_payments_dataset P ON OI.order_id = P.order_id
WHERE OC.customer_city = 'sao paulo';

desc olist_geolocation_dataset;
desc olist_customers_dataset;
select count(distinct customer_city) from olist_customers_dataset;