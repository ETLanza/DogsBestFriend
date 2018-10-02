import flask
from flask_restful import reqparse
import flask_restful

app = flask.Flask(__name__)
api = flask_restful.Api(app)

dogs = [
    {"name": "Muffin", "age": 14, "breed": "Cocker/Poodle"},
    {"name": "Riley", "age": 9, "breed": "Cocker/Poodle"},
]


class Dog(flask_restful.Resource):
    def get(self, name):
        for dog in dogs:
            if name == dog["name"]:
                return dog, 200
        return "Dog not found", 404

    def post(self, name):
        parser = reqparse.RequestParser()
        parser.add_argument("age")
        parser.add_argument("breed")
        args = parser.parse_args()

        for dog in dogs:
            if name == dog["name"]:
                return f"dog with name {name} already exists.", 400

        dog = {"name": name, "age": args["age"], "breed": args["breed"]}
        dogs.append(dog)
        return dog, 201

    def put(self, name):
        parser = reqparse.RequestParser()
        parser.add_argument("age")
        parser.add_argument("breed")
        args = parser.parse_args()

        for dog in dogs:
            if name == dog["name"]:
                dog["age"] = args["age"]
                dog["breed"] = args["breed"]
                return dog, 200

        dog = {"name": name, "age": args["age"], "breed": args["breed"]}
        dogs.append(dog)
        return dog, 201

    def delete(self, name):
        global dogs
        dogs = [dog for dog in dogs if dog["name"] != name]
        return f"{name} is deleted.", 200


api.add_resource(Dog, "/dog/dog/<string:name>")
#app.run(debug=True)
app.run()
