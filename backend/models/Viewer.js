var pool = require('../database/Pool');
var mysql = require('mysql');

function Viewer() {

}

/**
 * if email found, return Viewer;
 * else return null;
 * @param email
 * @param callback
 */
Viewer.prototype.findByEmail = function(email, callback) {
	// var sql = 'select * from Viewer where email = ?';
	var sql = 'select id, email, fname, lname, password, DATE_FORMAT(startDate, "%Y-%m-%d") as startDate, subscriptionId from viewer where email = ?;';
	var inserts = [email];
	sql = mysql.format(sql, inserts);
	
	pool.query(sql, function (error, results, fields) {
		if (error) {
			callback(error, null);
			return;
		}
		// console.log('results: ', results);
		if (results.length === 0) {
			callback(null, null);
			return;
		}
		
		var viewer = this.mapResults(results[0]);
		callback(null, viewer);
	}.bind(this));
	
};

Viewer.prototype.findById = function(id, callback) {
	var sql = 'select id, email, fname, lname, password, DATE_FORMAT(startDate, "%Y-%m-%d") as startDate, subscriptionId from viewer where id = ?;';
	
	var inserts = [id];
	sql = mysql.format(sql, inserts);
	
	pool.query(sql, function (error, results, fields) {
		if (error) {
			callback(error, null);
			return;
		}
		// console.log('results: ', results);
		if (results.length === 0) {
			callback(null, null);
			return;
		}
		
		var viewer = this.mapResults(results[0]);
		callback(null, viewer);
	}.bind(this));
	
};

Viewer.prototype.create = function(req, callback) {

	var sql =
		'INSERT INTO Viewer (email, fname, lname, password, mainSubscriberId, subscriptionId, startDate) ' +
		'VALUES (?, ?, ?, ?, ?, ?, ?)';
	var info = req.body;
	var inserts = [
		info.email,
		info.firstName,
		info.lastName,
		info.password,
		info.mainSubscriberId,
		info.subscriptionId,
		info.startDate
	];
	sql = mysql.format(sql, inserts);
	
	console.info('start date:', info.startDate);
	pool.query(sql, function (error, results, fields) {
		
		if (error) {
			// if user already exists
			if (error.code === 'ER_DUP_ENTRY') {
				callback({ error : 'email ' + info.email + ' already exists' }, null);
				return;
			}
			callback(error, null);
			return;
		}
		
		// console.log('results: ', results);
		if (results.length === 0) {
			callback(null, null);
			return;
		}
		
		this.findByEmail(req.body.email, function(error, viewer) {
			if (error) {
				callback(error, null);
				return;
			}
			callback(null, viewer);
		}.bind(this))
	}.bind(this));
	
};

Viewer.prototype.deleteById = function(id, callback) {
	this.findById(id, function(error, viewer) {
		if (error) {
			callback(error, null);
			return;
		}
		
		if (!viewer) {
			callback({ error: 'id does not exist'}, null);
			return;
		}
		
		// viewerId exists
		var sql = 'delete from Viewer where id = ?';
		var inserts = [id];
		sql = mysql.format(sql, inserts);
		
		pool.query(sql, function (error, results, fields) {
			if (error) {
				callback(error, null);
				return;
			}
			
			if (results.affectedRows === 0) {
				callback({error : 'id does not exist'}, null);
			} else {
				delete viewer.password;
				callback(null, viewer);
			}
		});
		
	});
};

Viewer.prototype.update = function(req, callback) {
	var self = this;
	this.findById(req.params.viewerId, function(error, viewer) {
		if (error) {
			callback(error, null);
			return;
		}
		
		if (!viewer) {
			callback({ error: 'id: ' + req.params.viewerId + ' does not exist'}, null);
			return;
		}
		
		// viewerId exists
		var sql =
			'UPDATE Viewer SET email=?, fname=?, lname=?, password=?, mainSubscriberId=?, subscriptionId=?, startDate=? ' +
			'WHERE id=?';
		var info = req.body;
		var inserts = [
			info.email,
			info.firstName,
			info.lastName,
			info.password,
			info.mainSubscriberId,
			info.subscriptionId,
			info.startDate,
			req.params.viewerId
		];
		sql = mysql.format(sql, inserts);
		viewer = req.body;
		pool.query(sql, function (error, results, fields) {
			if (error) {
				callback(error, null);
				return;
			}
			
			delete viewer.password;
			callback(null, viewer);
		});
		
	});
};

Viewer.prototype.mapRequest = function(req) {
	var viewer = {};
	viewer.firstName = req.body.fname;
	viewer.lastName = req.body.lname;
	viewer.mainSubscriberId = req.body.mainSubscriberId;
	viewer.password = req.body.password;
	viewer.subscriptionId = req.body.subscriptionId;
	viewer.email = req.body.email;
	viewer.startDate = req.body.startDate;
	return viewer;
};

Viewer.prototype.mapResults = function(results) {
	var viewer = {};
	viewer.firstName = results.fname;
	viewer.lastName = results.lname;
	viewer.mainSubscriberId = results.mainSubscriberId;
	viewer.id = results.id;
	viewer.password = results.password;
	viewer.subscriptionId = results.subscriptionId;
	viewer.email = results.email;
	viewer.startDate = results.startDate;
	
	return viewer;
};

Viewer.prototype.getContent = function(viewerId) {
	pool.query(sql, function (error, results, fields) {
		if (error) {
			callback(error, null);
			return;
		}
		// console.log('results: ', results);
		if (results.length === 0) {
			callback(null, null);
			return;
		}
		
		var viewer = this.mapResults(results[0]);
		callback(null, viewer);
	}.bind(this));
};

module.exports = new Viewer();