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
-- ================================
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

