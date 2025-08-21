#include <ArduinoBLE.h>
#include <HX711_ADC.h>
#include <EEPROM.h>

// TODO:
// 1. Add a function that decreases the motor speed slowly to 30%, when 80% of the target weight is reached.
// 2. Add calibration process to the code.

// HX711 (scale) related
const int HX711_dout = A4; // mcu > HX711 dout pin
const int HX711_sck = A5;  // mcu > HX711 sck pin
HX711_ADC LoadCell(HX711_dout, HX711_sck);
float CURRENT_WEIGHT = 0.0;
float calibrationValue = 0.0;

// FrontEnd Related:
float TARGET_WEIGHT = -10.0;
int TARGET_MOTOR_SPEED = 255; // currently hard coded to max speed
bool flavorly_is_running = false;

// MOTOR related:
const int motor1_IN1 = 10; //motorID = 1
const int motor1_IN2 = 12; //motorID = 1
const int motor2_IN3 = 11; //motorID = 2
const int motor2_IN4 = 13; //motorID = 2

const int motor3_IN1 = 9; // ...
const int motor3_IN2 = 8; // ...
const int motor4_IN3 = 6;
const int motor4_IN4 = 7;

const int motor5_IN1 = 3;
const int motor5_IN2 = 2;
const int motor6_IN3 = 5;
const int motor6_IN4 = 4;

int CURRENT_MOTOR_SPEED = 0;


int PROGRAM = 0;
// program 0 = stop motor
// program 1 = start motor
// program 2 = tare scale (takes 2-3 seconds)
// program 3 = calibrate scale

int TARGET_MOTOR_ID = 0;
int currentMotorPin1 = 0;
int currentMotorPin2 = 0;

// --- Define BLE Service and Characteristics ---
// Use the same UUIDs as in your Flutter app  (Nordic UART Service - NUS)
BLEService uartService("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");

// Create TX Characteristic (Transmit from Flutter app to Arduino)
BLECharacteristic txCharacteristic("6E400002-B5A3-F393-E0A9-E50E24DCCA9E",
                                   BLEWriteWithoutResponse | BLEWrite, // Allow write properties
                                   20);                                // Maximum data length (adjust if needed)

// Create RX Characteristic (Flutter app receives data from Arduino)
BLECharacteristic rxCharacteristic("6E400003-B5A3-F393-E0A9-E50E24DCCA9E",
                                   BLERead | BLENotify, // Allow read and notify properties
                                   20);                 // Maximum data length (adjust if needed)

const int calVal_eepromAddress = 0; // EEPROM address for calibration value

void setup()
{
  // Initialize Serial communication for debugging messages
  Serial.begin(9600);
  delay(100);

  setupScale();
  setupBluetooth();

  // SETUP MOTOR PINS:
  pinMode(motor1_IN1, OUTPUT);
  pinMode(motor1_IN2, OUTPUT);
  pinMode(motor2_IN3, OUTPUT);
  pinMode(motor2_IN4, OUTPUT);
  
  pinMode(motor3_IN1, OUTPUT);
  pinMode(motor3_IN2, OUTPUT);
  pinMode(motor4_IN3, OUTPUT);
  pinMode(motor4_IN4, OUTPUT);

  pinMode(motor5_IN1, OUTPUT);
  pinMode(motor5_IN2, OUTPUT);
  pinMode(motor6_IN3, OUTPUT);
  pinMode(motor6_IN4, OUTPUT);

  // Load calibration value from EEPROM
  EEPROM.get(calVal_eepromAddress, calibrationValue);
  Serial.print("Loaded calibration value: ");
  Serial.println(calibrationValue);

  // Check if EEPROM is empty (NaN value) and set default value
  if (isnan(calibrationValue)) {
    calibrationValue = 16000.0;
    Serial.println("EEPROM was empty (NaN), using default calibration value: 16000");
  }

  // Apply the calibration value
  LoadCell.setCalFactor(calibrationValue);

  // Start the LoadCell
  LoadCell.start(2000, true);
  if (LoadCell.getTareTimeoutFlag() || LoadCell.getSignalTimeoutFlag()) {
    Serial.println("Timeout, check wiring.");
    while (1);
  }
  Serial.println("Setup complete.");
}

