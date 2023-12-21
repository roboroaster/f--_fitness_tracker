#Imports
import datetime
import firebase_admin
import pyrebase
import json
from firebase_admin import credentials, auth, firestore
from flask import Flask, request, session
import jwt as jsonwebtoken
import pprint
import google.generativeai as palm
palm.configure(api_key='YOUR_API_KEY')
models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
# model = models[0].name
model = palm.GenerativeModel('gemini-pro')
print(model)
#App configuration
app = Flask(__name__)
#Connect to firebase
# download the firebase  config and credentials and add the json into the project directory
cred = credentials.Certificate('fbAdminConfig.json') 
firebase = firebase_admin.initialize_app(cred)
pb = pyrebase.initialize_app(json.load(open('fbconfig.json')))

#Data source
db = firestore.client()
#Api route to sign up a new user
@app.route('/api/signup', methods=['POST'])
def signup():
    data = request.get_json()
    # email = request.form.get('email')
    # password = request.form.get('password')
    email = data['email']
    password = data['password']
    name = data['name']
    if email is None or password is None:
        return {'message': 'Error missing email or password'},400
    try:
        user = auth.create_user(
               email=email,
               password=password,
                display_name=name,
        )
        return {'message': f'Successfully created user {user.uid}'},200
    except Exception as e:
        print(str(e))
        return {'message': 'Error creating user'},400
#Api route to get a new token for a valid user
@app.route('/api/login', methods=['POST'])
def token():
    data = request.get_json()
    # email = request.form.get('email')
    # password = request.form.get('password')
    email = data['email']
    password = data['password']
    try:
        user = pb.auth().sign_in_with_email_and_password(email, password)
        global person
        
        jwt = user['idToken']
        
        person = pb.auth().get_account_info(user['idToken'])
        print(person)
        return {'message': "logged in successfully",'token': jwt}, 200
    except Exception as e:
        print(str(e))
        return {'message': 'There was an error logging in'},400

# Fetch APIs

@app.route('/api/get-user-details', methods=['POST'])
def getUserDetails():
    # token = request.headers.get('Authorization')
    try:
        user = request.get_json()
        person = pb.auth().get_account_info(user['idToken'])
        # decoded_token = auth.verify_id_token(token)
        # uid = decoded_token['uid']
        print(person)
        uid = person['users'][0]['localId']
        
        return {'message': f'Valid token for user {uid}'},200
    except Exception as e:
        print(str(e))
        return {'message': 'Invalid token'},400

#* Get AI Response
@app.route('/api/get-ai-response', methods=['POST'])
def getAiResponse():
    data = request.get_json()
    # saving user ai form preferences
    # user = session['user']
            # print(user)
    person = pb.auth().get_account_info(user['idToken'])
    # print(person)
    uid = person['users'][0]['localId']
    doc_ref = db.collection('user_ai_preferences').document(uid)
    doc_ref.set(data)
    
    # getting ai response
    prompt = f"""
User Profile:
Age: {data['user_info']['age']}
Gender: {data['user_info']['gender']}
Height: {data['user_info']['height']}
Weight: {data['user_info']['weight']}
Fitness Goals: {data['user_info']['fitness_goals']}
Medical History: {data['user_info']['medical_history']}
Activity Level: {data['user_info']['activity_level']}

Dietary Preferences:
Dietary Preference: {data['diet_pref']['pref']}
Allergies: {data['diet_pref']['allergies']}

Workout Preferences:
Fitness Level: {data['workout_pref']['level']}
Workout Frequency: {data['workout_pref']['freq']} days per week
Workout Duration: {data['workout_pref']['duration']}
Preferred Workout Types: {data['workout_pref']['type']}
Equipment Availability: {data['workout_pref']['equipment_availability']}
Workout Intensity: {data['workout_pref']['intensity']} intensity

Based on the provided user profile information and workout preferences, please generate a personalized workout and diet plan for the user in a 'markdown format' specifically. Consider their fitness goals, activity level, dietary preferences, allergies, and available workout equipment. Include details such as recommended exercises, sets, repetitions, meal suggestions, and any additional tips for staying motivated.The goal is to create a realistic and achievable plan tailored to the user's needs and goals. Be creative with the plan and donot repeat the same plan more than twice.Also, strictly adhere to what the user is asking when it give the diet preference for example, if the user asks for a vegetarian diet, then please only provide a diet plan with vegetarian meals only accordingly, properly consider the type of diet is being asked for and please suggest meals according the the North indian culture too . Thank you!
"""
    try:

        completion = palm.generate_text(
            model=model,
            prompt=prompt,
            temperature=0,
            # The maximum length of the response
            max_output_tokens=800,
        )
        print(completion.result)
        return {'message': completion.result},200
    except Exception as e:
        print(str(e))
        return {'message':str(e)},500


