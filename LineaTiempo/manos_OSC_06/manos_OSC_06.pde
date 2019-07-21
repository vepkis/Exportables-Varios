/*
este sketch está hecho para reconocer 1 persona,
 si se quieren agregar para más hay que modificarlo
 
 = Krista Y:._2017
 _______
 
 
 Psdt: Persiste el error de multiples usuarios, no ha sido arreglado aún. 
 = Krista Y:. (02/09/2017)
 ______
 
 Se envian 4 paquetes de datos en bruto (RAW)
 - uno entero de presencia
 - un arreglo manoIzq [3] flotante
 - un arreglo manoDer [3] flotante
 - un flotante para torso
 
 próximamente:
 - detectar cuando User sale de escena
 - darle vuelta a la kinect (rotate-translate)
 - Mirror en relación a lo anterior
 
 = Krista Y:. (14/04/2019)
 
 ______
 
- Para capturar usuaries se usa ahora IntVector, una clase de SimpleOpenNi
creada exclusivamente para esto.
- La kinect al darla vuelta, no lee correctamente el esqueleto. Así que optamos por dejarla
en la posici´ón convencional.
- Se lee solo los valores dele primer usuarie.
- Se cambiaron el nombre de algunas variables y se agregaron,modificaron y eliminaron algunos comentarios.


-Aún no se puede crear un ejecutable funcional para mac,
se puede para windows unicamente, pero crackeando la versión de simpleOpenNi

No deberían existir mayores problemas ahora.

 = Krista Y:. (08/05/2019)
 */

import SimpleOpenNI.*; 
SimpleOpenNI kinect;
//Esto se usara para asignarle un color a cada usuarie que reconozca
color[]       userFarbe = new color[] { 
  color(0, 255, 0), 
  color(255, 0, 0), 
  color(0, 0, 255), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(0, 255, 255)
};
/*Vamos a crear una serie de vectores para guardar las coordenadas
 de las articulaciones que forma el esqueleto en SimpleOpenNI
 */

PVector vectHEAD= new PVector();
PVector vectNECK= new PVector();
PVector vectLSHOULDER= new PVector();
PVector vectLELBOW= new PVector();
PVector vectLHAND= new PVector();
PVector vectRSHOULDER= new PVector();
PVector vectRELBOW= new PVector();
PVector vectRHAND= new PVector();
PVector vectTORSO= new PVector();

int presencia=0;

//osc Varius

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation_1;
//------------------------------------------ S E T U P <
void setup()
{
  //size (kinect.depthWidth(), kinect.depthHeight());
  size (640, 480);

  kinect= new SimpleOpenNI(this);

  if (kinect.isInit() == false)
  {
    println("Ooops_ SimpleOpenNI no inicia. Revisá que este conectada la Camarita ;)"); 
    exit();
    return;
  }
  kinect.setMirror(true);//toca ponerlo antes de habilitar al usuario.


  kinect.enableDepth();
  kinect.enableUser();


  oscP5 = new OscP5(this, 6161);
  myRemoteLocation_1 = new NetAddress("127.0.0.1", 6969);
}

//---------------------------------------------- fin de Setup
//------------------------------------------ D R A W <
void draw ()
{

  kinect.update();
  image(kinect.depthImage(), 0, 0);
  image(kinect.userImage(), 0, 0);

  // guarda las posciones de usuaries
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    //----Aquí capturo solo los dele primer usuarie userList.get(0);
    int userId = userList.get(0);
    //---Trackea userId que tiene el valor de 0, es decir dele primere usuarie
    if (kinect.isTrackingSkeleton(userId))
    {
      println("oh yes!!- Skeleton Ready");

      updateVectores(userId);
      //Anuncia presencia solo sí se reconoce esqueleto
      presencia=1;

      enviaValores();

      stroke(userFarbe[userId]);
      drawSkeleton(userId);
    } else {
      println("AwWww - Skeleton Away");
      //si no hay esqueleto, envia un cero
      presencia=0;
      enviaOSC("/kinect/presencia", presencia);
    }
    //  println(kinect.getUsers(userList)+"-___ trackeando"+kinect.isTrackingSkeleton(userId));
    println(userList.get(0)+"-___ trackeando___"+kinect.isTrackingSkeleton(userId));
  }

  println("______------________"+presencia);
}

