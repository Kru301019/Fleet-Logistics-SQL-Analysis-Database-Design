CREATE TYPE customer_type AS ENUM ('INDIVIDUAL', 'BUSINESS', 'other');

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) ,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    customer_type customer_type NOT NULL
);
INSERT INTO Customers (first_name, last_name, email, phone_number, customer_type)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '+11234567890', 'INDIVIDUAL'),
    ('Alice', 'Smith', 'alice.smith@example.com', '+442071234567', 'BUSINESS'),
    ('Michael', 'Johnson', 'michael.johnson@example.com', '+919876543210', 'INDIVIDUAL'),
    ('Emma', 'Brown', 'emma.brown@example.com', '+33123456789', 'BUSINESS'),
    ('William', 'Taylor', 'william.taylor@example.com', '+61345678901', 'INDIVIDUAL');
-----------------------------------------------------------------------------------------------------------------------------
CREATE TYPE address_type AS ENUM ('HOME', 'WORK', 'OTHER');

CREATE TABLE Customer_Addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    address_type address_type NOT NULL,
    street_address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    post_code CHAR(8) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

INSERT INTO Customer_Addresses (customer_id, address_type, street_address, city, state, post_code)
VALUES 
    (1, 'HOME', '123 Elm St', 'Edinburgh', 'Scotland', 'EH1 1AB'),
    (1, 'WORK', '456 Business Rd', 'Edinburgh', 'Scotland', 'EH2 2CD'),
    (2, 'HOME', '789 Oak Ave', 'London', 'Greater London', 'E1 4FG'),
    (3, 'HOME', '101 Pine Rd', 'Leicester', 'Leicestershire', 'LE1 3GH'),
    (4, 'WORK', '202 Maple Dr', 'Leicester', 'Leicestershire', 'LE2 4HJ'),
    (5, 'HOME', '303 Birch Ln', 'Bristol', NULL, 'BS1 7HG');
------------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE status_type AS ENUM ('PENDING', 'SHIPPED', 'DELIVERED', 'CANCELLED');

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status status_type,
    priority_delivery BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

INSERT INTO Orders (customer_id, order_date, status, priority_delivery)
VALUES 
    (1, '2025-02-09 14:30:00', 'SHIPPED', FALSE),
    (2, '2025-02-10 09:45:00', 'PENDING', TRUE), 
    (3, '2025-02-11 16:15:00', 'DELIVERED', FALSE),
    (4, '2025-02-12 12:00:00', 'CANCELLED', FALSE),
    (5, '2025-02-13 18:20:00', 'SHIPPED', TRUE), 
    (1, '2025-02-14 07:30:00', 'PENDING', FALSE),
    (2, '2025-02-15 14:45:00', 'DELIVERED', TRUE),
    (3, '2025-02-16 20:10:00', 'SHIPPED', FALSE),
    (4, '2025-02-17 10:30:00', 'PENDING', TRUE),
    (1, '2025-03-18 22:00:00', 'DELIVERED', FALSE),
    (1, '2025-03-18 22:10:00', 'DELIVERED', FALSE),
    (1, '2025-03-18 22:20:00', 'DELIVERED', FALSE),
    (1, '2025-03-18 22:30:00', 'DELIVERED', FALSE);

------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Customer_Feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    rating DECIMAL(2,1) CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

INSERT INTO Customer_Feedback (customer_id, order_id, rating, comments, feedback_date)
VALUES 
    (1, 1, 4.5, 'Great service, timely delivery!', '2025-02-10 15:00:00'),
    (2, 2, 3.0, 'Delivery was a bit late, but acceptable.', '2025-02-11 10:00:00'),
    (3, 3, 5.0, 'Excellent service, highly satisfied!', '2025-02-12 17:00:00'),
    (4, 4, 2.0, 'Order was cancelled, not happy.', '2025-02-13 13:00:00'),
    (5, 5, 4.8, 'Fast delivery, great experience.', '2025-02-14 19:00:00'),
    (1, 6, NULL, NULL, '2025-02-15 08:00:00'), 
    (2, 7, 3.5, 'Decent packaging, could be improved.', '2025-02-16 15:00:00'),
    (3, 8, 4.2, 'Satisfied with the product.', '2025-02-17 21:00:00'),
    (4, 9, NULL, NULL, '2025-02-18 11:30:00'), 
    (5, 10, 5.0, 'Amazing quality, worth the price!', '2025-02-19 23:30:00');
