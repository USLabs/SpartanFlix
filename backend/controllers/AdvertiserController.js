var ErrorMessage = require('../error-messages');
var pool = require('../database/Pool');

function AdvertiserController() {
}

AdvertiserController.prototype.postLogin = function(req, res) {
	var storedProcedure = 'call prc_sign_in_advertiser(?, ?);';
	var inserts = [req.body.email, req.body.password];
	pool.query(storedProcedure, inserts, function(error, results) {
			if (error) {
				return res.status(400).json({ error: error });
			}
			console.log(results[0]);
			if (typeof results[0][0] === 'undefined') {
				return res.status(400).json({ error: 'invalid email or password' });
			} else {
				return res.status(200).json(results[0][0]);
			}
		}
	);
};

AdvertiserController.prototype.postSignup = function(req, res, next) {
    var storedProcedure = 'call prc_sign_up_advertiser(?, ?, ?, ?, ?, ?)';
    var inserts = [req.body.emailId, req.body.fname, req.body.lname, req.body.password, req.body.startDate, req.body.subscriptionId];
    pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
            return res.status(400).json({ error: error });
        }
        var response = results[0];
        res.status(200).json(response);
    });
};

// TODO
AdvertiserController.prototype.addAd = function(req, res, next) {
	var storedProcedure = 'call prc_add_ad_for_advertiser(?, ?, ?)';
	var inserts = [req.body.advertiserId, req.body.title, req.body.description];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		res.status(200).send();
	});
};

AdvertiserController.prototype.changeSubscription = function(req, res, next) {
	var storedProcedure = 'call prc_change_subscription_for_advertiser(?, ?)';
	var inserts = [req.body.adProviderId, req.body.subscriptionId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		res.status(200).json({ id: req.body.subscriptionId });
	});
};

AdvertiserController.prototype.removeAd = function(req, res, next) {
	var storedProcedure = 'call prc_remove_ad_for_advertiser(?);';
	var inserts = [req.body.advertisementId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		res.status(200).send();
	});
};

// TODO
AdvertiserController.prototype.getAllAds = function(req, res, next) {
	var storedProcedure = 'call prc_get_ads_for_advertiser(?)';
	var inserts = [req.query.advertiserId];
	var response = {};
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		response.results = results[0];
		res.status(200).json(response);
	});
};

// TODO
AdvertiserController.prototype.search = function(req, res, next) {
	var storedProcedure = 'call ';
	pool.query(storedProcedure, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		var response = results[0];
		res.status(200).json(response);
	});
};

// TODO
AdvertiserController.prototype.filter = function(req, res, next) {
	var storedProcedure = 'call ';
	pool.query(storedProcedure, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		var response = results[0];
		res.status(200).json(response);
	});
};

AdvertiserController.prototype.getAllSubscriptions = function(req, res, next) {
	var storedProcedure = 'call prc_get_all_ads_subscriptions()';
	pool.query(storedProcedure, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		response = results[0];
		res.status(200).json(response);
	});
};

AdvertiserController.prototype.getContent = function(req, res, next) {
	var storedProcedure = 'call prc_get_ads_for_advertiser(?, ?, ?)';
	var inserts = [req.query.adProviderId, req.query.search, req.query.title];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		var response = results[0];
		res.status(200).json(response);
	});
};

AdvertiserController.prototype.uploadContent = function(req, res, next) {
	var storedProcedure = 'call prc_add_ad_for_advertiser(?, ?, ?)';
	var inserts = [req.body.adProviderId, req.body.title, req.body.description];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		var response = results[0];
		console.log('response:', response);
		res.status(200).json(response);
	});

};

AdvertiserController.prototype.removeContent = function(req, res, next) {
	var storedProcedure = 'call prc_remove_ad_for_advertiser(?)';
	var inserts = [req.body.adId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		var response = results[0];
		res.status(200).json(response);
	});
};

module.exports = new AdvertiserController();