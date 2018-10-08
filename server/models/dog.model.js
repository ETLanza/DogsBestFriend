const {TE, to} = require('../services/util.service');

module.exports = (sequelize, DataTypes) => {
  var Model = sequelize.define('Dog', {
    name: DataTypes.STRING
  });

  Model.associate = function(models) {
    this.Owner = this.belongsToMany(models.User, {through: 'UserDogs'});
  };

  Model.prototype.toWeb = function(pw) {
    let json = this.toJSON();
    return json;
  };
  return Model;
};
