# Order Milkshake Pickup System

This is a real-world software project that combines web development(back and front end), database design and reporting to deliver a deployeble solution.

Project Objectives:

1.Database Design
2.
3.Deploy Solution

Technologies used:

1.PostgresSQL

2.QuickDBD

3.

Phase 1: Database Design

PostgresSQL is being used because it is powerful and is industry standard, it also allows for back-end implementation.

<img width="735" height="591" alt="Screenshot (1109)" src="https://github.com/user-attachments/assets/083eeed6-6e2d-47c9-8ac7-a90553e20f34" />


Below is a schema created in quickDBD:

<img width="1920" height="919" alt="Screenshot (1112)" src="https://github.com/user-attachments/assets/03ed5bc1-07d7-41bf-a64a-9b5aadde4a8a" />

We will create a database named Milkshake_app and prepare our database schema

Note: A server environment needs to be setup in pgadmin before hand before scripts can be created

<img width="1920" height="1080" alt="Screenshot (1111)" src="https://github.com/user-attachments/assets/c81a7d5e-5ca8-4be0-b559-9370773a12ed" />

Lets us explore the tables in depth:

Users:Stores client and manager accounts.

Restaurants:Required because the user must select where they pick up their order.

Lookup tables:these store values that managers can modify:
flavour, toppings, consistency

Config table:Stores dynamic system rules:
max drinks (default 10), VAT %, tiered discount rules

Orders and drinks:

Audit logs: required to track:

who changed VAT, who added a new flavour, who edited order values

**Lookup Tables
Our next task is to automate lookup data insertion

Lookup tables contain fixed values that  users cannot modify, these are the values that appear on dropdowns.

They need to be inserted because when the tables are first created they lack these values so they need to be entered.

I wwill share my full SQL so as to discuss some issues i cam across and how i resolved them

-- ===========================================

-- DROP ALL TABLES (reset database) allows database to reset each time 

-- ===========================================

DROP TABLE IF EXISTS audit_logs CASCADE;

DROP TABLE IF EXISTS drinks CASCADE;

DROP TABLE IF EXISTS orders CASCADE;

DROP TABLE IF EXISTS config CASCADE;

DROP TABLE IF EXISTS lookup_consistency CASCADE;

DROP TABLE IF EXISTS lookup_toppings CASCADE;

DROP TABLE IF EXISTS lookup_flavours CASCADE;

DROP TABLE IF EXISTS restaurants CASCADE;

DROP TABLE IF EXISTS users CASCADE;



-- ================================

--  USERS TABLE

-- ================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    
    first_name VARCHAR(100) NOT NULL,
    
    email VARCHAR(150) UNIQUE NOT NULL,
    
    mobile VARCHAR(20) NOT NULL,
    
    password_hash TEXT NOT NULL,
    
    role VARCHAR(20) NOT NULL CHECK (role IN ('manager', 'client')),
    
    created_at TIMESTAMP DEFAULT NOW()
    
);


-- ================================

--  RESTAURANTS TABLE

-- ================================

CREATE TABLE restaurants (

    id SERIAL PRIMARY KEY,
    
    name VARCHAR(150) NOT NULL,
    
    address TEXT NOT NULL
    
);


-- ================================

--  LOOKUP TABLES (CONFIGURABLE)

-- ================================

CREATE TABLE lookup_flavours (

    id SERIAL PRIMARY KEY,
    
    name VARCHAR(50) NOT NULL,
    
    base_price DECIMAL(10,2) NOT NULL
    
);


CREATE TABLE lookup_toppings (

    id SERIAL PRIMARY KEY,
    
    name VARCHAR(100) NOT NULL,
    
    extra_price DECIMAL(10,2) NOT NULL
    
);


CREATE TABLE lookup_consistency (

    id SERIAL PRIMARY KEY,
    
    name VARCHAR(50) NOT NULL,
    
    extra_price DECIMAL(10,2) NOT NULL
    
);


-- ================================

--  CONFIG TABLE (VAT, MAX DRINKS, DISCOUNTS)

-- ================================

CREATE TABLE config (

    id SERIAL PRIMARY KEY,
    
    config_key VARCHAR(100) UNIQUE NOT NULL,
    
    config_value VARCHAR(200) NOT NULL,
    
    updated_at TIMESTAMP DEFAULT NOW()
    
);



-- ================================

--  ORDERS TABLE

-- ================================

