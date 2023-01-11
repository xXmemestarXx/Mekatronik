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
int tare = 0;
int kaliV = 50;

//screens
boolean src1 = true;
boolean src2 = false;

// Setup køres engang på start af app
void setup() {
  orientation(PORTRAIT);
  background(0);
  stroke(255);
  textSize(25);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  bt.getPairedDeviceNames();
  bt.connectToDeviceByName("HC-05");
  bt.start();
}

// Draw looper konstant hoved del for kode

void draw() {

  if (src1) screen1();
  if (src2) screen2();
}

// ved click på skærmen
void touchEnded() {
  if (src1) {
    if (mouseY > (height/20*18-height/8/2) && mouseY < (height/20*18+height/8/2)) {
      if (mouseX > (width/5-width/4/2) && mouseX < (width/5+width/4/2)) {
        tare = int(toPrint);
      }
      if (mouseX > (width/5*4-width/4/2) && mouseX < (width/5*4+width/4/2)) {
        src1 = false;
        src2 = true;
      }
    }
  }
  if (src2) {
    //luk knap
    if (mouseY > (width/12-width/12/2) && mouseY < (width/12+width/12/2)) {
      if (mouseX > (width/12-width/12/2) && mouseX < (width/12+width/12/2)) {
        src2 = false;
        src1 = true;
      }
    }
    // set kali knapper
    if (mouseX > (width/2-200) && mouseX < (width/2+200)) {
      if (mouseY > (525+200) && mouseY < (675+200)) {
        kaliV++;
      }
      if (mouseY > (1325+200) && mouseY < (1475+200)) {
        kaliV--;
      }
    }
    //weight knap
    if (mouseY > (height/8*7-height/8*7/2) && mouseY < (height/8*7+height/8*7/2)) {
      if (mouseX > (width/2-width/2/2) && mouseX < (width/2+width/2/2)) {
        // funjtion til 0
      }
    }
    //zero knap
    if (mouseY > (height/8-height/8/2) && mouseY < (height/8+height/8/2)) {
      if (mouseX > (width/2-width/2/2) && mouseX < (width/2+width/2/2)) {
        sendData(200);
      }
    }
  }
}

void screen1() {
  fill(255);
  textSize(80);
  background(50);
  text("SUPER COOL BT SCALE", width/2, height/10);
  textSize(200);
  text(int(toPrint)-tare, width/2, height/2);

  rect(width/5, height/20*18, width/4, height/8, 90);
  rect(width/5*4, height/20*18, width/4, height/8, 90);  

  fill(0);
  textSize(60);
  text("TARE", width/5, height/20*18);
  text("CALI", width/5*4, height/20*18);
}

void screen2() {
  rectMode(CENTER);
  background(50);
  textSize(60);

  fill(255);
  rect(width/2, height/8, width/2, height/8, 90);

  rect(width/2, height/8*7, width/2, height/8, 90);

  triangle(width/2-200, 675+200, width/2, 525+200, width/2+200, 675+200);
  triangle(width/2-200, 1325+200, width/2, 1475+200, width/2+200, 1325+200);
  text("Calibration weight (g)", width/2, height/2-50);
  textSize(100);
  text(kaliV, width/2, height/2+100);

  rect(width/12, width/12, width/12, width/12, 30);

  fill(0);
  textSize(80);
  text("Set Zero", width/2, height/8);
  text("Set Weight", width/2, height/8*7);
  textSize(60);
  text("X", width/12, width/12);
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
