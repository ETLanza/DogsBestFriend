const { Dog } = require('../models');
const { to, ReE, ReS } = require('../services/util.service');

const create = async function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  let err, dog;
  let user = req.user;

  let dog_info = req.body;

  [err, dog] = await to(Dog.create(dog_info));
  if (err) return ReE(res, err, 422);

  dog.addUser(user, { through: { status: 'started' }});

  [err, dog] = await to(dog.save());
  if (err) return ReE(res, err, 422);

  let dog_json = dog.toWeb();
  dog_json.users = [{user: user.id}];

  return ReS(res, {dog: dog_json}, 201);
}
module.exports.create = create;

const getAll = async function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  let user = req.user;
  let err, dogs;

  [err, dogs] = await to(user.getDogs());

  let dogs_json = [];
  for (let i in dogs) {
    let dog = dogs[i];
    let users = await dog.getUsers();
    let dog_info = dog.toWeb();
    let users_info = [];
    for (let j in users) {
      let user = users[j];
      // let user_info = user.toJSON();
      users_info.push({user: user.id});
    }
    dog_info.users = users_info;
    dogs_json.push(dog_info);
  }

  return ReS(res, {dogs: dogs_json});
}
module.exports.getAll = getAll;

const get = function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  let dog = req.dog;
  return ReS(res, {dog: dog.toWeb()});
}
module.exports.get = get;

const update = async function(req, res) {
  let err, dog, data;
  dog = req.dog;
  data = req.body;
  dog.set(data);

  [err, dog] = await to(dog.save());
  if (err) {
    return ReE(res, err);
  }
  return ReS(res, {dog: dog.toWeb()});
}
module.exports.update = update;

const remove = async function(req, res) {
  let dog, err;
  dog = req.dog;

  [err, dog] = await to(dog.destroy());
  if (err) return ReE(res, 'error occured trying to delete the company');

  return ReS(res, {message: 'Deleted dog'}, 204);
}
module.exports.remove = remove;

