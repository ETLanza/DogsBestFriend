'use strict';
module.exports = function(app) {
  var LoginController = require('../controllers/LoginController');

  app.route('/login/:username/:hashed_password')
    .get(LoginController.attempt_login)
};
