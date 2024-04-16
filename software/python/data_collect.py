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
ref = db.reference("/devices/lSfWVwRHbXeU3bitqGDy95fGyG12/reading/")

# Define the CSV file name and header row
csv_file = 'data.csv'
header = ['avgBpm', 'status']

conditionIn = 'normal' #normal, hypopnea, apnea
# Listen to the database changes
def on_data_change(event):
    print("New data")
    global conditionIn
    data = event.data
    # if(data.get('condition')!=None):
    #     conditionIn = data.get('condition')
    row = [data.get('avgBpm'), conditionIn]
    if data.get('avgBpm') != 0: # and data.get('ec') != 0: #and list(data.values()) != last_row:
        with open(csv_file, mode='a', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(row)
        print('Data saved to CSV:', row)
ref.listen(on_data_change)