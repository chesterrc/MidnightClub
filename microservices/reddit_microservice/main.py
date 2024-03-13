import os
from collections import defaultdict

import cv2
import dotenv
import numpy as np
import praw
import requests
import requests.auth
from dotenv import load_dotenv
from flask import Flask, jsonify

#initiate flask
app = Flask(__name__)

# Generate reddit instance
_reddit = praw.Reddit(
    client_id = os.getenv("REDDIT_ID"),
    client_secret= os.getenv("REDDIT_SECRET"),
    user_agent= f"Mozilla/5.0 by {os.getenv('USERNAME')}",
)

load_dotenv()

#route for feed
@app.route('/')
def feed():
    submit_lib = {}
    json_pass = {}
    for submits in _reddit.subreddit("jdm").new(limit=10):
        if submits.id not in submit_lib:
            #store the values
            submit_lib[submits.id] = submits
            json_pass[submits.id] = {}
            json_pass[submits.id]["author"] = submits.author
            json_pass[submits.id]["name"] = submits.name
            json_pass[submits.id]["score"] = submits.score
            #Check if post has text
            if submits.selftext != "":
                json_pass[submits.id]["selftext"] = submits.selftext
            else:
                json_pass[submits.id]["selftext"] = "None"
            #check if post has an image and save it
            if "jpg" in submits.url.lower() or "png" in submits.url.lower():
                json_pass[submits.id]["image"] = submits.url
            else:
                json_pass[submits.id]["image"] = "None"

    return jsonify({"success":True}), 200

if __name__ == '__main__':
	app.run(debug=True, port=8000)