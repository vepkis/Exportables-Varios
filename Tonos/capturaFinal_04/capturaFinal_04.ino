/*
   Firmware realizado por
   Krista Yorbyck - materiAcromatica
   Octubre 2019
   https://github.com/vepkis
*/


#include <GrabadorDeTonos.h>
#include "variables.h"

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  //--------Ultrasonico
  pinMode(ultraEnvia, OUTPUT);
  pinMode(ultraRecibe, INPUT);
  //---------


  digitalWrite(ultraEnvia, LOW);
  delay(1000);
  triggPresencia = 0;

}

void loop() {

  lecturaPote();
   flujo();//pestaña Again
  delay(100);
}
