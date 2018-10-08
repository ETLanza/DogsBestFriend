const express = require('express');
const logger = require('morgan');
const bodyParser = require('body-parser');
const passport = require('passport');
const pe = require('parse-error');
const cors = require('cors');

const v1 = require('./routes/v1');
const app = express();

const CONFIG = require('./config/config');

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use(passport.initialize());

const models = require("./models");
models.sequelize.authenticate().then(() => {
  console.log('Connected to SQL database:', CONFIG.db_name);
})
  .catch(error => {
    console.error('Unable to connect to SQL database:', CONFIG.db_name);
  });

if (CONFIG.app === 'dev') {
  models.sequelize.sync();
  // models.sequelize.sync({ force: true });
}

app.use(cors());

app.use('/v1', v1);

app.use('/', function(request, response) {
  response.statusCode = 200;
  response.json({status: "success", message: "Dogs Best Friend API", data: {}})
});

app.use(function(request, response, next) {
  var error = new Error('Not Found');
  error.status = 404;
  next(error);
});

// app.use(function(error, request, response, next) {
//   response.locals.message = error.message;
//   response.locals.error = request.app.get('env') === 'development' ? error: {};

//   response.status(error.status || 500);
//   response.render('error');
// });

module.exports = app;

process.on('unhandledRejection', error => {
  console.error('Uncaught Error', pe(error));
});
