#include "HX711.h"

const int LOADCELL_DOUT_PIN = 13;  // dt pin
const int LOADCELL_SCK_PIN = 12;   // sck pin

HX711 scale;  // som scale

//delay
int _delay = 500;  // delay mellem hver måling
unsigned long time = 0;

// bt
#include <SoftwareSerial.h>

SoftwareSerial bt(2, 3);  // RX, TX
int lastIn = 0;

//
float kaliV = 50;
float setZero = -208900;
float kali_first = 31104.00;
bool setZeroPressed = false;
bool setW_pressed = false;

void setup() {
  bt.begin(9600);
  Serial.begin(9600);
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

  time = millis();  //start time
}

void loop() {
  if (millis() - time > _delay) {  // tager en måling hvert _delay ms
    float reading = 0;
    if (scale.is_ready()) {  // tjekker om HX711 er slået til

      reading = scale.read();                                   // læser vægten
      reading = (reading + abs(setZero)) / kali_first * kaliV;  // omregner til gram
      //Serial.print("HX711 reading: ");
      //Serial.println(reading);

    } else {
      Serial.println("HX711 not found.");
    }

    time = millis();

    sendData(reading);  //sender data
  }

  if (setZeroPressed) {
    setZero = scale.read_average(30);
    setZeroPressed = false;
    Serial.println("Set Zero Pressed: " + setZero);
  }
  if (setW_pressed) {
    int temp = scale.read_average(30);
    kali_first = (temp + abs(setZero));
    setW_pressed = false;

    Serial.println("Set weight Pressed: " + kali_first)
  }

  readData();
}

void sendData(float data) {
  String dataOut = String(data);
  dataOut += "!";
  // Serial.print("To send: ");
  // Serial.println(dataOut);
  bt.println(dataOut);
}

//modtag data
void readData() {
  int input = 0;             // Definere en input
  while (bt.available()) {   // Hvis der er data vi kan læse
    input = (int)bt.read();  // Læser det data der er
  }
  // Tjeker om det er nyt data, så vi ikke duplikere noget
  if (input != lastIn) {
    dataHandler(input);  // Sender den nye data til dataHandler();
    lastIn = input;      // Sætter det nye input til at være det sidst medtagede
  }
}  // End readData

void dataHandler(int data) {
  if (data > 200){
    setZeroPressed = true;
    break
  }
  if (data > 0 && data <= 200){
    setW_pressed = true;
    break
  }
  Serial.println("not valid number")
}