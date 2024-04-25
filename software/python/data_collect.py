from firebase_admin import credentials, initialize_app, db
import csv

# Set the credentials to access Firebase
cred = credentials.Certificate('apneaaware-firebase-adminsdk-596tn-ec93b317fa.json')
# Initialize the app with a custom database URL
options = {
    'databaseURL': 'https://apneaaware-default-rtdb.firebaseio.com/'
}
initialize_app(cred, options)

# Get a reference to the database service
ref = db.reference("/devices/plX7kE7mAQQ5YgcKRsjp5b6t8Ac2/reading/")

# Define the CSV file name and header row
csv_file = 'data_final.csv'
header = ['beatAvgDiff', 'sp02AvgDiff', 'dB', 'status']

conditionIn = 'normal' #normal, hypopnea, apnea
# Listen to the database changes
def on_data_change(event):
    print("New data")
    global conditionIn
    data = event.data
    print(data)

    if data.get('dB') > 32 or (data.get('sp02AvgDiff') > 30 and data.get('beatAvgDiff') > 30): #apnea
        conditionIn = 'apnea'
    elif data.get('dB') < 30 and (data.get('sp02AvgDiff') > 10 and data.get('sp02AvgDiff') < 30) and (data.get('beatAvgDiff') > 10 and  data.get('beatAvgDiff') < 30): #hypopnea
        conditionIn = 'hypopnea'
    else:
    # if data.get('dB') < 30 and (data.get('sp02AvgDiff') < 10 or data.get('beatAvgDiff') < 10): #normal
        conditionIn = 'normal'
    row = [data.get('beatAvgDiff'), data.get('sp02AvgDiff'), data.get('dB'), conditionIn]
    with open(csv_file, mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(row)
        print('Data saved to CSV:', row)
        
ref.listen(on_data_change)