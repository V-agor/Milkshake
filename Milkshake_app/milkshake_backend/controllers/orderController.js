const orderModel = require("../models/orderModel");

exports.createOrder = async (req, res) => {
    try {
        const order = await orderModel.createOrder(req.body);
        res.status(201).json(order);
    } catch (err) {
        console.error("Order creation error:", err);
        res.status(500).json({ error: err.message });
    }
};
