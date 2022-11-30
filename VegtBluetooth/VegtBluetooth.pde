
// Importere librarys
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

// Definere bluetooth til variable bt
KetaiBluetooth bt;

// Diverse globale variabler
String data_in = "";
String toPrint = "gg";

// Setup køres engang på start af app
void setup() {
  orientation(PORTRAIT);
  background(0);
  stroke(255);
  textSize(25);
  textAlign(CENTER);
  bt.getPairedDeviceNames();
  bt.connectToDeviceByName("HC-05");
  bt.start();
}

// Draw looper konstant hoved del for kode

void draw() {
  text(toPrint, width/2, height/2);
  
}

// ved click på skærmen
void touchEnded() {
  
  
}

// Hvis der bliver sendt data fra arduino til tlf klades denne funktion, som behandler input data'en.
void onBluetoothDataEvent(String who, byte[] data) {
  for (int i = 0; i < data.length; i++) {
    char in = char(data[i]);
    if ((in > 47 && in < 58) || in == 46) data_in += in;
    if (in == '!') dataHandler();
  }
}

void dataHandler() {
  toPrint = data_in;
  data_in = "";
}

// Hvis der skal sendes data fra tlf til arduino kaldes denne funktion
void sendData(int send) {
  byte[] toSend = new byte[1];
  toSend[0] = (byte)send;
  bt.broadcast(toSend);
  println("Data out: " + send);
}

// Er nødtvendigt for at kunne starte bluetooth adapter i tlf
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}
