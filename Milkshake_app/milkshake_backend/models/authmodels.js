const pool = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.signup = async ({ first_name, email, mobile, password }) => {
    const hashedPassword = await bcrypt.hash(password, 10);

    const query = `
        INSERT INTO users (first_name, email, mobile, password_hash, role)
        VALUES ($1, $2, $3, $4, 'client')
        RETURNING id, first_name, email, mobile;
    `;

    const values = [first_name, email, mobile, hashedPassword];
    const result = await pool.query(query, values);

    return { message: "Signup successful", user: result.rows[0] };
};

exports.login = async ({ email, password }) => {
    const userQuery = `SELECT * FROM users WHERE email = $1`;
    const userResult = await pool.query(userQuery, [email]);

    if (userResult.rows.length === 0) {
        throw new Error("User not found");
    }

    const user = userResult.rows[0];
    const isValid = await bcrypt.compare(password, user.password_hash);

    if (!isValid) {
        throw new Error("Invalid password");
    }

    const token = jwt.sign(
        { id: user.id, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: "1d" }
    );

    return {
        message: "Login successful",
        token,
        user: {
            id: user.id,
            name: user.first_name,
            role: user.role
        }
    };
};
