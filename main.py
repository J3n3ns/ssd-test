from flask import Flask, render_template, request, redirect, url_for
import re

app = Flask(__name__)

def check_content(query) -> list:
    regex = r'''^[A-Za-z0-9 ]+$'''
    temp_data = str(query).strip()

    ptn = re.compile(regex)

    if not bool(ptn.search(temp_data)):
        return False

    else:
        return temp_data

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/search", methods=['POST'])
def result():
    query = request.form['query']
    if check_content(query):
        return render_template("result.html", query=query)
    else:
        return redirect(url_for("home"))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')