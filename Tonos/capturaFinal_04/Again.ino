void flujo()
{
  if (evaPresencia())
  {
    triggPresencia = true;

  }

  if (triggPresencia)
  {

    if (rutina1()  && cualSiguiente == true)
    {

      updateUser();
    }
  }
  else
  {
    rutina2();
  }

/*
  Serial.print("hay Alguien_________-");
  Serial.println(evaPresencia());
  Serial.print("cualSiguiente============ . ");
  Serial.println(cualSiguiente);
  Serial.print("cual____________>>>> ");
  Serial.println(cual);
  Serial.print("cualAnterior___________> ");
  Serial.println(cualAnterior);
*/
  /*
    Serial.println("");
    Serial.println("---------------------------");
    Serial.print("triggPresencia >>> ");
    Serial.println(triggPresencia);
    Serial.print("triggAnterior > ");
    Serial.println(triggAnterior);
    Serial.println("");
  */
}




bool rutina1()
{
  /*

    GRABA
    REPRODUCE
  */
  graba(cual);
  if (cualAnterior != cual) {
    reproduce(cual);

  }
  if (gTonos_[cual].getEsperaTermino() == true)
  {
    triggAnterior = triggPresencia;
    triggPresencia = false;

    if (primeraVez)
    {
      cualAnterior = cual;
      primeraVez = false;
    }
    cualAnterior = cual;

  }
  return triggAnterior;
}

void rutina2()
{

  /*
    Sí es menor al umbral del ultrasonido
    REPRODUCETODOS
  */
  if (guardaRandom && delayUltimo)
  {
    delay(1000);
    delayUltimo = false;
  }
  if (gTonos_[cual].getDisponible() == false)
  {
    cualSiguiente = true;
  }
  reproduceTodos();

}

bool evaPresencia()
{
  /*
    Sí es menor al umbral del ultrasonido
    retorna si/no
  */


  return  (lecturaUltra(ultraEnvia, ultraRecibe) < ultraUmbral) ? true : false;

}



void updateUser()
{
  /*
    Sí hay nuevo User
    if CUAL
    retorna un entero
  */
  cualAnterior = cual;
  if (gTonos_[indexArray - 1].getDisponible() == false && guardaRandom == false)
  {
    guardaRandom = true;
    delayUltimo = true;
  }
  if (guardaRandom && cualSiguiente)
  {
    //   Serial.println ("URRAAAA!!!!!!!!!!!!!!!!!!!!!!!");
    cual = (int)random(sizeof(gTonos_) / sizeof(gTonos_[0]));
    gTonos_[cual].updateGrabacion();
    cualSiguiente = false;
    cualAnterior = 99;
  }
  else {

    if (cual < sizeof(gTonos_) / sizeof(gTonos_[0]) - 1)
    {
      cual++;
    }
    else
    {
      cual = 0;
    }

    cualSiguiente = false;
    triggAnterior = triggPresencia;
  }
}
