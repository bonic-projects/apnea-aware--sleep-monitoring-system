from firebase_admin import credentials, initialize_app, db
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier

# Load data without header
data = pd.read_csv('data_final.csv', header=None, names=['beatAvgDiff', 'sp02AvgDiff', 'dB', 'status'])

# Encode categorical variable 'status'
label_encoder = LabelEncoder()
data['status'] = label_encoder.fit_transform(data['status'])

# Split data into features and target variable
X = data.drop('status', axis=1)
y = data['status']

# Initialize and train the model
model = RandomForestClassifier()
model.fit(X, y)

# Set the credentials to access Firebase
cred = credentials.Certificate('apneaaware-firebase-adminsdk-596tn-ec93b317fa.json')
# Initialize the app with a custom database URL
options = {
    'databaseURL': 'https://apneaaware-default-rtdb.firebaseio.com/'
}
initialize_app(cred, options)
refPredictions = db.reference("/devices/plX7kE7mAQQ5YgcKRsjp5b6t8Ac2/ml")
ref = db.reference("/devices/plX7kE7mAQQ5YgcKRsjp5b6t8Ac2/reading/")

# Define API endpoint for making predictions
def predict(req_data):
    print("NEW REQUEST")
    print(req_data)
    # Extract JSON data and convert it to DataFrame
    new_data = pd.DataFrame([req_data])

    # Make predictions
    predicted_status = label_encoder.inverse_transform(model.predict(new_data))
    print("Predicted status:", predicted_status)
    predicted_probabilities = model.predict_proba(new_data)

    # Format predictions
    result = []
    for status, prob in zip(label_encoder.classes_, predicted_probabilities[0]):
        result.append({'status': status, 'probability': prob})

    return ({'predictions': result})

# Listen to the database changes
def on_data_change(event):
    print("New data")
    data = event.data
    print(data)
    # Pass the data to the predict function
    json = ({
          'beatAvgDiff': data.get('beatAvgDiff'),
          'sp02AvgDiff': data.get('sp02AvgDiff'),
          'dB': data.get('dB'),
    })
    result = predict(json)
    refPredictions.set(result)


ref.listen(on_data_change)
