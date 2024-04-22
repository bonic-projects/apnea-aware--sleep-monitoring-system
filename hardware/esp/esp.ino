#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyA7j8MMlF8Jzhf6QDROiplG29enaiEO_lc"
/* 3. Define the AIzaSyA7j8MMlF8Jzhf6QDROiplG29enaiEO_lc*/
#define DATABASE_URL "https://apneaaware-default-rtdb.firebaseio.com/"  //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device@gmail.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;

#include <Wire.h>
#include <WiFi.h>
#include "MAX30105.h"
#include "spo2_algorithm.h"
#include "heartRate.h"

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels

#define OLED_RESET     -1 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);


MAX30105 particleSensor;

#define MAX_BRIGHTNESS 255

uint32_t irBuffer[100];   //infrared LED sensor data
uint32_t redBuffer[100];  //red LED sensor data

#define REPORTING_PERIOD_MS 1000  // frequency of updates sent to blynk app in ms

// char auth[] = "";  // You should get Auth Token in the Blynk App.
// char ssid[] = "";  // Your WiFi credentials.
// char pass[] = "";

uint32_t tsLastReport = 0;  //stores the time the last update was sent to the blynk app

int32_t bufferLength;   //data length
int32_t spo2;           //SPO2 value
int8_t validSPO2;       //indicator to show if the SPO2 calculation is valid
int32_t heartRate;      //heart rate value calcualated as per Maxim's algorithm
int8_t validHeartRate;  //indicator to show if the heart rate calculation is valid

byte pulseLED = 13;  //onboard led on esp32 nodemcu
byte readLED = 12;   //Blinks with each data read

long lastBeat = 0;  //Time at which the last beat occurred

float beatsPerMinute;          //stores the BPM as per custom algorithm
int beatAvg = 0, sp02Avg = 0;  //stores the average BPM and SPO2
float ledBlinkFreq;      //stores the frequency to blink the pulseLED


#include <Adafruit_MPU6050.h>

Adafruit_MPU6050 mpu;
float accX = 0;
float accY = 0;
float accZ = 0;
float gyroX = 0;
float gyroY = 0;
float gyroZ = 0;
//INM441 pre-setup

#include <driver/i2s.h>
#include <math.h>

// Connections to INMP441 I2S microphone
#define I2S_WS 27
#define I2S_SD 33
#define I2S_SCK 32
int dB = 0;

int callibrate = 110;
// Use I2S Processor 0
#define I2S_PORT I2S_NUM_0

// Define input buffer length
#define bufferLen 64
int16_t sBuffer[bufferLen];

// Reference sensitivity in dBFS (decibels Full Scale)
float referenceSensitivity = -26.0;

void i2s_install() {
  // Set up I2S Processor configuration
  const i2s_config_t i2s_config = {
    .mode = i2s_mode_t(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = 44100,
    .bits_per_sample = i2s_bits_per_sample_t(16),
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = i2s_comm_format_t(I2S_COMM_FORMAT_STAND_I2S),
    .intr_alloc_flags = 0,
    .dma_buf_count = 8,
    .dma_buf_len = bufferLen,
    .use_apll = false
  };

  i2s_driver_install(I2S_PORT, &i2s_config, 0, NULL);
}

void i2s_setpin() {
  // Set I2S pin configuration
  const i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_SCK,
    .ws_io_num = I2S_WS,
    .data_out_num = -1,
    .data_in_num = I2S_SD
  };

  i2s_set_pin(I2S_PORT, &pin_config);
}

