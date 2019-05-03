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
 */

import SimpleOpenNI.*; 
SimpleOpenNI kinect;
//Esto se usara para asignarle un color a cada usuario que reconozca
color[]       userFarbe = new color[] { 
  color(255, 0, 0), 
  color(0, 255, 0), 
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
  pushMatrix();

  kinect.update();
  image(kinect.depthImage(), 0, 0);
  //image(kinect.userImage(), 0, 0);
  popMatrix();


  int [] userList = kinect.getUsers();

  for (int i=0; i<userList.length; i++)
  {
    if (kinect.isTrackingSkeleton(userList[i]))
    {
      println("oh yes!!- Skeleton Ready");

      updateVectores(1);
      //Anuncia presencia solo sí se reconoce esqueleto
      presencia=1;

      enviaValores();

      stroke(userFarbe[userList[i]-1 % userFarbe.length]);
      drawSkeleton(1);
    } else {
      println("AwWww - Skeleton Away");
      //si no hay esqueleto, envia un cero
      presencia=0;
      enviaOSC("/kinect/presencia", presencia);
    }
  }

  println(kinect.getUsers());
  println("______------________"+presencia);
}

//---------------------------------------------- fin de Draw


void drawSkeleton(int userID)
{
  pushStyle();
  stroke(255, 0, 0);
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

public void onNewUser(SimpleOpenNI curKinect, int userID)
{
  println("Damn!, Hay alguien - ID Asignada:"+userID);
  if (kinect.isTrackingSkeleton(1)) return;
  println("Detectando pose");
  kinect.startTrackingSkeleton(userID);
}

public void lostUser(SimpleOpenNI curKinect, int userID)
{
  println  ("Se fue!! - su ID:"+userID);
}

void onVisibleUser(SimpleOpenNI curKkinect, int userID)
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

  //PVector parteCuerpoMapeada= new PVector(mappyX, mappyY, mappyZ);
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


void enviaOSC(String direccion, int valor)
{

  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(direccion);
  myMessage.add(valor); /* add an int to the osc message */
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation_1);
}

void enviaArrayOSC(String direccion, PVector vector_)
{
  float [] valor={vector_.x, vector_.y, vector_.z};

  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage(direccion);
  myMessage.add(valor); /* add an int to the osc message */
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation_1);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

//el mousePressed lo usamos a modo de testeo

void mousePressed()
{

  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/1");

  myMessage.add(100); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation_1);
}