CREATE TABLE orders (

    id SERIAL PRIMARY KEY,
    
    user_id INT REFERENCES users(id),
    
    restaurant_id INT REFERENCES restaurants(id),
    
    pickup_time TIMESTAMP NOT NULL,
    
    total_amount DECIMAL(10,2) NOT NULL,
    
    vat_amount DECIMAL(10,2) NOT NULL,
    
    discount_applied DECIMAL(10,2) DEFAULT 0,
    
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('pending', 'paid', 'failed')),
    
    created_at TIMESTAMP DEFAULT NOW()
    
);

-- ================================

--  DRINKS PER ORDER

==========

CREATE TABLE drinks (

    id SERIAL PRIMARY KEY,
    
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    
    flavour_id INT REFERENCES lookup_flavours(id),
    
    topping_id INT REFERENCES lookup_toppings(id),
    
    consistency_id INT REFERENCES lookup_consistency(id),
    
    final_price DECIMAL(10,2) NOT NULL
    
);


-- ================================

--  AUDIT LOGS TABLE

-- ================================

CREATE TABLE audit_logs (

    id SERIAL PRIMARY KEY,
    
    user_id INT REFERENCES users(id),
    
    table_name VARCHAR(100) NOT NULL,
    
    action VARCHAR(200) NOT NULL,
    
    old_value TEXT,
    
    new_value TEXT,
    
    timestamp TIMESTAMP DEFAULT NOW()
    
);


INSERT INTO lookup_flavours (name, base_price) VALUES

('Strawberry', 30.00),

('Vanilla', 28.00),

('Chocolate', 32.00),

('Coffee', 34.00),

('Banana', 29.00),

('Oreo', 36.00),

('Bar One', 38.00);


INSERT INTO lookup_toppings (name, extra_price) VALUES

('Frozen Strawberries', 10.00),

('Freeze-dried banana', 12.00),

('Oreo crumbs', 8.00),

('Bar One syrup', 9.00),
('Coffee powder with chocolate', 11.00),

('Chocolate vermicelli', 7.00);




INSERT INTO lookup_consistency (name, extra_price) VALUES

('Double Thick', 12.00),

('Thick', 10.00),

('Milky', 6.00),

('Icy', 4.00);


INSERT INTO restaurants (name, address) VALUES

('Milky Shaky Irene', '123 Irene Drive, Pretoria'),

('Milky Shaky Centurion', '45 Highway Street, Centurion'),

('Milky Shaky Pretoria', '78 CBD Lane, Pretoria Central');




INSERT INTO config (config_key, config_value) VALUES

('discount_tier1_orders', '5'),

('discount_tier1_percentage', '5'),

('discount_tier2_orders', '10'),

('discount_tier2_percentage', '10'),

('discount_tier3_orders', '20'),

('discount_tier3_percentage', '15'),

('minimum_drinks_for_discount', '2');




SELECT * FROM lookup_flavours;

SELECT * FROM lookup_toppings;

SELECT * FROM lookup_consistency;

SELECT * FROM restaurants;

SELECT * FROM config;


Phase 2: Backend Setup (Node.js + Express + PostgreSQL)

Step 1: First we will create Our backend folder:

<img width="1113" height="619" alt="Screenshot (1116)" src="https://github.com/user-attachments/assets/229532f1-6f34-4f09-846b-0ebcedc169e1" />

This creates a backend folder contain the node.json file

Step 2:Next we will install all required libraries

The packages will do the following:

Package 	    Purpose

express	        Web server framework

pg	            PostgreSQL client

bcrypt	        Password hashing

jsonwebtoken	Login authentication token

dotenv	       Load environment variables

cors	       Allow frontend to talk to backend

nodemailer	   Send email receipts

The following is the structure we will emulate:

milkshake-backend/

  app.js
  
  config/
  
    db.js
    
  routes/
  
    authRoutes.js
    
    lookupRoutes.js
    
  controllers/
  
    authController.js
    
    lookupController.js
    
  models/
  
    authModel.js
    
    lookupModel.js
    
The node js file will be populated with code,our objective is to--- so our code will do the following:

db.j s- this code connects our backend to the databbase

app.js - this is the  entry point of our backend

authRoute.js, authController.js, authModel.js - these are they first routes, their code allow the signup, login, hashing and JWT authentication to function


lookuoRoute.js, lookupController.js, lockupModel.js - our lookup end points

And with this our backend is officially alive

Phase 3:
