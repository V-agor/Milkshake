const express = require("express");
const router = express.Router();
const lookupController = require("../controllers/lookupController");

router.get("/flavours", lookupController.getFlavours);
router.get("/toppings", lookupController.getToppings);
router.get("/consistency", lookupController.getConsistency);

module.exports = router;