------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

INSERT INTO Products (product_name, price)
VALUES 
    ('Wireless Mouse', 25.99),
    ('Mechanical Keyboard', 79.99),
    ('Noise Cancelling Headphones', 199.50),
    ('USB-C Hub', 45.00),
    ('Smartphone Stand', 15.75),
    ('Gaming Monitor', 299.99),
    ('External Hard Drive', 89.49),
    ('Bluetooth Speaker', 55.20),
    ('Ergonomic Office Chair', 249.99),
    ('Laptop Cooling Pad', 39.95),
    ('USB Gaming Microphone', 125.99);

------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Order_Details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_order DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * price_at_order) STORED,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

INSERT INTO Order_Details (order_id, product_id, quantity, price_at_order)
VALUES 
    (1, 1, 2, 25.99),  
    (1, 3, 1, 199.50), 
    (2, 2, 1, 79.99),  
    (3, 5, 3, 15.75),  
    (3, 6, 1, 299.99), 
    (4, 4, 2, 45.00),  
    (5, 7, 1, 89.49),  
    (5, 8, 2, 55.20),  
    (6, 9, 1, 249.99), 
    (7, 10, 2, 39.95),
    (1, 5, 20, 15.75), 
    (2, 5, 15, 15.75),   
    (7, 5, 25, 15.75), 
    (6, 6, 3, 299.99),   
    (3, 1, 10, 25.99),   
    (4, 3, 5, 199.50),   
    (5, 8, 10, 55.20),
    (10, 1, 2, 39.95),
    (11, 1, 2, 39.95),
    (12, 1, 2, 39.95); 
------------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE Driver_status AS ENUM ('AVAILABLE', 'ASSIGNED', 'ON_LEAVE');

CREATE TABLE Drivers (
    driver_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    night_shift BOOLEAN DEFAULT FALSE,
    driver_status Driver_status
);

INSERT INTO Drivers (first_name, last_name, phone_number, night_shift, driver_status)
VALUES 
    ('John', 'Doe', '+44 7911 123456', FALSE, 'AVAILABLE'),
    ('Emma', 'Smith', '+44 7911 234567', TRUE, 'ASSIGNED'),
    ('Liam', 'Brown', '+44 7911 345678', FALSE, 'ON_LEAVE'),
    ('Olivia', 'Jones', '+44 7911 456789', TRUE, 'AVAILABLE'),
    ('Noah', 'Taylor', '+44 7911 567890', FALSE, 'ASSIGNED'),
    ('Sophia', 'Wilson', '+44 7911 678901', TRUE, 'AVAILABLE'),
    ('Mason', 'Davies', '+44 7911 789012', FALSE, 'ON_LEAVE'),
    ('Ava', 'Evans', '+44 7911 890123', TRUE, 'AVAILABLE'),
    ('James', 'Thomas', '+44 7911 901234', FALSE, 'ASSIGNED'),
    ('Isabella', 'Harris', '+44 7911 012345', TRUE, 'AVAILABLE');
------------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE Vehicle_status AS ENUM ('AVAILABLE', 'IN_USE', 'UNDER_MAINTENANCE');

CREATE TABLE Vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    license_no VARCHAR(100),  
    vehicle_type VARCHAR(100) NOT NULL,
    vehicle_status Vehicle_status

);

