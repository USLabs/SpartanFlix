var express = require('express');
var router = express.Router();
// var VIEWER_MOCK_DATA = require('../mock_data/viewer_mock');
var contentController = require('../controllers/ContentController');

router.get('/:viewerId?', contentController.getContentListBySubscriptionId);

module.exports = router;
