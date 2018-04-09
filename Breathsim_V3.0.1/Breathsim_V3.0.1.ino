#include <DualVNH5019MotorShield.h>
#include "DualVNH5019MotorShield.h"


//test 276 ->517



DualVNH5019MotorShield md;
//code is ABCDEF
//A: Cycles;B: Time; C:Flow; D:Pressure; E: Rotspeed; F:Error
//Error:
//  3(8)  /    2(4)   /    1(2)   / 0(1)  /
//Flow/Pressure/Rotspeed/Pump/


//#define FlowSen
#define Motor
//#define PressureSen

//pump
float             Kp=1.8;  //1.2
float             Ki=0.29;
float             Ta=0.02;
float             Target_Flow=16;
int esum=0;
int e=0;
unsigned int   dRotSpeed=0;
unsigned int   RotSpeed=10;

//flow
float fFlow;
float temp;
float fFlow1;

//pressure
float fPressure;
long SUMPressure;
float offsetP;

//therapy
int cError = 0;
unsigned int lCycles = 0;
unsigned long sentTime  = 0;
unsigned long currTime = 0;
unsigned long InhTime = 1000;
unsigned int readNumber;
byte bytes[2];
int Flow_Array[100];//to be defined
int Pres_Array[100];
int Time_Array[100];
int Rot_Array[100];
int ArraySize;
int i=0;

int stopIfFault()
{
  if (md.getM1Fault())
  {
    return  bitSet(cError,0);
  }
  if (md.getM2Fault())
  { 
    while(1);
  }
}

void SAVE (int Time,int Flow,int Pressure, int rotspeed, int Array_count){
  Time_Array[Array_count] = Time;
  Flow_Array[Array_count] = Flow;
  Pres_Array[Array_count] = Pressure;
  Rot_Array[Array_count] = rotspeed;
  ArraySize = Array_count;
}

void setup() {
  Serial.begin(9600);
#ifdef FlowSen
Init_i2c();
temp = temp_i2c();
  flow_i2c();
//Serial.println(temp);
#endif

#ifdef Motor
md.init();
md.setM1Speed(0);
cError = stopIfFault();
#endif
currTime = 0; 
}

void loop() {
 if ( Serial.available() ){
 // cast the string read in an integer 
 readNumber = Serial.parseInt();
 bytes[0] = (readNumber & 0xFF00) >> 8; //HIGH Byte
 bytes[1] = (readNumber & 0x00FF); //LOW Byte
 }
 
// This is the normal mode
 switch(bytes[0]){
  case 0:
  break;
  
  case 1: //init
  InhTime = bytes[1]*100;
 
  Serial.println(bytes[1]);
  bytes[0] =0x00;
  break;
  
  case 2: //start
  currTime = 0;
  lCycles = 0;
  e = 0;
  esum = 0;
  Serial.println(bytes[1]);
  sentTime  = millis();
  i =0;
  RotSpeed=10;
  fFlow1 =1;
  while(millis()-sentTime < InhTime){
    #ifdef FlowSen
    fFlow = Calc_VLiter(temp);
    
    if (fFlow < (-60)){
      cError = bitSet(cError,3);
    }
    #endif
    #ifdef PressureSen
    fPressure = FctPressure(offsetP);
    if (fPressure > (30)){    // stop if pressure above 30mbar
    cError = bitSet(cError,2);
    }
    #endif
    currTime = millis()-sentTime;  
    SAVE(currTime,(int)(fFlow*10),(int)(fPressure*10),RotSpeed, lCycles);
    lCycles++;
    e = (int)(Target_Flow - fFlow);
    esum = esum + e; 
    dRotSpeed = Kp * e + Ki * Ta * esum;
    RotSpeed += dRotSpeed;
    if (RotSpeed >= 190 ){
    RotSpeed = 190; 
    }  
    if (RotSpeed < 0 ){
      cError = bitSet(cError,1);
    }
    if (bitRead(cError,2)){ 
    RotSpeed = 0;  
    }
    md.setM1Speed(RotSpeed);
    //stopIfFault();

    delay(50);
    }

  md.setM1Speed(0);   
  while (i < lCycles){
  Serial.print(lCycles);
  Serial.print(";");
  Serial.print(Time_Array[i]);
  Serial.print(";");
  Serial.print(Flow_Array[i]);
  Serial.print(";");
  Serial.print(Pres_Array[i]);
  Serial.print(";");
  Serial.print(Rot_Array[i]);
  Serial.print(";");
  Serial.print(cError);
  Serial.println(";");
  i++;
  }
  cError = 0;
  bytes[0] =0x00;
  break;
  
  default:
  break;

}

delay(50);

}
