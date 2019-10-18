/*
 * Firmware realizado por 
 * Krista Yorbyck - materiAcromatica
 * Octubre 2019
 * https://github.com/vepkis
 */


//RST           D9
//SDA(SS)      D10
//MOSI         D11
//MISO         D12
//SCK          D13

#include <SPI.h>
#include <MFRC522.h>

const int RST_PIN = 9;            // Pin 9 para el reset del RC522
const int SS_PIN = 10;            // Pin 10 para el SS (SDA) del RC522
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Crear instancia del MFRC522

const int cantLlaves = 4;
const int longitudClave = 4;


//----- Llaves conocidas

const byte llaves[cantLlaves][longitudClave] =  {
  {0x36, 0x62, 0x24, 0xD9},
  {0x76, 0x28, 0x1A, 0xF8},
  {0xFE, 0x6B, 0xCE, 0x73},
  {0x3B, 0x23, 0x9D, 0x0B}

};

//-----

void setup()
{
  Serial.begin(57600);      //Inicializa la velocidad de Serial
  SPI.begin();         //Función que inicializa SPI
  mfrc522.PCD_Init();     //Función  que inicializa RFID
  Serial.flush();
  Serial.println("______ Iniciando______");

}

void loop()
{
  // Detectar tarjeta
  if (mfrc522.PICC_IsNewCardPresent())
  {
    if (mfrc522.PICC_ReadCardSerial())
    {

      for (int i = 0; i < 4; i++)
      {
        //compara los arreglos de llaves (keys)
        if (comparaArray(mfrc522.uid.uidByte, llaves[i]))
        {
          imprimeConsola(1 + i);
        }

        // Finalizar lectura actual
        mfrc522.PICC_HaltA();
      }
    }
  }


  delay(100);
}



void printArray(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}


boolean comparaArray(byte array1[], byte array2[])
{
  if (array1[0] != array2[0])return (false);
  if (array1[1] != array2[1])return (false);
  if (array1[2] != array2[2])return (false);
  if (array1[3] != array2[3])return (false);
  return (true);
}


void imprimeConsola(int cual_)
{
  Serial.print(cual_, DEC);
  Serial.print(",");
  Serial.println("");
  delay(100);
}
