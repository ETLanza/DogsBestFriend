const express = require('express');
const router = express.Router();

const UserController = require('../controllers/user.controller');
const DogController = require('../controllers/dog.controller');
const WalkController = require('../controllers/walk.controller');

const custom = require('./../middleware/custom');

const passport = require('passport');
const path = require('path');

require('./../middleware/passport')(passport);
router.get('/', function(req, res, next) {
  res.json({status:"success", message:"DBF", data:{"version_number":"v1.0.0"}})
});

router.post('/users', UserController.create);

router.get('/users', passport.authenticate('jwt', {session: false}),
  UserController.get);

router.put('/users', passport.authenticate('jwt', {session: false}),
  UserController.update);

router.delete('/users', passport.authenticate('jwt', {session: false}),
  UserController.remove);

router.post('/users/login', UserController.login);

router.post('/dogs', passport.authenticate('jwt', {session: false}),
  DogController.create);

router.get('/dogs', passport.authenticate('jwt', {session: false}),
  DogController.getAll);

router.get('/dogs/:dog_id', passport.authenticate('jwt', {session: false}),
  custom.dog, DogController.get);

router.put('/dogs/:dog_id', passport.authenticate('jwt', {session: false}),
  custom.dog, DogController.update);

router.delete('/dogs/:dog_id', passport.authenticate('jwt', {session: false}),
  custom.dog, DogController.remove);

router.use('/docs/api.json', express.static(path.join(__dirname, '/../public/v1/documentation/api.json')));
router.use('/docs', express.static(path.join(__dirname, '/../public/v1/documentation/dist')));

module.exports = router;
