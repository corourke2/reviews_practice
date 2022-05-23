from flask_app.models.user import User
from flask_app.models.review import Review
from flask_bcrypt import Bcrypt
from flask_app import app
from flask import render_template, redirect, request, session, flash

bcrypt = Bcrypt(app)

@app.route("/")
def login_page():
    return render_template("login.html")

@app.route("/dashboard")
def dashboard():
    data = {
        "id" : session["user_id"]
    }
    user = User.user_by_id(data)
    all_revs = Review.all_reviews()
    return render_template("dashboard.html", user = user, all_revs = all_revs)

@app.route("/users/save", methods=["post"])
def save_user():
    pass

@app.route("/users/login", methods=["post"])
def login():
    pass

@app.route("/logout")
def logout():
    session.clear
    return redirect("/")