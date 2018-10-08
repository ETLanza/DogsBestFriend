'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var ParkSchema = new Schema({
  name: {
    type: String,
    required: 'The name of the park'
  },
  Created_date: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Park', ParkSchema);
