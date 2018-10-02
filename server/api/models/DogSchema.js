'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var DogSchema = new Schema({
  name: {
    type: String,
    required: 'The name of the dog'
  },
  Created_date: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Dog', DogSchema);
