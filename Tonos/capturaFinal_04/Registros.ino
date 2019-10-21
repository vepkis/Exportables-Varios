void graba(int cual_)
{
  if (gTonos_[cual_].getDisponible()) {
    gTonos_[cual_].grabaSonido();
  }
  if (gTonos_[cual_].getEsperaTermino() == false && gTonos_[cual_].getDisponible() == false)
  {
    gTonos_[cual_].tiempoDeEspera(1);
  }
}

void reproduce(int cual_)
{
  if (gTonos_[cual_].getEsperaTermino())
  {
    gTonos_[cual_].reproduceSonido();
  }
  reproduceUnaVez == true;
}


void reproduceNVeces(int cual_)
{
  if (gTonos_[cual_].getEsperaTermino())
  {
    gTonos_[cual_].reproduceSonidoNVeces(2);
  }
  reproduceUnaVez == true;
}


void reproduceTodos()
{
  if (corredor < tamMuestra)
  {
    corredor++;
  }
  else
  {
    corredor = 0;
    delay(100);
    reproduceRandom = !reproduceRandom;

  }

  //-----------------------GuardaRandom
  if (guardaRandom)
  {
    for (int i = 0; i < indexArray - 1; i++)
    {
      if (reproduceRandom == false)
      {
        gTonos_[cual].reproduceSonidoEspecial(corredor, valorPote);
        delay(1);

      }
      else {
        if (cual != i)
        {
          gTonos_[i].reproduceSonidoEspecial(corredor, random(valorPote/2, valorPote));
          delay(i);
        }
      }
    }
    //  delay(1);
  }  //-----------------------Fin
  else
  {
    gTonos_[0].reproduceSonidoEspecial(corredor, (int)random(10, 15));
    delay(1);
    gTonos_[1].reproduceSonidoEspecial(corredor, 20);
    delay(1);
    gTonos_[2].reproduceSonidoEspecial(corredor, 25);
    delay(1);
    gTonos_[3].reproduceSonidoEspecial(corredor, 10);
    delay(1);

  }
}
