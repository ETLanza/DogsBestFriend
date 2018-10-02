'use strict';

var mongoose = require('mongoose');
var User = mongoose.model('User');

exports.attempt_login = function(request, response) {
  User.findOne({ 'name' : request.params.username }, 'hashed_password', function(error, user) {
    if (error) {
      res.send(error);
    }
    if (request.params.password == user.hashed_password) {
      res.send("Successfully logged in.");
    } else {
      res.send("Failed to login.");
    }
  }); 
};

