
int tamMuestra = 20;// define el tamaño de la muestra <-------

const int indexArray = 4; // numero máximo de Salidas de audio

//  GrabadorDeTonos(int microfonoPIN_, int parlante_, int ledRegistro_,int tiempoRegistro_, int sonidoMinUmbral_);
GrabadorDeTonos gTonos_[indexArray] = {
  GrabadorDeTonos(A2, 4, 9, 20, 50),
  GrabadorDeTonos(A2, 5, 10, 20, 50),
  GrabadorDeTonos(A2, 6, 11, 20, 50),
  GrabadorDeTonos(A2, 7, 12, 20, 60),

};



//------------------------Ultrasonico
const int ultraEnvia = 2;//------------Trigger
const int ultraRecibe = 3;//-----------Echo


int ultraUmbral = 40; //en centimetros Distancia de Activación del mic

//------------------------


//------------------------Potenciometro
const int pote = A7;

int valorPote;
//------------------------

int cual = 0, cualAnterior = 99;


boolean triggPresencia, triggAnterior;
bool disparaContador = false;
int cronoss = 0;
bool alarma = false;



int corredor;

boolean guardaRandom;

boolean grabando;
boolean reproduceUnaVez = false;

boolean cualSiguiente = false;
boolean primeraVez = true;
boolean delayUltimo = false;
boolean reproduceRandom = false;
