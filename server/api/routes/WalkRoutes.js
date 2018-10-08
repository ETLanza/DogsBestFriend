'use strict';
module.exports = function(app) {
  var WalkController = require('../controllers/WalkController');

  app.route('/walks')
    .get(WalkController.get_all_walks)
    .post(WalkController.create_a_walk);

  app.route('/walks/:walkId')
    .get(WalkController.get_a_walk)
    .put(WalkController.update_a_walk)
    .delete(WalkController.delete_a_walk);
};
