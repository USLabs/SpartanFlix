var ErrorMessage = require('../error-messages');
var mysql = require('mysql');
var pool = require('../database/Pool');
var talkMongo = require('../utils/talkMongo');

function ContentController() {
}

/**
 * Given viewerId as query parameters, return content list
 * @param req
 * @param res
 * @param next
 */
ContentController.prototype.getContentListBySubscriptionId = function(req, res, next) {
	var storedProcedure = 'call prc_get_content_for_viewer(' + req.query.viewerId + ', null, null, null)';

	pool.query(storedProcedure, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			res.status(200).json({ error: error } );
			return;
		}
		var response = results[0];
		res.status(200).json({ results: response } );
	});
};

module.exports = new ContentController();