var express = require('express');
var app = express();
var port = process.env.PORT || 3005;
var mongoose = require('mongoose');

var Dog = require('./api/models/DogSchema');
var user = require('./api/models/UserSchema');

var bodyParser = require('body-parser');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost/dbfdb');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var dogRoutes = require('./api/routes/DogRoutes');
dogRoutes(app);

var userRoutes = require('./api/routes/UserRoutes');
userRoutes(app); 

var loginRoutes = require('./api/routes/LoginRoutes');
loginRoutes(app);

app.listen(port);

console.log("DogsBestFriend RESTful API server started on: " + port);
