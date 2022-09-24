from distutils.log import debug
from glob import glob
import re
import sqlite3

from flask import Flask, jsonify, json, render_template, request, url_for, redirect, flash
from werkzeug.exceptions import abort
from flask import jsonify

import logging
import sys

post_count = 0


# Function to get a database connection.
# This function connects to database with the name `database.db`
def get_db_connection():
    connection = sqlite3.connect('database.db')
    connection.row_factory = sqlite3.Row
    global post_count
    post_count = post_count + 1
    return connection


# Function to get a post using its ID
def get_post(post_id):
    connection = get_db_connection()
    post = connection.execute('SELECT * FROM posts WHERE id = ?',
                              (post_id, )).fetchone()
    app.logger.info(post)
    connection.close()
    return post


# Define the Flask application
app = Flask(__name__)
app.config['SECRET_KEY'] = 'your secret key'


# Define the main route of the web application
@app.route('/')
def index():
    connection = get_db_connection()
    posts = connection.execute('SELECT * FROM posts').fetchall()
    connection.close()
    return render_template('index.html', posts=posts)


# Define how each individual article is rendered
# If the post ID is not found a 404 page is shown
@app.route('/<int:post_id>')
def post(post_id):
    post = get_post(post_id)
    if post is None:
        app.logger.info("Non-Existing Article")
        logger.info("404 - Article does not exists")
        logger.addHandler(h1)
        logger.addHandler(h2)
        return render_template('404.html'), 404
    else:
        logger.info('Article "%s" retrieved!', post['title'])
        return render_template('post.html', post=post)


# Define the About Us page
@app.route('/about')
def about():
    app.logger.info("/About Request Succesfully")
    logger.info("About Us")
    logger.addHandler(h1)
    logger.addHandler(h2)
    return render_template('about.html')


# Define the post creation functionality
@app.route('/create', methods=('GET', 'POST'))
def create():
    if request.method == 'POST':
        title = request.form['title']
        content = request.form['content']

        if not title:
            flash('Title is required!')
        else:
            connection = get_db_connection()
            connection.execute(
                'INSERT INTO posts (title, content) VALUES (?, ?)',
                (title, content))
            connection.commit()
            connection.close()

            return redirect(url_for('index'))

    return render_template('create.html')


# Define healthz
@app.route('/healthz', methods=['GET'])
def healthz():
    data = {'result': 'OK - healthy'}
    return jsonify(data), 200


# Define metrics
@app.route('/metrics', methods=['GET'])
def metrics():
    global post_count
    connection = get_db_connection()
    post = connection.execute('SELECT * FROM posts').fetchone()
    db_connection_count = len(post)
    connection.close()
    data = {
        "db_connection_count": db_connection_count,
        "post_count": post_count
    }
    return jsonify(data), 200


# start the application on port 3111
if __name__ == "__main__":
    # logger = logging.getLogger("__name__")
    # logging.basicConfig(filename='app.log', level=logging.DEBUG)
    # h1 = logging.StreamHandler(sys.stdout)
    # h1.setLevel(logging.DEBUG)
    # h2 = logging.StreamHandler(sys.stderr)
    # h2.setLevel(logging.ERROR)
    logger = logging.getLogger("__name__")
    logging.basicConfig(level=logging.DEBUG)
    h1 = logging.StreamHandler(sys.stdout)
    h1.setLevel(logging.DEBUG)
    h2 = logging.StreamHandler(sys.stderr)
    h2.setLevel(logging.ERROR)
    logger.addHandler(h1)
    logger.addHandler(h2)
    app.run(host='0.0.0.0', port='3111', debug=True)
