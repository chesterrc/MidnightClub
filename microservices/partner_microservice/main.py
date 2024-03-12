import firebase_admin
from firebase_admin import credentials, firestore, initialize_app
from flask import Blueprint, Flask, jsonify, request
from flask_cors import CORS, cross_origin

#initialize Flask app
app = Flask(__name__)
CORS(app, supports_credentials=True)
cred = credentials.Certificate("../credentials.json")
default_app = firebase_admin.initialize_app(cred)

#database configuration
db = firestore.client()
user_ref = db.collection('users')

# Index post request handler
@app.route('/rewards', methods=['GET','PUT'])
@cross_origin(supports_credentials=True)
def update_rewards():
    if request.method == 'GET':
        try:
            _uid = request.json['uid']
            if _uid:
                reward_doc = user_ref.document(_uid).get()
                if reward_doc.exists:
                    rewards_json = jsonify(reward_doc.to_dict())
                    # convert reward, mileage, attendance to string
                    reward = str(rewards_json['reward'])
                    mileage = str(rewards_json['mileage'])
                    attendance = str(rewards_json['attendance'])

                    #create lib make it json
                    user_data = {'reward':reward,
                    'mileage':mileage,
                    'attendance':attendance}

                    return jsonify(user_data)
                    
        except Exception as e:
            return f"An Error Occured {e}"
    
    if request.method == 'PUT':
        try:
            _uid = request.json['uid']
            req = request.json
            reward_doc = user_ref.document(_uid).get()
            if reward_doc.exists:
                rewards_json = reward_doc.to_dict()

                if req['reward'] != "None":
                    reward = float(req['reward'])
                else:
                    reward = rewards_json['reward']
                if req['mileage'] != "None":
                    mileage = float(req['mileage'])
                    # $1 reward per mile
                    if mileage > 0:
                        reward += mileage / 100
                else:
                    mileage = rewards_json['mileage']
                if req['attendance'] != "None":
                    attendance = int(req['attendance'])
                    # $20 reward per event attended
                    if attendance > 0:
                        reward += attendance * 20
                else:
                    attendance = rewards_json['attendance']

                updated_rewards = {
                    'reward':reward,
                    'mileage':mileage,
                    'attendance':attendance
                }
                user_ref.document(_uid).update(updated_rewards)
            
                return jsonify({"success":True}), 200
        except Exception as e:
            return f"An Error Occured {e}"

if __name__ == '__main__':
    app.run()