import flask
import flask_restful

app = flask.Flask(__name__)
api = flask_restful.Api(app)

users = [{"name": "Nathan", "age": 30, "occupation": "Software Engineer"}]


class User(flask_restful.Resource):
    def get(self, name):
        for user in users:
            if name == user["name"]:
                return user, 200
        return "User not found", 404

    def post(self, name):
        parser = flask_restful.reqparse.RequestParser()
        parser.add_argument("age")
        parser.add_argument("occupation")
        args = parser.parse_args()

        for user in users:
            if name == user["name"]:
                return f"User with name {name} already exists.", 400

        user = {"name": name, "age": args["age"], "occupation": args["occupation"]}
        users.append(user)
        return user, 201

    def put(self, name):
        parser = reqparse.RequestParser()
        parser.add_argument("age")
        parser.add_argument("occupation")
        args = parser.parse_args()

        for user in users:
            if name == user["name"]:
                user["age"] = args["age"]
                user["occupation"] = args["occupation"]
                return user, 200

        user = {"name": name, "age": args["age"], "occupation": args["occupation"]}
        users.append(user)
        return user, 201

    def delete(self, name):
        global users
        users = [user for user in users if user["name"] != name]
        return "{} is deleted.".format(name), 200


api.add_resource(User, "/user/<string:name>")
app.run(debug=True)