// --- Loop Function ---
void loop()
{
  delay(50); // optional?

  // Continuously poll for BLE events (connections, disconnections, data)
  // This is CRUCIAL for the BLE stack to function.
  BLE.poll();

  // ################################ MOTOR RELATED START
  // If the current weight is above 0.4*TARGET_WEIGHT, slow down the motor to 70% of TARGET_MOTOR_SPEED
  if (CURRENT_WEIGHT >= 0.8 * TARGET_WEIGHT && CURRENT_WEIGHT < 0.8 * TARGET_WEIGHT && flavorly_is_running == true)
  {
    int newSpeed = TARGET_MOTOR_SPEED * 0.7;
    startMotor(newSpeed);
  }


  // If the current weight is above 0.9*TARGET_WEIGHT, stop the motor
  if (CURRENT_WEIGHT >= 0.95 * TARGET_WEIGHT)
  {
    stopMotor();
  }
  if (CURRENT_WEIGHT < TARGET_WEIGHT && CURRENT_MOTOR_SPEED == 0 && flavorly_is_running == true)
  {
    startMotor(TARGET_MOTOR_SPEED);
  
  }
  // ################################ MOTOR RELATED END

  // ################################ Scale Related START
  static boolean scaleDataReady = false;
  if (LoadCell.update())
    scaleDataReady = true;
  // get smoothed value from the dataset:
  if (scaleDataReady)
  {
    CURRENT_WEIGHT = LoadCell.getData();
    scaleDataReady = false;

    // Send CURRENT_WEIGHT, which is already a String, to the RX characteristic
    String weightString = String(CURRENT_WEIGHT);
    rxCharacteristic.writeValue(weightString.c_str(), weightString.length());

    // Print the weight to Serial Monitor for debugging
    Serial.print("Weight: ");
    Serial.print(CURRENT_WEIGHT);
    Serial.println(" g");
  }
  // ################################ Scale Related END
}

// --- Callback Function ---
// This function is called when the flutter app sends data over Bluetooth
void onFrontEndSentData(BLEDevice central, BLECharacteristic characteristic)
{
  Serial.println("Data...");
  // Get the data from flutter app via Bluetooth
  int len = characteristic.valueLength();       // Get the length of the data received
  const uint8_t *data = characteristic.value(); // Get a pointer to the data buffer

  // The incoming data is a String in the format "<program;motorID;targetWeight>" including the <> brackets
  String incomingData = "";
  for (int i = 0; i < len; i++)
  {
    incomingData += (char)data[i]; // Convert the data to a String
  }
  Serial.print("Received data: ");
  Serial.println(incomingData);
  // Parse the incoming data
  // Format: <program;motorID;targetWeight>
  int firstSep = incomingData.indexOf(';');
  int secondSep = incomingData.indexOf(';', firstSep + 1);
  float recievedWeightParameter = 0.0; // Initialize the received weight parameter
  int recievedMotorID = 0;
  if (firstSep != -1 && secondSep != -1)
  {
    String programString = incomingData.substring(1, firstSep); // Extract the program
    String motorIDString = incomingData.substring(firstSep + 1, secondSep); // Extract the motorID
    String targetWeightString = incomingData.substring(secondSep + 1, incomingData.length() - 1); // Extract the target weight

    // Convert the strings to integers/floats
    PROGRAM = programString.toInt();
    TARGET_MOTOR_ID = motorIDString.toInt();
    TARGET_WEIGHT = targetWeightString.toFloat();
    Serial.print("Recieved program: ");
    Serial.println(PROGRAM);
    Serial.print("Recieved motorID: ");
    Serial.println(TARGET_MOTOR_ID);
    Serial.print("Recieved Target Weight: ");
    Serial.println(TARGET_WEIGHT);

  }
  else
  {
    Serial.println("Invalid data format received");
  }
  // Handle the program
  switch (PROGRAM)
  {
  case 0: // Stop motor
    stopMotor();
    break;
  case 1: // Normal operation
    flavorly_is_running = true;
    break;
  case 2: // Tare scale
    Serial.println("Taring scale...");
    LoadCell.tare(); // Tare the scale
    Serial.println("Tare complete");
    break;
  case 3: // Calibrate scale
    calibrateScale(TARGET_WEIGHT);
    break;
  }
}

