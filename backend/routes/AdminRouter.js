var express = require('express');
var router = express.Router();

var adminController = require('../controllers/AdminController');

router.post('/login', adminController.postLogin);

router.post('/approveDisaproveItem', adminController.approveDisaproveItem);

//router.post('/approveDisapproveAd', adminController.approveAd);

router.get('/getAllContentAndAds', adminController.getAllContentAndAds);

// GET /admin/getAdminContent?adminId=xxx
//router.get('/getAdminContent:adminId?', adminController.getAdminContent);

// GET /admin/getAdminAd?adminId=xxx
router.get('/getAdminAd', adminController.getAdminAd);

router.get('/getActivity', adminController.getActivity);
// POST /admin/approve
//router.post('/approve', adminController.approve);

module.exports = router;