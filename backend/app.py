from flask import Flask
from flask_cors import CORS  # Import CORS

app = Flask(__name__)
CORS(app)  # This enables CORS for all routes in your app


@app.route("/")
def hello():
    # We change this to return JSON data
    # The frontend will fetch and display this message
    return {"message": "Hello from the Python-Flask Backend!"}


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
