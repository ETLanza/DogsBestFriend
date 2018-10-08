'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var WalkSchema = new Schema({
  name: {
    type: String,
    required: 'The name of the walk'
  },
  Created_date: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Walk', WalkSchema);
