'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var UserSchema = new Schema({
  name: {
    type: String,
    required: 'User name'
  },
  Created_date: {
    type: Date,
    default: Date.now
  },
  dogs: {
    type: [Dog]
  },
  hashed_password: {
    type: String
  }
});

module.exports = mongoose.model('User', UserSchema);
