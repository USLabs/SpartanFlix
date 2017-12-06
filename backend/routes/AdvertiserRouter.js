var express = require('express');
var router = express.Router();

var advertiserController = require('../controllers/AdvertiserController');

router.post('/removeAd',advertiserController.removeAd);

router.post('/login',advertiserController.postLogin);

router.post('/signup',advertiserController.postSignup);

//router.get('/getAllAds', advertiserController.getAllAds);

router.post('/addAd', advertiserController.addAd);

// GET /adProvider/getAllSubscriptions?adProviderId=xx&subscriptionId=xxx
router.get('/getAllSubscriptions', advertiserController.getAllSubscriptions);

// POST /adProvider/changeSubscription
router.post('/changeSubscription', advertiserController.changeSubscription);

// GET /adProvider/getContent?adProviderId=xxx
router.get('/getContent:adProviderId?', advertiserController.getContent);



// POST /adProvider/uploadContent
//router.post('/uploadContent', advertiserController.uploadContent);

// POST /adProvider/removeContent
//router.post('/removeContent', advertiserController.removeContent);

module.exports = router;
