/**
 * Created by rohankankapurkar on 5/12/17.
 */

var mongo = require("./mongoConnection");


var mongoURL = "mongodb://localhost:27017/spartanflix";

function putToMongo (){
    console.log("Hello");
} ;

//var mongoURL = "mongodb://cluste0-shard-00-00-fy76c.mongodb.net:27017,cluste0-shard-00-01-fy76c.mongodb.net:27017,cluste0-shard-00-02-fy76c.mongodb.net:27017/CMPE281?replicaSet=Cluste0-shard-0";
exports.sendActivity = function(req,res) //redirect function to the homepage
{

    console.log("I am inside node tweet ");

    var column1 = 'beta';
    var theta = 'delta';


    mongo.connect(mongoURL, function(err, db){
        console.log("inside coonect mongo function");
        var coll = mongo.collection('tweets');

        console.log("above mongo ");
        coll.insert({"beta" : alpha, "theta": theta }, function(err, user){
            if (user) {
                console.log("Tweet added successfully");

                //res.json({msg: req.session.email[0].email});
            } else {
                console.log("returned false");
                res.code = 401;
                res.value = "Failed Login";
            }
        });

    });
};