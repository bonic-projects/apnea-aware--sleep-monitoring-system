from flask import Flask, request, jsonify
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier

app = Flask(__name__)

# Load data without header
data = pd.read_csv('data.csv', header=None, names=['beatAvg', 'sp02Avg', 'dB', 'status'])

# Encode categorical variable 'status'
label_encoder = LabelEncoder()
data['status'] = label_encoder.fit_transform(data['status'])

# Split data into features and target variable
X = data.drop('status', axis=1)
y = data['status']

# Initialize and train the model
model = RandomForestClassifier()
model.fit(X, y)

# Define API endpoint for making predictions
@app.route('/predict', methods=['POST'])
def predict():
    # Get data from request
    req_data = request.get_json()
    print(req_data)
    # Convert request data to list of dictionaries
    data_list = [req_data]

    # Create DataFrame
    new_data = pd.DataFrame(data_list)

    # Make predictions
    predicted_status = label_encoder.inverse_transform(model.predict(new_data))
    print("Predicted status:", predicted_status)
    predicted_probabilities = model.predict_proba(new_data)

    # Format predictions
    result = []
    for status, prob in zip(label_encoder.classes_, predicted_probabilities[0]):
        result.append({'status': status, 'probability': prob})

    return jsonify({'predictions': result})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)