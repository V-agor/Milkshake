const pool = require("../config/db");

exports.getFlavours = async () => {
    const result = await pool.query("SELECT * FROM lookup_flavours ORDER BY id");
    return result.rows;
};

exports.getToppings = async () => {
    const result = await pool.query("SELECT * FROM lookup_toppings ORDER BY id");
    return result.rows;
};

exports.getConsistency = async () => {
    const result = await pool.query("SELECT * FROM lookup_consistency ORDER BY id");
    return result.rows;
};
