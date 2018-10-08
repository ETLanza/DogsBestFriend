'use strict';
module.exports = function(app) {
  var ParkController = require('../controllers/ParkController');

  app.route('/parks')
    .get(ParkController.get_all_parks)
    .post(ParkController.create_a_park);

  app.route('/parks/:parkId')
    .get(ParkController.get_a_park)
    .put(ParkController.update_a_park)
    .delete(ParkController.delete_a_park);
};