//---------------------------------------------- fin de Draw


void drawSkeleton(int userID)
{
  pushStyle();
  strokeWeight(5);

  kinect.drawLimb(userID, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  kinect.drawLimb(userID, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  kinect.drawLimb(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  popStyle();
}

public void onNewUser(SimpleOpenNI kinect, int userID)
{
  println("Damn!, Hay alguien - ID Asignada:"+userID);
  if (kinect.isTrackingSkeleton(userID)) return;
  println("Detectando pose");
  kinect.startTrackingSkeleton(userID);
}

public void lostUser(SimpleOpenNI kinect, int userID)
{
  println  ("Se fue!! - su ID:"+userID);
}

void onVisibleUser(SimpleOpenNI kinect, int userID)
{

  rect(width/2, height/2, 100, 100);
  println("VISIBLEEEEEEEEEE");

  //println("onVisibleUser - userID: " + userID);
}
//____________________________________________________

void updateVectores(int userID)
{
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_HEAD, vectHEAD);
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_NECK, vectNECK);
  //brazo izquierdo
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER, vectLSHOULDER);  
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_ELBOW, vectLELBOW);  
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND, vectLHAND);  
  //brazo derecho
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER, vectRSHOULDER);  
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW, vectRELBOW);  
  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_HAND, vectRHAND);

  kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_TORSO, vectTORSO);
}

//mapea Valores y regresa un vector2D
PVector posicionVectorial2D(PVector parteCuerpo )
{
  float mappyX = map(parteCuerpo.x, -500, 500, 0, 100);
  float mappyY = map(parteCuerpo.y, -600, 600, 0, 100);

  PVector parteCuerpoMapeada= new PVector(mappyX, mappyY);
  return parteCuerpoMapeada;
}

//mapea Valores y regresa un vector3D
PVector posicionVectorial3D(PVector parteCuerpo, boolean convertir )
{
  PVector parteCuerpoMapeada= new PVector();
  if (convertir)
  { 
    parteCuerpoMapeada.x = map(parteCuerpo.x, -500, 500, 0, 100);
    parteCuerpoMapeada.y = map(parteCuerpo.y, -600, 600, 0, 100);
    parteCuerpoMapeada.z = map(parteCuerpo.z, 200, 4200, 0, 100);
  } else
  {
    parteCuerpoMapeada=parteCuerpo;
  }

  return parteCuerpoMapeada;
}

//--------------+++-- +_Inicio EventosOSC_+ --+++-------------------//
void enviaValores()
{
  enviaOSC("/kinect/presencia", presencia);
  enviaArrayOSC("/kinect/torso", posicionVectorial3D(vectTORSO, false));
  enviaArrayOSC("/kinect/manoDerecha", posicionVectorial3D(vectRHAND, false));
  enviaArrayOSC("/kinect/manoIzquierda", posicionVectorial3D(vectLHAND, false));


  //--- A modo de Test ___ Borrar luego
  textSize(40);
  fill(20, 250, 200);
  text(vectLHAND.x, 100, 70);
  text(vectRHAND.x, width/2+100, 70);

  text(presencia, width/2-100, width/2);
}


void enviaOSC(String direccion_, int valor_)
{

  OscMessage mensaje = new OscMessage(direccion_);
  mensaje.add(valor_); 
  oscP5.send(mensaje, myRemoteLocation_1);
}

void enviaArrayOSC(String direccion_, PVector vector_)
{
  float [] valor={vector_.x, vector_.y, vector_.z};

  OscMessage mensaje = new OscMessage(direccion_);
  mensaje.add(valor);
  oscP5.send(mensaje, myRemoteLocation_1);
}

//--Esto es solo para los eventos entrantes si es que los hay
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

//el mousePressed lo usamos a modo de testeo

void mousePressed()
{

  OscMessage mensajePing = new OscMessage("/1");
  mensajePing.add(100);
  oscP5.send(mensajePing, myRemoteLocation_1);
}
