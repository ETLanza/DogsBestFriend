'use strict';

var mongoose = require('mongoose');
var Dog = mongoose.model('Dog');

exports.get_all_dogs = function(req, res) {
  Dog.find({}, function(err, dog) {
    if (err) {
      res.send(err);
    }
    res.json(dog);
  });
};

exports.create_a_dog = function(req, res) {
  var new_dog = new Dog(req.body);
  new_dog.save(function(err, dog) {
    if (err) {
      res.send(err);
    }
    res.json(dog);
  });
}

exports.get_a_dog = function(request, response) {
  Dog.findById(request.params.dogId, function(error, dog) {
    if (error) {
      response.send(error);
    }
    response.json(dog);
  });
};

exports.update_a_dog = function(request, response) {
  Dog.findOneAndUpdate({_id: request.params.dogId}, request.body, {new: true},
    function(error, dog) {
      if (error) {
        response.send(error);
      }
      response.json(dog);
    });
};

exports.delete_a_dog = function(request, response) {
  Dog.remove({
    _id: request.params.dogId
  }, function(error, dog) {
    if (error) {
      response.send(error);
    }
    response.json({ message: "Dog successfully deleted" });
  });
};