void setCurrentMotorPins()
{

    switch (TARGET_MOTOR_ID) {
      case 1:
        currentMotorPin1 = motor1_IN1;
        currentMotorPin2 = motor1_IN2;
        break;
      case 2:
        currentMotorPin1 = motor2_IN3;
        currentMotorPin2 = motor2_IN4;
        break;
      case 3:
        currentMotorPin1 = motor3_IN1;
        currentMotorPin2 = motor3_IN2;
        break;
      case 4:
        currentMotorPin1 = motor4_IN3;
        currentMotorPin2 = motor4_IN4;
        break;
      case 5:
        currentMotorPin1 = motor5_IN1;
        currentMotorPin2 = motor5_IN2;
        break;
      case 6:
        currentMotorPin1 = motor6_IN3;
        currentMotorPin2 = motor6_IN4;
        break;
      default:
        currentMotorPin1 = 0;
        currentMotorPin2 = 0;
        break; 
    }
}

void startMotor(int speed)
{ 
  Serial.print("Setting Pins for Motor ");
  Serial.println(TARGET_MOTOR_ID);
  setCurrentMotorPins();

  Serial.print("Starting Motor ...");
  analogWrite(currentMotorPin1, speed);
  digitalWrite(currentMotorPin2, LOW);

  CURRENT_MOTOR_SPEED = speed;
}

void stopMotor()
{
  setCurrentMotorPins();
  // set work duty for the motor to 0 (off)
  analogWrite(currentMotorPin1, LOW);
  digitalWrite(currentMotorPin2, LOW);
  CURRENT_MOTOR_SPEED = 0;
  flavorly_is_running = false; // Reset the flag to prevent immediate restart
}

void setupScale()
{
  LoadCell.begin();

  unsigned long stabilizingtime = 2000; // precision right after power-up can be improved by adding a few seconds of stabilizing time
  boolean _tare = true;                 // set this to false if you don't want tare to be performed in the next step
  LoadCell.start(stabilizingtime, _tare);
  if (LoadCell.getTareTimeoutFlag())
  {
    Serial.println("Timeout, check MCU>HX711 wiring and pin designations");
    while (1)
      ;
  }
  else
  {
    Serial.println("Scale Startup complete");
  }
}

void calibrateScale(float known_mass)
{
  Serial.println("Starting calibration...");
  LoadCell.refreshDataSet();
  float newCalibrationValue = LoadCell.getNewCalibration(known_mass);

  // Save the calibration value to EEPROM
  EEPROM.put(calVal_eepromAddress, newCalibrationValue);
  Serial.print("Calibration complete. New value: ");
  Serial.println(newCalibrationValue);
}

void setupBluetooth()
{
  // Initialize the BLE library
  if (!BLE.begin())
  {
    Serial.println("Starting BLE failed!");
    // Don't continue execution if BLE initialization fails
    while (1)
      ;
  }

  Serial.println("BLE Initialized");

  // Set the advertised local name and service UUID
  BLE.setLocalName("flavorly"); // Name that appears during scanning
  BLE.setAdvertisedService(uartService);

  // Add the characteristics to the service
  uartService.addCharacteristic(txCharacteristic);
  uartService.addCharacteristic(rxCharacteristic);

  // Add the service to the BLE stack
  BLE.addService(uartService);

  // Assign a callback function when data is written to the TX characteristic
  txCharacteristic.setEventHandler(BLEWritten, onFrontEndSentData);

  // Start advertising
  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");
}
