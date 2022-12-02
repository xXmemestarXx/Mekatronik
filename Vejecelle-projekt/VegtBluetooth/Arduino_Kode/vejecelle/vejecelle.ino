#include "HX711.h" 

const int LOADCELL_DOUT_PIN = 13; // dt pin 
const int LOADCELL_SCK_PIN = 12; // sck pin

HX711 scale; // som scale

//delay
int _delay = 500; // delay mellem hver måling
unsigned long time = 0;

// bt
#include <SoftwareSerial.h>

SoftwareSerial bt(2, 3); // RX, TX

//bool til start måling
bool start = true;

void setup() {
  bt.begin(9600);
  Serial.begin(9600);
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

  time = millis(); //start time

}

void loop() {
  

  if (millis()- time > _delay){ // tager en måling hvert _delay ms
    
    float reading = 0;
    float avg;
    if (scale.is_ready()) { // tjekker om HX711 er slået til

      if (start){ // tager 20 målinger til at starte med ingen vægt på
        avg = scale.read_average(20);
        start = false;
      } 

      reading = scale.read_average(20); // læser vægten
      reading = (reading+ abs(avg)) / 30751.00 * 50; //
      Serial.print("HX711 reading: ");
      Serial.println(reading);
      
    } else {
      Serial.println("HX711 not found.");
    }

    time = millis();

    sendData(reading); //sender data
  }
  
  
}

void sendData(float data) {
  String dataOut = String(data);
  dataOut += "!";
 // Serial.print("To send: ");
 // Serial.println(dataOut);
  bt.println(dataOut);
}
