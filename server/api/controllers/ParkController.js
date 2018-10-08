'use strict';

var mongoose = require('mongoose');
var Park = mongoose.model('Park');

exports.get_all_parks = function(req, res) {
  Park.find({}, function(err, park) {
    if (err) {
      res.send(err);
    }
    res.json(park);
  });
};

exports.create_a_park = function(req, res) {
  var new_park = new Park(req.body);
  new_park.save(function(err, park) {
    if (err) {
      res.send(err);
    }
    res.json(park);
  });
}

exports.get_a_park = function(request, response) {
  Park.findById(request.params.parkId, function(error, park) {
    if (error) {
      response.send(error);
    }
    response.json(park);
  });
};

exports.update_a_park = function(request, response) {
  Park.findOneAndUpdate({_id: request.params.parkId}, request.body, {new: true},
    function(error, park) {
      if (error) {
        response.send(error);
      }
      response.json(park);
    });
};

exports.delete_a_park = function(request, response) {
  Park.remove({
    _id: request.params.parkId
  }, function(error, park) {
    if (error) {
      response.send(error);
    }
    response.json({ message: "Park successfully deleted" });
  });
};


