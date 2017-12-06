var mysql = require('mysql');

var pool  = mysql.createPool({
	connectionLimit : 10,
	host            : 'localhost',
	user            : 'root',
	password        : 'mysql',
	database        : 'CMPE226_SPARTAN_FLIX'
});

module.exports = pool;
