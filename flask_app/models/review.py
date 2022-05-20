from flask_app.config.mysqlconnection import connectToMySQL
from flask_app.models.user import User
from flask_app import app
from flask import flash

class Review:
    db = "reviews_schema"
    def __init__(self, data):
        self.id = data["id"]
        self.title = data["title"]
        self.content = data["content"]
        self.created_at = data["created_at"]
        self.updated_at = data["updated_at"]
        self.user_id = data["user_id"]
        self.creator = None

    @classmethod
    def all_reviews(cls):
        query = "SELECT * FROM reviews;"
        all_revs = []
        results = connectToMySQL(cls.db).query_db(query)
        for row in results:
            all_revs.append(row)
        return all_revs

    @classmethod
    def all_revs_with_user(cls):
        query = "SELECT * FROM reviews JOIN users ON reviews.user_id = users.id;"
        results = connectToMySQL(cls.db).query_db(query)
        all_revs = []
        for row in results:
            review = cls(row)
            reviewer_data = {
                "id" : row["users.id"],
                "first_name" : row["first_name"],
                "last_name" : row["last_name"],
                "email" : row["email"],
                "password" : row["password"],
                "created_at" : row["created_at"],
                "updated_at" : row["updated_at"]
            }
            reviewer = User(reviewer_data)
            review.creator = reviewer
            all_revs.append(review)
        return all_revs

    @classmethod
    def single_user_revs(cls, data):
        query = "SELECT * FROM reviews WHERE user_id = %(id)s"
        results = connectToMySQL(cls.db).query_db(query)
        user_revs = []
        for row in results:
            user_revs.append(row)
        return user_revs

    @classmethod
    def rev_by_id(cls, data):
        query = "SELECT * FROM reviews WHERE id = %(id)s;"
        results = connectToMySQL(cls.db).query_db(query,data)
        if len(results) < 1:
            return False
        return cls(results[0])

    @classmethod
    def save_rev(cls, data):
        query = "INSERT INTO reviews (title, content, created_at, updated_at, user_id) VALUES (%(title)s, %(content)s, NOW(), NOW(), %(user_id)s);"
        return connectToMySQL(cls.db).query_db(query, data)

    @classmethod
    def update_rev(cls, data):
        query = "UPDATE reviews SET title = %(title)s, content = %(content)s;"
        return connectToMySQL(cls.db).query_db(query, data)

    @classmethod
    def delete_rev(cls, data):
        query = "DELETE FROM reviews WHERE id = %(id)s;"
        return connectToMySQL(cls.db).query_db(query, data)

    @staticmethod
    def validate_rev(rev):
        is_valid = True
        if len(rev["title"]) < 2:
            flash("Title must be at least 2 characters")
            is_valid = False
        if len(rev["content"]) < 2:
            flash("Content must be at least 2 characters")
            is_valid = False
        return is_valid