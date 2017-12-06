var Viewer = require('../models/Viewer');
var ErrorMessage = require('../error-messages');
var pool = require('../database/Pool');
var mysql = require('mysql');
var talkMongo = require('../utils/talkMongo');
var contentList = [
	{
		title: 'title 1',
		description: 'description 1',
		director: 'director 1'
	},
	{
		title: 'title 1',
		description: 'description 1',
		director: 'director 1'
	},
	{
		title: 'title 1',
		description: 'description 1',
		director: 'director 1'
	}
];

function ViewerController() {
}

ViewerController.prototype.postLogin = function(req, res) {
 	var storedProcedure = 'call prc_sign_in_viewer(?, ?)';
	var inserts = [req.body.email, req.body.password];
	
	pool.query(storedProcedure, inserts, function(error, results) {
		if (error) {
			return res.status(400).json({ error: error });
		}
		//console.log(results);
		talkMongo.putToMongo(req, results[0][0]);
		if (results[0].length === 0) {
			res.status(400).json({ error: 'wrong email or password' });
		} else {
			res.status(200).json(results[0][0]);
		}
	});
};

ViewerController.prototype.signup = function(req, res) {
    var storedProcedure = 'call prc_sign_up_viewer(?, ?, ?, ?, ?, ?, ?, ?)';
    var inserts = [req.body.emailId, req.body.fname, req.body.lname, req.body.password, req.body.startDate, req.body.mainSubscriberId, req.body.subscriptionId, req.body.dependentEmail];
    pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
    	if (error) {
            return res.status(400).json({ error: error });
        }
        var response = results[0];
        res.status(200).json(response);
    });
};


ViewerController.prototype.getAllHistoryAndFavorite = function(req, res) {
	var storedProcedure = 'call prc_get_history_for_viewer(' + req.query.viewerId + ')';
	var historyList = [];
	var favoriteList = [];
	var contentList = [];

	// get history
	pool.query(storedProcedure, function(error, results) {
		if (error) {
			res.status(400).json( {error: error} );
			return;
		}
		historyList = results[0];

		storedProcedure = 'call prc_get_favorites_for_viewer(' + req.query.viewerId + ')';
		pool.query(storedProcedure, function(error, results) {
			if (error) {
				res.status(400).json( {error: error} );
				return;
			}
			favoriteList = results[0];

			storedProcedure = 'call prc_get_content_for_viewer(' + req.query.viewerId + ', null, null, null)';
			pool.query(storedProcedure, function(error, results) {
				if (error) {
					res.status(400).json( {error: error} );
					return;
				}

				contentList = results[0];
				console.log('content list', contentList);
				res.status(200).json({
					historyList: historyList,
					favoriteList: favoriteList,
					contentList: contentList
				});

			});
		});
	});
};


ViewerController.prototype.addFavorite = function(req, res) {
	var storedProcedure = 'call prc_add_favorites_for_viewer(?, ?)';
	var inserts = [req.body.viewerId, req.body.contentId];

	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
		if (error) {
			return res.status(400).json({ error: error });
		}
		
		res.status(200).json({});
	});
};


ViewerController.prototype.changeSubscription = function(req, res) {
	// res.status(200).json({ id: req.body.subscriptionId });
	var storedProcedure = 'call prc_change_subscription_for_viewer(?, ?)';
	var inserts = [req.body.viewerId, req.body.subscriptionId];
	var response = {};
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
		if (error) {
			return res.status(400).json({ error: error });
		}
		res.status(200).json({ id: req.body.subscriptionId });
	});

};


ViewerController.prototype.getViewerContent = function(req, res) {
	 var storedProcedure = 'call prc_get_content_for_viewer(?, ?, ?, ?)';
	 var inserts = [req.query.viewerId, req.query.contentType, req.query.director, req.query.search];
	 var response = {};
     pool.query(storedProcedure, inserts, function(error, results) {
         talkMongo.putToMongo(req, results);
         if (error) {
             return res.status(400).json({ error: error });
         }
         var response = results[0];
         res.status(200).json(response);
    });
};

ViewerController.prototype.getFavorites = function(req, res) {
    var storedProcedure = 'call prc_get_favorites_for_viewer(?)';
    var inserts = [req.query.viewerId];
    var response = {};
    pool.query(storedProcedure, inserts, function (error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
            return res.status(400).json({error: error});
        }
        var response = results[0];
        res.status(200).json(response);
    });
};

ViewerController.prototype.getHistory= function(req, res) {
    var storedProcedure = 'call prc_get_history_for_viewer(?)';
    var inserts = [req.query.viewerId];
    var response = {};
    pool.query(storedProcedure, inserts, function (error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
            return res.status(400).json({error: error});
        }
        var response = results[0];
        res.status(200).json(response);
    });
};

ViewerController.prototype.getAllSubscriptions = function(req, res) {
	var storedProcedure = 'call prc_get_all_content_subscriptions()';
	pool.query(storedProcedure, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		response = results[0];
		res.status(200).json(response);
	});
};

ViewerController.prototype.addToHistory = function(req, res) {
    var storedProcedure = 'call prc_add_to_history_for_viewer(?, ?, ?)';
    var inserts = [req.body.viewerId, req.body.contentId, req.body.ratings];
    pool.query(storedProcedure, inserts, function (error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
            return res.status(400).json({error: error});
        }
        res.status(200);
    });
};

ViewerController.prototype.getFeedback = function(req, res) {
	var storedProcedure = 'call prc_all_feedbacks_for_content(?)';
	var inserts = [req.query.contentId];
	pool.query(storedProcedure, inserts, function(error, results) {
		if (error) {
			return res.status(400).json({ error: error });
		}
		var response = results[0];
		res.status(200).json(response);
	});
};

ViewerController.prototype.giveFeedback = function(req, res) {
	var storedProcedure = 'call prc_add_update_feedback_for_content_by_viewer(?, ?, ?)';
	var inserts = [req.body.contentId, req.body.viewerId, req.body.comment];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		res.status(200).json({});
	});
};

ViewerController.prototype.getRating = function(req, res) {
	var storedProcedure = 'call prc_get_rating_for_content(?)';
	var inserts = [req.query.contentId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		results[0][0].avgRating = results[0][0].avgRating ? results[0][0].avgRating : 0;
		res.status(200).json(results[0][0]);
	});
};

ViewerController.prototype.getAdToShow = function(req, res) {
	var storedProcedure = 'call prc_get_ad_to_show(?)';
	var inserts = [req.query.viewerId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		
		console.log('results', results);
		res.status(200).json(results[0]);
	});
};
module.exports = new ViewerController();