INSERT INTO Vehicles (license_no, vehicle_type, vehicle_status)
VALUES 
    ('UK23XJT', 'Truck', 'AVAILABLE'),
    ('LD19ABC', 'Van', 'IN_USE'),
    ('BH22LMN', 'Truck', 'UNDER_MAINTENANCE'),
    ('PO12XYZ', 'Van', 'AVAILABLE'),
    ('MH18PQR', 'Truck', 'IN_USE'),
    ('LN15JKL', 'Van', 'AVAILABLE'),
    ('BT14RST', 'Truck', 'UNDER_MAINTENANCE'),
    ('EX20FGH', 'Van', 'IN_USE'),
    ('OX21UVW', 'Truck', 'AVAILABLE'),
    ('SW17DEF', 'Van', 'UNDER_MAINTENANCE');

------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Driver_Vehicle (
    driver_vehicle_id SERIAL PRIMARY KEY,
    driver_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE
);

INSERT INTO Driver_Vehicle (driver_id, vehicle_id)
VALUES 
    (1, 1), 
    (2, 2), 
    (3, 3), 
    (4, 1),
    (5, 8), 
    (6, 9), 
    (7, 7), 
    (8, 6), 
    (9, 5), 
    (10,4); 
------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Routes (
    route_id SERIAL PRIMARY KEY,
    destination_start_end VARCHAR(100) NOT NULL,
    distance_km INT NOT NULL,
    fuel_cost_estimate DECIMAL(10,2) GENERATED ALWAYS AS ((distance_km * 1.402) / 8) STORED
);

INSERT INTO Routes (destination_start_end, distance_km)  
VALUES  
('London - Manchester', 335),  
('Birmingham - Liverpool', 160),  
('Leeds - Newcastle', 150),  
('Bristol - Southampton', 105),  
('Nottingham - Sheffield', 65);  
------------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE Shipment_status AS ENUM ('IN_TRANSIT', 'DELIVERED', 'CANCELLED');

CREATE TABLE Shipments (
    shipment_id SERIAL PRIMARY KEY,
    driver_vehicle_id INT NOT NULL,
    order_id INT NOT NULL,
    route_id INT NOT NULL,
    FOREIGN KEY (driver_vehicle_id) REFERENCES Driver_Vehicle(driver_vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id) ON DELETE CASCADE
);
 

INSERT INTO Shipments (driver_vehicle_id, order_id, route_id)  
VALUES  
(1, 1, 1),  
(2, 2, 2),    
(4, 4, 4),  
(5, 5, 5),  
(3, 6, 3),
(1, 10, 5),
(2, 11, 5),
(1, 12, 5),
(2, 13, 5);  
------------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE Shipment_type AS ENUM ('breakdown', 'delay', 'damage');

CREATE TABLE Incidents (
    incident_id SERIAL PRIMARY KEY,
    shipment_id INT,
    type Shipment_type,
    resolution TEXT,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id)
);

INSERT INTO Incidents (shipment_id, type, resolution)
VALUES
    (1, 'breakdown', 'Replaced engine part and resumed delivery.'),
    (2, 'delay', 'Rerouted to avoid congestion.');
------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE SpecialCargoDetails (
    special_cargo_id SERIAL PRIMARY KEY,
    shipment_id INT REFERENCES Shipments(shipment_id),
    temperature_range VARCHAR(20),  
    hazardous_class VARCHAR(50),
    security_required BOOLEAN
);

INSERT INTO SpecialCargoDetails (shipment_id, temperature_range, hazardous_class, security_required)
VALUES
    (1, '2°C to 8°C', 'Class 3: Flammable Liquids', TRUE),
    (2, NULL, 'Class 8: Corrosive Substances', FALSE),
    (3, '-20°C to -10°C', NULL, TRUE),
    (4, NULL, 'Class 6: Toxic Substances', TRUE),
    (5, '15°C to 25°C', NULL, FALSE);
