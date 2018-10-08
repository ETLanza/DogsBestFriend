var express = require('express');
var app = express();
var port = process.env.PORT || 3005;

var Dog = require('./api/models/DogSchema');
var user = require('./api/models/UserSchema');

var bodyParser = require('body-parser');

const mongoose = require('mongoose');
const dbConfig = require('./config/database.config.js');

mongoose.Promise = global.Promise;
mongoose.connect(dbConfig.url, {
  useNewUrlParser: true
}).then(() => {
  console.log("Sucecessfully connected to the database");
}).catch(error => {
  console.log('Could not connec to the database. Exiting now...', error);
});

app.get('/', (request, response) => {
  response.json({"message": "Test"});
});

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
