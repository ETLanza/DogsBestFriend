var express = require('express');
var app = express();
var port = process.env.PORT || 3005;
var mongoose = require('mongoose');
var Dog = require('./api/models/DogSchema');
var bodyParser = require('body-parser');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost/dbfdb');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var routes = require('./api/routes/DogRoutes');
routes(app);

app.listen(port);

console.log("DogsBestFriend RESTful API server started on: " + port);
