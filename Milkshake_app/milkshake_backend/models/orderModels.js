const pool = require("../config/db");

exports.createOrder = async ({ user_id, restaurant_id, pickup_time, drinks }) => {
    
    // --- 1. Get VAT value ---
    const vatQuery = await pool.query(
        "SELECT config_value FROM config WHERE config_key = 'vat'"
    );
    const vat_percent = parseFloat(vatQuery.rows[0].config_value);

    // --- 2. Calculate prices ---
    let subtotal = 0;
    let drinkResults = [];

    for (const drink of drinks) {
        const flavour = await pool.query("SELECT base_price FROM lookup_flavours WHERE id = $1", [drink.flavour_id]);
        const topping = await pool.query("SELECT extra_price FROM lookup_toppings WHERE id = $1", [drink.topping_id]);
        const consistency = await pool.query("SELECT extra_price FROM lookup_consistency WHERE id = $1", [drink.consistency_id]);

        const drink_price =
            parseFloat(flavour.rows[0].base_price) +
            parseFloat(topping.rows[0].extra_price) +
            parseFloat(consistency.rows[0].extra_price);

        subtotal += drink_price;

        drinkResults.push({
            ...drink,
            final_price: drink_price
        });
    }

    // --- 3. VAT + Total ---
    const vat_amount = subtotal * vat_percent;
    let total_amount = subtotal + vat_amount;

    // (Discounts added later)
    const discount_applied = 0;

    // --- 4. Insert order ---
    const orderQuery = `
        INSERT INTO orders (user_id, restaurant_id, pickup_time, total_amount, vat_amount, discount_applied, payment_status)
        VALUES ($1, $2, $3, $4, $5, $6, 'pending')
        RETURNING id;
    `;

    const orderResult = await pool.query(orderQuery, [
        user_id,
        restaurant_id,
        pickup_time,
        total_amount,
        vat_amount,
        discount_applied
    ]);

    const order_id = orderResult.rows[0].id;

    // --- 5. Insert drinks for this order ---
    for (const d of drinkResults) {
        await pool.query(
            `INSERT INTO drinks (order_id, flavour_id, topping_id, consistency_id, final_price)
             VALUES ($1, $2, $3, $4, $5)`,
            [order_id, d.flavour_id, d.topping_id, d.consistency_id, d.final_price]
        );
    }

    return {
        message: "Order created successfully",
        order_id,
        subtotal,
        vat_amount,
        discount_applied,
        total_amount
    };
};
