--1. Top-Selling Products by Revenue
CREATE VIEW top_5_products_by_revenue AS
SELECT 
    p.product_name,
    '£' ||SUM(O_D.subtotal) total_Revenue,
    COUNT(p.product_name) AS num_of_prod_sold 
FROM 
    products p
JOIN 
    Order_Details O_D USING(product_id)
GROUP BY 
    p.product_name
ORDER BY
    total_Revenue DESC,num_of_prod_sold DESC
LIMIT 5;

--2 Find products ordered by customers who bought Smartphone Stand
CREATE VIEW products_by_customer_who_bought_smartphones AS
WITH customers_review as ( 
    SELECT 
        DISTINCT
        c.customer_id,
        c.first_name,
        P.product_name
    FROM 
        customers c
    JOIN
        Orders O USING(customer_id)
    JOIN 
        Order_Details O_D USING(order_id)
    JOIN 
        Products P USING(product_id)
    WHERE
        P.product_name = 'Smartphone Stand')
SELECT 
    C_R.first_name,
    P.product_name
FROM 
    customers_review C_R
JOIN 
    Orders O USING(customer_id)
JOIN
    Order_Details O_D USING(order_id)
JOIN 
    products p USING(product_id)
WHERE 
    P.product_name != 'Smartphone Stand'
ORDER by
    C_R.first_name;

--3 products never ordered 
CREATE VIEW products_never_sold AS
SELECT
    P.product_id,
    P.product_name,
    O_D.order_id
FROM
    products p
LEFT JOIN
    Order_Details O_D ON P.product_id = O_D.product_id
WHERE
    O_D.order_id IS NULL;

--4 Orders that have priority delivery but incidant has occuered and orderes that belong to customers
CREATE VIEW priority_delivery_with_incident AS
SELECT 
    C.first_name || ' ' || C.last_name AS cust_with_priority,
    O.order_id,
    s.shipment_id
FROM
    Customers C 
JOIN 
    Orders O USING(customer_id)
JOIN
    Shipments S USING(order_id)
JOIN
    Incidents I USING(shipment_id)
WHERE
    O.priority_delivery IS TRUE;

--5 Drivers who have completed their all deliveries 
CREATE VIEW driver_who_completed_deliveries AS
SELECT 
    DISTINCT
    D.driver_id,
    D.first_name
FROM
    Orders O
JOIN 
    Shipments S USING (order_id)
JOIN 
    Driver_Vehicle D_V USING(Driver_Vehicle_id)
JOIN 
    Drivers D USING(driver_id)
WHERE 
    O.status ='DELIVERED';

--6 high value customer who have given average rating above 4 and has spent above £800
CREATE VIEW high_value_customers AS
WITH customers_review_Avg AS (
    SELECT 
        C.customer_id,
        C.first_name,
        ROUND(AVG(C_F.rating), 2) as avg_rating
    FROM 
        Customer_Feedback C_F
    JOIN
        Customers C USING(customer_id)
    GROUP BY 
        C.customer_id
    HAVING
        AVG(C_F.rating) > 4
    ORDER BY
        C.customer_id)
SELECT 
    Cr_avg.customer_id,
    Cr_avg.first_name,
    Cr_avg.avg_rating,
    '£ ' || O_D.subtotal Total_spent
FROM 
    customers_review_Avg Cr_avg
JOIN
    Orders O USING(customer_id)
JOIN
    Order_Details O_D USING(order_id)
WHERE 
    O_D.subtotal >= 800;

------------------------------------------------------------------------------------------------------------------------------
CREATE INDEX idx_feedback_comments ON customer_feedback(comments);
CREATE INDEX idx_customer_id ON customers(customer_id);
CREATE INDEX idx_order_status ON orders(status);
CREATE INDEX idx_product ON products(product_name);
CREATE INDEX idx_night_shift ON drivers(night_shift);
CREATE INDEX idx_driver_status ON drivers(driver_status);
CREATE INDEX idx_incident ON incidents(type);
