'use strict';

var mongoose = require('mongoose');
var Walk = mongoose.model('Walk');

exports.get_all_walks = function(req, res) {
  Walk.find({}, function(err, walk) {
    if (err) {
      res.send(err);
    }
    res.json(walk);
  });
};

exports.create_a_walk = function(req, res) {
  var new_walk = new Walk(req.body);
  new_walk.save(function(err, walk) {
    if (err) {
      res.send(err);
    }
    res.json(walk);
  });
}

exports.get_a_walk = function(request, response) {
  Walk.findById(request.params.walkId, function(error, walk) {
    if (error) {
      response.send(error);
    }
    response.json(walk);
  });
};

exports.update_a_walk = function(request, response) {
  Walk.findOneAndUpdate({_id: request.params.walkId}, request.body, {new: true},
    function(error, walk) {
      if (error) {
        response.send(error);
      }
      response.json(walk);
    });
};

exports.delete_a_walk = function(request, response) {
  Walk.remove({
    _id: request.params.walkId
  }, function(error, walk) {
    if (error) {
      response.send(error);
    }
    response.json({ message: "Walk successfully deleted" });
  });
};
