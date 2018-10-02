'use strict';
module.exports = function(app) {
  var DogController = require('../controllers/DogController');

  app.route('/dogs')
    .get(DogController.get_all_dogs)
    .post(DogController.create_a_dog);

  app.route('/dogs/:dogId')
    .get(DogController.get_a_dog)
    .put(DogController.update_a_dog)
    .delete(DogController.delete_a_dog);
};
