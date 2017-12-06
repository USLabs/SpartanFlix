var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var index = require('./routes/index');
var viewerRouter = require('./routes/ViewerRouter');
var contentProviderRouter = require('./routes/ContentProviderRouter');
var contentRouter = require('./routes/ContentRouter');
var adminRouter = require('./routes/AdminRouter');
var advertiserRouter = require('./routes/AdvertiserRouter');
var extra = require('./routes/extra');
var mongo = require('./routes/mongoConnection');

var winston = require('winston');
var cors = require('cors');
winston.level = 'info';

/*********** Cors settings *************/
var corsOptions = {
	origin: '*',
	credentials: true,
	optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
};
/*********** Cors Settings *************/

var app = express();

app.use(cors(corsOptions));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// create a custom timestamp format for log statements
var SimpleNodeLogger = require('simple-node-logger');
var opts = {
		logFilePath:'cmpe226_server.log',
		timestampFormat:'YYYY-MM-DD HH:mm:ss.SSS'
	};
var log = SimpleNodeLogger.createSimpleLogger( opts );
app.use(function(req, res, next) {
	log.info(req.url + ':' + JSON.stringify(req.body));
	next();
});
/** Request handling **/
app.use('/', index);
app.use('/viewer', viewerRouter);
app.use('/content', contentRouter);
app.use('/admin', adminRouter);
app.use('/adProvider', advertiserRouter);
app.use('/contentProvider', contentProviderRouter);
/** Request handing **/

app.use('/extraurl', extra.sendActivity);



// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
