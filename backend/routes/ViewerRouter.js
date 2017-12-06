var express = require('express');
var router = express.Router();
var VIEWER_MOCK_DATA = require('../mock_data/viewer_mock');
var viewerController = require('../controllers/ViewerController');

router.post('/login', viewerController.postLogin);

router.post('/signup', viewerController.signup);

router.get('/allHistoryAndFavorite:viewerId?', viewerController.getAllHistoryAndFavorite);

router.post('/addFavorite', viewerController.addFavorite);

router.get('/getViewerContent:viewerId?', viewerController.getViewerContent);

router.get('/getFavorites', viewerController.getFavorites);

router.get('/getHistory', viewerController.getHistory);

router.post('/addHistory', viewerController.addToHistory);

// GET /viewer/getAllSubscriptions?viewerId=xx&subscriptionId=xxx
router.get('/getAllSubscriptions', viewerController.getAllSubscriptions);

router.post('addToHistory', viewerController.addToHistory);
// POST /viewer/changeSubscription?viewerId=xx&subscriptionId=xxx
router.post('/changeSubscription', viewerController.changeSubscription);

// POST /viewer/addFavorite
router.post('/addFavorite', viewerController.addFavorite);


// GET /viewer/getFeedback?contentId=xxx
router.get('/getFeedback:contentId?', viewerController.getFeedback);

// POST /viewer/giveFeedback
router.post('/giveFeedback', viewerController.giveFeedback);

// viewer/getRating?contentId=xxx
router.get('/getRating:contentId?', viewerController.getRating);

// GET /viewer/getAdToshow?viewerId=xxx
router.get('/getAdToShow:viewerId?', viewerController.getAdToShow);


router.use(function(req, res) {
	console.log('default');
	res.send(VIEWER_MOCK_DATA.defaultResponse);
});

module.exports = router;
