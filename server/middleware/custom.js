const Dog = require('./../models').Dog;
const { to, ReE, ReS } = require('../services/util.service');

let dog = async function(req, res, next) {
  let dog_id, err, dog;
  dog_id = req.params.dog_id;

  [err, dog] = await to(Dog.findOne({where: {id:dog_id}}));
  if (err) return ReE(res, "Error finding dog");

  if (!company) return ReE(res, `Dog not found with id: ${dog_id}`);

  let user, users_array, users;
  user = req.user;
  [err, users] = await to(dog.getUsers());

  users_array = users.map(obj => String(obj.user));

  if (!users_array.includes(String(user._id)))
    return ReE(res, "User does not have permission to read app with id: " + app_id);

  req.dog = dog;
  next();
}

module.exports.dog = dog;
