
//------------------------------------- ULTRASONIDO

int lecturaUltra(int ultraEnvia_, int ultraRecibe_) {
  long duration, distanceCm;

  digitalWrite(ultraEnvia_, LOW);  //para generar un pulso limpio ponemos a LOW 4us
  delayMicroseconds(2);
  digitalWrite(ultraEnvia_, HIGH);  //generamos Trigger (disparo) de 10us
  delayMicroseconds(10);
  digitalWrite(ultraEnvia_, LOW);

  duration = pulseIn(ultraRecibe_, HIGH);  //medimos el tiempo entre pulsos, en microsegundos

 distanceCm = (duration/2) / 29.2;  //convertimos a distancia, en cm
 return distanceCm;
}


//-----------------------------------Potenciometro


void lecturaPote()

{

  valorPote= map(analogRead(pote),0,1023, 20,100);
//Serial.println(valorPote);
}
