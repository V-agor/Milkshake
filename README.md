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

Database Design:

PostgresSQL is being used because it is powerful and is industry standard, it also allows for back-end implementation.

<img width="735" height="591" alt="Screenshot (1109)" src="https://github.com/user-attachments/assets/083eeed6-6e2d-47c9-8ac7-a90553e20f34" />


Below is a schema created in quickDBD:

<img width="1920" height="919" alt="Screenshot (1112)" src="https://github.com/user-attachments/assets/03ed5bc1-07d7-41bf-a64a-9b5aadde4a8a" />

We will create a database named Milkshake_app and prepare our database schema

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