@app.route('/api/get-user-track-details', methods=['POST'])

async def getUserTrackDetails():
    data = request.json
    print(data)
    doc_ref = db.collection('user_track_data').document(data['user_id'])
    doc = doc_ref.get()
    if doc.exists:
        data = doc.to_dict()
        if data['dates'][str(datetime.date.today())]:
            return {'message':data['dates'][str(datetime.date.today())]},200 
    else:
        doc_ref.set({f'dates.{str(datetime.date.today())}':{
        "calorie_goal" : "2000",
        "calorie_consumed" : "0",
        "items-consumed": []
        }})
        return {'message':'No data found, adding empty payload'},200
        
    # doc_ref = db.collection('user_track_data').document(data['user_id']).collection(str(datetime.date.today())).document(str(datetime.date.today()))
    # # doc_ref = db.collection('user_track_data').document(data['user_id']).collection('2023-10-21').document('2023-10-21')
    # doc = doc_ref.get()
    # if doc.exists:
    #     print(doc.to_dict())
    #     doc.to_dict()
    #     return {'message':doc.to_dict()},200
    # else:
    #     doc_ref.set({
    #     "uid" : data['user_id'],
    #     "calorie_goal" : "2000",
    #     "calorie_consumed" : "0",
    #     "items-consumed":[]
    #     })
    #     return {'message':'No data found, adding empty payload'},200

@app.route('/api/get-workout-routine', methods=['POST'])

def getWorkoutRoutine():
    pass


# Submission APIs

# @app.route('/api/save-ai-response',methods=['POST'])

# def saveAiResponse():
#     pass
#* Save user Track Details
@app.route('/api/save-user-track-details',methods=['POST'])

async def saveUserTrackDetails():
    data=request.json
    doc_ref = db.collection('user_track_data').document(data['user_id'])
    if doc_ref.get().exists:
        doc_ref.update(
        {f'dates.{str(datetime.date.today())}':{
        "calorie_goal" : data['calorie_goal'],
        "calorie_consumed" : data['calorie_consumed'],
        "items-consumed": data['items-consumed']
        }})
        return {'message': 'data updated successfully'},200
    else:
        doc_ref.set({
        "uid" : data['user_id'],
        "dates":{
        str(datetime.date.today()):{
        "calorie_goal" : data['calorie_goal'],
        "calorie_consumed" : data['calorie_consumed'],
        "items-consumed": data['items-consumed']
        }
        }
        })
        return {'message': 'data saved successfully'},200
    # doc_ref = db.collection('user_track_data').document(data['user_id']).collection(str(datetime.date.today())).document(str(datetime.date.today()))
    # # doc_ref = db.collection('user_track_data').document(data['user_id']).collection('2023-10-21').document('2023-10-21')
    
    # doc_ref.set({
    # "uid" : data['user_id'],
    # "calorie_goal" : data['calorie_goal'],
    # "calorie_consumed" : data['calorie_consumed'],
    # "items-consumed": data['items-consumed']
    # })
    # return {'message': 'data saved successfully'},200

#* Save AI Response 
@app.route('/api/save-ai-response', methods=['POST'])
def saveAiResponse():
    data = request.get_json()
    try:
        if "user" in session:
            user = session['user']
            # print(user)
            person = pb.auth().get_account_info(user['idToken'])
            print(person)
            uid = person['users'][0]['localId']
            doc_ref = db.collection('ai_response').document(uid)
            doc_ref.set(data)
            return {'message': "data saved successfully"}, 200
        else:
            return {'message': "there was an error, either look that if you're logged in or just see what the error is "}, 400

    except Exception as e:
        print(str(e))
        return {"error" : str(e)}
        
@app.route('/api/save-user-preferences',methods=['POST'])
def saveUserPreferences():
    pass



if __name__ == '__main__':
    app.run(debug=True)