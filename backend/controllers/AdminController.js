var ErrorMessage = require('../error-messages');
var pool = require('../database/Pool');
//var mongo = require("./mongoConnection");
var MongoClient = require('mongodb').MongoClient;
var talkMongo = require('../utils/talkMongo');

function AdminController() {

}

AdminController.prototype.getAllContentAndAds = function(req, res) {
	var storedProcedure = 'call prc_get_all_content_and_ads_for_admin(1)';
    console.log(storedProcedure);
    pool.query(storedProcedure, function(error, results) {
		if (error) {
			return res.status(400).json({ error: 'error message' });
		}
        var response = results[0];
        console.log('admin log:', response);
        res.status(200).json(response);
	});
};

AdminController.prototype.approveDisaproveItem = function(req, res) {
	var storedProcedure = 'call prc_approve_disapprove_items_by_admin(?, ?, ?)';
    var inserts = [req.body.id, req.body.isApproved, req.body.type];
    pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
            return res.status(400).json({ error: 'error message' });
        }
        var response = results[0];
        console.log('admin log:', response);
        res.status(200).json(response);
    });
};

AdminController.prototype.approveAd = function(req, res) {
	var adId = req.body.adId || 1;
	var approve = req.body.approve || false;
	var storedProcedure = 'call prc_approve_disapprove_advertisement_by_admin(' + adId + ',' + approve + '); ';
	console.log(storedProcedure);
	pool.query(storedProcedure, function(error, results) {
        talkMongo.putToMongo(req, results);
	    if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		res.status(200).send();
	});
};

AdminController.prototype.postLogin = function(req, res) {
	var storedProcedure = 'call prc_sign_in_admin(?, ?)';
	var inserts = [req.body.email, req.body.password];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		var response = results[0];
		console.log('admin log:', response);
		res.status(200).json(response[0]);
	});
};

AdminController.prototype.getAdminContent = function(req, res) {
	var storedProcedure = 'call prc_get_all_content_and_ads_for_admin(?)';
	var inserts = [req.query.adminId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		var response = results[0];
		var contentList = [];
		response.forEach(function(item) {
			if (item.contentType !== 'advertisement') {
				item.isApproved = item.isApproved === 1 ? 'Yes' : 'No';
				item.year = 2001;
				contentList.push(item);
			}
		});
		console.log('admin log:', contentList);
		res.status(200).json(contentList);
	});
	// var response =
	// 	[
	// 		{
	// 			title: 'title 1',
	// 			director: 'director 1',
	// 			year: 1997,
	// 			actors: [],
	// 			type: 'movie',
	// 			isApproved: 'Yes',
	// 			id: 1
	// 		},
	// 		{
	// 			title: 'title 2',
	// 			director: 'director 2',
	// 			year: 1998,
	// 			actors: [],
	// 			type: 'documentary',
	// 			isApproved: 'No',
	// 			id: 2
	// 		}
	// 	];
	//
	// res.status(200).json(response);
};

AdminController.prototype.getAdminAd = function(req, res) {
	var storedProcedure = 'call prc_get_all_content_and_ads_for_admin(?)';
	var inserts = [req.query.adminId];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
	    if (error) {
			return res.status(400).json({ error: 'error message' });
		}
		var response = results[0];
		var contentList = [];
		response.forEach(function(item) {
			if (item.contentType === 'advertisement') {
				item.isApproved = item.isApproved === 1 ? 'Yes' : 'No';
				contentList.push(item);
			}
		});
		console.log('admin log:', contentList);
		res.status(200).json(contentList);
	});
};

AdminController.prototype.approve = function(req, res) {
	var storedProcedure = 'call prc_approve_disapprove_items_by_admin(?, true, ?)';
	var inserts = [req.body.contentId, req.body.type];
	pool.query(storedProcedure, inserts, function(error, results) {
        talkMongo.putToMongo(req, results);
        if (error) {
			return res.status(400).json({ error: error });
		}
		var response = results[0];
		console.log('admin log:', response);
		res.status(200).json({});
	});
};


AdminController.prototype.getActivity = function(req, res, next) {
    var url = "mongodb://localhost:27017/spartanflix";
    MongoClient.connect(url, function (err, db) {
        talkMongo.putToMongo(req, results);
        if (err) throw err;
        db.collection("log").find().toArray(function(err, result) {

            if (err) throw err;
            console.log(JSON.stringify(result));
            db.close();
            res.status(200).json(result);
        });
    });
};

module.exports = new AdminController();