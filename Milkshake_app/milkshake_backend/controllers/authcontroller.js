const authModel = require("../models/authModel");

exports.signup = async (req, res) => {
    try {
        const result = await authModel.signup(req.body);
        res.status(201).json(result);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const result = await authModel.login(req.body);
        res.status(200).json(result);
    } catch (error) {
        res.status(401).json({ error: error.message });
    }
};
