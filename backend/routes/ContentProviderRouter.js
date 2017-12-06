var express = require('express');
var router = express.Router();
var contentProviderController = require('../controllers/ContentProviderController');

router.post('/login', contentProviderController.postLogin);
router.post('/signup', contentProviderController.postSignup);
//router.get('/getAllContent:contentProviderId?', contentProviderController.getAllContent);
//router.delete('/removeAd:contentId?', contentProviderController.removeAd);
router.post('/addContent', contentProviderController.addContent);

// GET /contentProvider/getContent?contentProviderId=xxx
router.get('/getContent', contentProviderController.getContent);

// POST /contentProvider/uploadContent
//router.post('/uploadContent', contentProviderController.uploadContent);

// POST /contentProvider/removeContent
router.post('/removeContent', contentProviderController.removeContent);

module.exports = router;