void setup() {
  ledcSetup(0, 0, 8);          // PWM Channel = 0, Initial PWM Frequency = 0Hz, Resolution = 8 bits
  ledcAttachPin(pulseLED, 0);  //attach pulseLED pin to PWM Channel 0
  ledcWrite(0, 255);           //set PWM Channel Duty Cycle to 255

  Serial.begin(115200);

  Serial.print("Initializing Pulse Oximeter..");
   if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;); // Don't proceed, loop forever9        //
   }
     display.display();


  // Clear the buffer
  display.clearDisplay();
  // Initialize sensor
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST))  //Use default I2C port, 400kHz speed
  {
    Serial.println(F("MAX30105 was not found. Please check wiring/power."));
    while (1)
      ;
  }


  /*The following parameters should be tuned to get the best readings for IR and RED LED. 
   *The perfect values varies depending on your power consumption required, accuracy, ambient light, sensor mounting, etc. 
   *Refer Maxim App Notes to understand how to change these values
   *I got the best readings with these values for my setup. Change after going through the app notes.
   */
  byte ledBrightness = 50;  //Options: 0=Off to 255=50mA
  byte sampleAverage = 1;   //Options: 1, 2, 4, 8, 16, 32
  byte ledMode = 2;         //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  byte sampleRate = 100;    //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  int pulseWidth = 69;      //Options: 69, 118, 215, 411
  int adcRange = 4096;      //Options: 2048, 4096, 8192, 16384
                            //MPU6050 setup

  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) delay(10);
  }
  Serial.println("MPU6050 Found!");
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);


  //INM441 setup

  // Set up I2S
  i2s_install();
  i2s_setpin();
  i2s_start(I2S_PORT);

  delay(500);

  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);  //Configure sensor with these settings
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();


  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";
}


void updateData() {
  readAcceleration();
  readDB();
  FirebaseJson json;
  json.set("beatAvg", beatAvg);
  json.set("sp02Avg", sp02Avg);
  json.set("accX",accX);
  json.set("accY",accY);
  json.set("accZ",accZ);
  json.set("gyroX",gyroX);
  json.set("gyroY",gyroY);
  json.set("gyroZ",gyroZ);
  json.set("dB",dB);
  json.set(F("ts/.sv"), F("timestamp"));
  Serial.printf("Set data with timestamp... %s\n", Firebase.setJSON(fbdo, path.c_str(), json) ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());
  Serial.println("");
}
void readAcceleration() {
  sensors_event_t accel, gyro, temp;
  mpu.getEvent(&accel, &gyro, &temp);

  accX = accel.acceleration.x;
  accY = accel.acceleration.y;
  accZ = accel.acceleration.z;
  gyroX = gyro.gyro.x;
  gyroY = gyro.gyro.y;
  gyroZ = gyro.gyro.z;
  Serial.print("Acceleration (X,Y,Z): ");
  Serial.print(accel.acceleration.x);
  Serial.print(", ");
  Serial.print(accel.acceleration.y);
  Serial.print(", ");
  Serial.print(accel.acceleration.z);
  Serial.println(" m/s^2");

  // Print gyroscope data
  Serial.print("Rotation (X,Y,Z): ");
  Serial.print(gyro.gyro.x);
  Serial.print(", ");
  Serial.print(gyro.gyro.y);
  Serial.print(", ");
  Serial.print(gyro.gyro.z);
  Serial.println(" rad/s");
}

