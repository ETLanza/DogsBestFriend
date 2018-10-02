'use strict';

var mongoose = require('mongoose');
var User = mongoose.model('User');

var LoggedInUsers = {}

exports.attempt_login = function(request, response) {
  User.findOne({ 'username' : request.params.username }, 'hashed_password', function(error, user) {
    if (error) {
      res.send(error);
    }
    console.log(user)
    if (request.params.hashed_password == user.hashed_password) {
      var token = request.params.username + "placeholder";
      LoggedInUsers[token] = user.userId; 
      response.send(token);
    } else {
      response.send("Failed to login.");
    }
  }); 
};


exports.create_user = function(request, response) {
  var new_user = new User(request.body);
  new_user.username = request.params.username;
  new_user.hashed_password = request.params.hashed_password;
  new_user.save(function(error, user) {
    if (error) {
      response.send(error);
    }
    response.json(user);
  });
}

exports.LoggedInUsers = {}
