var express = require('express');
var app = express();
var port = process.env.PORT || 3005;
var mongoose = require('mongoose');

var Dog = require('./api/models/DogSchema');
var User = require('./api/models/UserSchema');
var Park = require('./api/models/ParkSchema');
var Walk = require('./api/models/WalkSchema');

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

var walkRoutes = require('./api/routes/WalkRoutes');
walkRoutes(app);

var parkRoutes = require('./api/routes/ParkRoutes');
parkRoutes(app);

app.listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});