void readDB() {
  size_t bytesIn = 0;
  esp_err_t result = i2s_read(I2S_PORT, &sBuffer, bufferLen, &bytesIn, portMAX_DELAY);

  if (result == ESP_OK) {
    // Read I2S data buffer
    int16_t samples_read = bytesIn / 2;  // Each sample is 2 bytes (16 bits)
    if (samples_read > 0) {
      float rms = 0;
      for (int16_t i = 0; i < samples_read; ++i) {
        rms += pow(sBuffer[i] / 32768.0, 2);  // Normalize and square each sample
      }
      rms = sqrt(rms / samples_read);  // Calculate RMS value

      // Calculate dB value based on RMS and reference sensitivity
      float decibelValue = 20 * log10(rms) + referenceSensitivity;
      dB = decibelValue + callibrate;
      // Print dB value to Serial
      Serial.println(dB);
    }
  }
}

  void loop() {
    bufferLength = 100;  //buffer length of 100 stores 4 seconds of samples running at 25sps

    //read the first 100 samples, and determine the signal range
    for (byte i = 0; i < bufferLength; i++) {
      while (particleSensor.available() == false)  //do we have new data?
        particleSensor.check();                    //Check the sensor for new data

      redBuffer[i] = particleSensor.getIR();
      irBuffer[i] = particleSensor.getRed();
      particleSensor.nextSample();  //We're finished with this sample so move to next sample

      Serial.print(F("red: "));
      Serial.print(redBuffer[i], DEC);
      Serial.print(F("\t ir: "));
      Serial.println(irBuffer[i], DEC);
    }

    //calculate heart rate and SpO2 after first 100 samples (first 4 seconds of samples)
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);

    //Continuously taking samples from MAX30102.  Heart rate and SpO2 are calculated every 1 second
    while (1) {
      // long irValue = particleSensor.getIR();
      // Blynk.run();
      //dumping the first 25 sets of samples in the memory and shift the last 75 sets of samples to the top
      for (byte i = 25; i < 100; i++) {
        redBuffer[i - 25] = redBuffer[i];
        irBuffer[i - 25] = irBuffer[i];
      }

      //take 25 sets of samples before calculating the heart rate.
      for (byte i = 75; i < 100; i++) {
        while (particleSensor.available() == false)  //do we have new data?
          particleSensor.check();                    //Check the sensor for new data

        digitalWrite(readLED, !digitalRead(readLED));  //Blink onboard LED with every data read

        redBuffer[i] = particleSensor.getRed();
        irBuffer[i] = particleSensor.getIR();
        particleSensor.nextSample();  //We're finished with this sample so move to next sample

        //send samples and calculation result to terminal program through UART
        //Uncomment these statements to view the raw data during calibration of sensor.
        //When uncommented, beatsPerMinute will be slightly off.
        /*Serial.print(F("red: "));
      Serial.print(redBuffer[i], DEC);
      Serial.print(F("\t ir: "));
      Serial.print(irBuffer[i], DEC);
      Serial.print(F("\t HR="));
      Serial.print(heartRate, DEC);
      Serial.print(F("\t"));
      Serial.print(beatAvg, DEC);
      
      Serial.print(F("\t HRvalid="));
      Serial.print(validHeartRate, DEC);
      
      Serial.print(F("\t SPO2="));
      Serial.print(spo2, DEC);
      
      Serial.print(F("\t SPO2Valid="));
      Serial.println(validSPO2, DEC);*/

        long irValue = irBuffer[i];

        //Calculate BPM independent of Maxim Algorithm.
        if (checkForBeat(irValue) == true) {
          //We sensed a beat!
          long delta = millis() - lastBeat;
          lastBeat = millis();

          beatsPerMinute = 60 / (delta / 1000.0);
          beatAvg = (beatAvg + beatsPerMinute) / 2;

          if (beatAvg != 0)
            ledBlinkFreq = (float)(60.0 / beatAvg);
          else
            ledBlinkFreq = 0;
          ledcWriteTone(0, ledBlinkFreq);
        }
        if (millis() - lastBeat > 10000) {
          beatsPerMinute = 0;
          beatAvg = (beatAvg + beatsPerMinute) / 2;

          if (beatAvg != 0)
            ledBlinkFreq = (float)(60.0 / beatAvg);
          else
            ledBlinkFreq = 0;
          ledcWriteTone(0, ledBlinkFreq);
        }
      }

      //After gathering 25 new samples recalculate HR and SP02
      maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);

      Serial.print(beatAvg, DEC);

      Serial.print(F("\t HRvalid="));
      Serial.print(validHeartRate, DEC);

      Serial.print(F("\t SPO2="));
      Serial.print(sp02Avg, DEC);

      Serial.print(F("\t SPO2Valid="));
      Serial.println(validSPO2, DEC);

      //Calculates average SPO2 to display smooth transitions on Blynk App
      if (validSPO2 == 1 && spo2 < 100 && spo2 > 0) {
        sp02Avg = (sp02Avg + spo2) / 2;
      } else {
        spo2 = 0;
        sp02Avg = (sp02Avg + spo2) / 2;
        ;
      }

      //Send Data to Blynk App at regular intervals
      if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
        updateData();
        tsLastReport = millis();
        printDisplay(beatAvg);
      }
    }
  }

  void printDisplay(int value){
   display.clearDisplay();

  
  display.setTextSize(1);      


  display.setTextColor(SSD1306_WHITE); // Draw white text
  display.setCursor(0, 0);     // Start at top-left corner
  display.cp437(true);         // Use full 256 char 'Code Page 437' font

  // Display "Hello, world!" with larger font size
  display.println("ApneaAware");

  // Display the heartbeat average value with larger font size
  display.print("beatAvg:");
  display.setTextSize(2);      // 2X scale

  display.println(value); // Print the heartbeat average value

  display.display();
}
