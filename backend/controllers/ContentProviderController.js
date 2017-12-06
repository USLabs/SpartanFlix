var ErrorMessage = require('../error-messages');
var pool = require('../database/Pool');
var talkMongo = require('../utils/talkMongo');

function ContentProviderController() {
}

ContentProviderController.prototype.postLogin = function(req, res, next) {
	var storedProcedure = 'call prc_sign_in_content_provider(?, ?)';
	var inserts = [req.body.email, req.body.password];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		var response = results[0];
		res.status(200).json(response[0]);
	});
};

ContentProviderController.prototype.postSignup = function(req, res, next) {
    var storedProcedure = 'call prc_sign_up_content_provider(?, ?, ?)';
    var inserts = [req.body.emailId, req.body.password, req.body.name];
    pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
            return res.status(400).json({ error: error });
        }
        var response = results[0];
        res.status(200).json(response);
    });
	
};

ContentProviderController.prototype.addContent = function(req, res, next) {
	var storedProcedure = 'call prc_get_add_content_by_content_provider(?, ?, ?, ?, ?)';
	var inserts = [req.body.director, req.body.contentProviderId, req.body.contentTypeName, req.body.title, req.body.description];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json(error);
		}
		
		var response = results[0];
		console.log('add content', response);
		res.status(200).json(response);
	});
};

ContentProviderController.prototype.getAllContent = function(req, res, next) {
	var contentProviderId = req.query.contentProviderId;
	var storedProcedure = 'call prc_get_content_for_content_provider(' + contentProviderId + ')';
	var response = {};
	
	pool.query(storedProcedure, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error});
		}
		response.results = results[0];
		res.status(200).json(response);
	});
};

ContentProviderController.prototype.getContent = function(req, res, next) {
	var storedProcedure = 'call prc_get_content_for_content_provider (?, null, null)';
	var response = {};
    var inserts = [req.query.contentProviderId, req.query.search, req.query.title];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		response = results[0];
		res.status(200).json(response);
	});
};

ContentProviderController.prototype.removeContent = function(req, res, next) {
	var storedProcedure = 'call prc_delete_content_by_content_provider(?)';
	var inserts = [req.body.contentId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		console.log(results);
		if (results.changedRows === 0) {
			res.status(200).json({});
		} else {
			res.status(200).json({ error: '' });
		}
	});
};

module.exports = new ContentProviderController();