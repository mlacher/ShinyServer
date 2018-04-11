
float FctPressure (float offset)
{
 float sensorValue = 0;
 float fPressureVal = 0;
 float voltage;
 float pre_conv = -68.95; //PSI in mbar
 sensorValue=        analogRead(A3);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
 voltage = (sensorValue * (5.0 / 1023.0));
 fPressureVal   = (voltage-2.5)/2.25;
//converte to mbar
fPressureVal = fPressureVal*pre_conv;

 //PressureVal = (int)((PressureVal-0.1*5*(10000-60))/(0.8*5)+60);
    
return (fPressureVal);//    // read the input pin;
}
