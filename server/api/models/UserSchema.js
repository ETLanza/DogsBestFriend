'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var Dog = require('./DogSchema');

var UserSchema = new Schema({
  username: {
    type: String,
    required: 'Must supply a username'
  },
  firstName: {
    type: String,
  },
  lastName: {
    type: String,
  },
  Created_date: {
    type: Date,
    default: Date.now
  },
  hashed_password: {
    type: String,
    required: 'Must supply a password'
  }
});

module.exports = mongoose.model('User', UserSchema);
