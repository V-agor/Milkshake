const lookupModel = require("../models/lookupModel");

exports.getFlavours = async (req, res) => {
    const data = await lookupModel.getFlavours();
    res.json(data);
};

exports.getToppings = async (req, res) => {
    const data = await lookupModel.getToppings();
    res.json(data);
};

exports.getConsistency = async (req, res) => {
    const data = await lookupModel.getConsistency();
    res.json(data);
};
