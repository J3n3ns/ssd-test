from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/search", methods=['POST'])
def result():
    query = request.form['query']
    return render_template("result.html", query=query)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')