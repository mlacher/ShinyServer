
int dt = 10; // used for delay duration
byte rval = 0x00; // used for value sent to potentiometer
byte HB = 0x10;
byte x[2]={0};
byte y[2]={0};

int b = 0;
float fStdLiter;

#include "Wire.h"
#define sen_add 0x40 // each I2C object has a unique bus address, the MCP4018 is 0x2F or 0101111 in binary

float Calc_VLiter(float fTemp){
  float result;
  float stdPressure = 1.01325; //bar
  float Pressure = 0.94; //bar
  float stdTemp = 273.15; //Kelvin
  float stdflow;
  Wire.requestFrom(sen_add, 2, false);
      for (int i = 0; i < 2; i++)
  {
    x[i] = Wire.read();
  }  
  stdflow=  ((x[0]*256+x[1])-32000)/140; 
  result = stdflow*((stdTemp+fTemp)/(stdTemp+21.11))*((stdPressure/Pressure));
  return result;
}
 
void Init_i2c()
{
 Wire.begin();
 Wire.beginTransmission(sen_add); 
    Wire.write(0x0000 >> 8); // 
    Wire.write(0x0000 & 0xFF); // 
    Wire.endTransmission();   
} 

float flow_i2c()
{    
    Wire.beginTransmission(sen_add); 
    Wire.write(0x1000 >> 8); // get Flow
    Wire.write(0x1000 & 0xFF); // get Flow
    Wire.endTransmission(); 
    delay(50);
 }

 float temp_i2c()
{
   float fTemp;
    Wire.beginTransmission(sen_add); 
    Wire.write(0x1001 >> 8); // get Temp
    Wire.write(0x1001 & 0xFF); // get Temp
    Wire.endTransmission();
    delay(50);
    Wire.requestFrom(sen_add, 2, false);
      for (int i = 0; i < 2; i++)
  {
    y[i] = Wire.read();
  }
    fTemp = ((y[0]*256+y[1])-20000)/100;
    return  fTemp;
}
