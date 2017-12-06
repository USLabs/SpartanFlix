var MongoClient = require('mongodb').MongoClient;

function putToMongo(arg1, arg2){

    var url = "mongodb://localhost:27017/spartanflix";
    MongoClient.connect(url, function (err, db) {
        var coll = db.collection('log');
        coll.insert({'request': {'url': arg1.baseUrl+ arg1.url, 'body': arg1.body, 'method': arg1.method}, 'response': arg2}, function(err, user){
            if (user) {
                console.log("Tweet added successfully");
                //res.json({msg: req.session.email[0].email});
            } else {
                console.log("returned false");
            }
        });

    });

    /*
    var url = "mongodb://localhost:27017/spartanflix";
    MongoClient.connect(url, function (err, db) {
        if (err) throw err;
        db.collection("tweets").findOne({}, function (err, result) {
            if (err) throw err;
            db.close();
            res.status(200).json(result);
        });
    });
    */
};

module.exports = {
    putToMongo:putToMongo
};