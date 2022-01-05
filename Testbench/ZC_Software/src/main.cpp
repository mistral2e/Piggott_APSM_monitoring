#include <Arduino.h>
// #include <HardwareSerial.h>

#define V1 D3
#define V2 D4
#define V3 D5

#define LD1 D6
#define LD2 D7

#define SP D8

String SerialHeader="machine_time;input;time;count;delta_t;ESP_CC;delta_cc;cc_overflow_count;time_print[all_mikrosec]";

// ISR 1-3
volatile byte SignalPin =0;
volatile byte interruptCounter = 0;  // unsigned long 4byte
volatile unsigned long interruptTime =0;
volatile bool interrupt_happend = false;
volatile unsigned long interrupt_ESP_cycle = 0;
unsigned long delta_t=1000000;
int numberOfInterrupts = 0;
unsigned long last_interrupt = 0;
unsigned long debounce_time = 4*1000; //usek
unsigned long last_interrupt_ESP_cycle=0;
//unsigned long last_interrupts[5]={debounce_time,debounce_time,debounce_time,debounce_time,debounce_time};
// ISR B
//volatile byte SignalPin =0;
volatile byte interruptCounter_B = 0;  // unsigned long 4byte
volatile unsigned long interruptTime_B =0;
volatile bool interrupt_happend_B = false;
volatile unsigned long interrupt_ESP_cycle_B = 0;
unsigned long delta_t_B=1000000;
int numberOfInterrupts_B = 0;
unsigned long last_interrupt_B = 0;
unsigned long debounce_time_B = 0*1000; //usek
unsigned long last_interrupt_ESP_cycle_B=0;
// ISR C
//volatile byte SignalPin =0;
volatile byte interruptCounter_C = 0;  // unsigned long 4byte
volatile unsigned long interruptTime_C =0;
volatile bool interrupt_happend_C = false;
volatile unsigned long interrupt_ESP_cycle_C = 0;
unsigned long delta_t_C=1000000;
int numberOfInterrupts_C = 0;
unsigned long last_interrupt_C = 0;
unsigned long debounce_time_C = 1*1000; //usek
unsigned long last_interrupt_ESP_cycle_C=0;

// ISR scope
bool scope_triggered = false ;
// nano sek reading
unsigned long Two32=(4294967296-1);  //Overflow
unsigned long cycle_overflow_count=0;
unsigned long cycle_count_last=0;


int quick_pow10(int n)
{
    static int pow10[10] = {
        1, 10, 100, 1000, 10000, 
        100000, 1000000, 10000000, 100000000, 1000000000
    };

    return pow10[n]; 
}

void detachISR();

void handleInterrupt1() {
  if(interrupt_happend == false){
  interrupt_happend = true;
  interrupt_ESP_cycle=ESP.getCycleCount();
  interruptTime=micros(); // 70 Minuten Overflow
  interruptCounter++;  
  SignalPin=1;
  //detachISR();
  }}
void handleInterrupt2() {
  if(interrupt_happend == false){
  interrupt_happend = true;
  interrupt_ESP_cycle=ESP.getCycleCount();
  interruptTime=micros(); // 70 Minuten Overflow
  interruptCounter++;  
  SignalPin=2;
  //detachISR();
  }}
void handleInterrupt3() {
  if(interrupt_happend == false){
  interrupt_happend = true;
  interrupt_ESP_cycle=ESP.getCycleCount();
  interruptTime=micros(); // 70 Minuten Overflow
  interruptCounter++;  
  SignalPin=3;
  //detachISR();
  }}
void handleInterrupt_B() {
  if(interrupt_happend_B == false){
  interrupt_happend_B = true;
  interrupt_ESP_cycle_B=ESP.getCycleCount();
  interruptTime_B=micros(); // 70 Minuten Overflow
  interruptCounter_B++;  
  //SignalPin=3;
  //detachISR();
  }}
void handleInterrupt_C() {
  if(interrupt_happend_C == false){
  interrupt_happend_C = true;
  interrupt_ESP_cycle_C=ESP.getCycleCount();
  interruptTime_C=micros(); // 70 Minuten Overflow
  interruptCounter_C++;  
  //SignalPin=3;
  //detachISR();
  }}


void ICACHE_RAM_ATTR handleInterrupt1();
void ICACHE_RAM_ATTR handleInterrupt2();
void ICACHE_RAM_ATTR handleInterrupt3();
void ICACHE_RAM_ATTR handleInterrupt_B();
void ICACHE_RAM_ATTR handleInterrupt_C();

void attachISR(){
  attachInterrupt(digitalPinToInterrupt(V1), handleInterrupt1, FALLING);
  attachInterrupt(digitalPinToInterrupt(V2), handleInterrupt2, FALLING);
  attachInterrupt(digitalPinToInterrupt(V3), handleInterrupt3, FALLING);
  attachInterrupt(digitalPinToInterrupt(LD1), handleInterrupt_B, RISING);
  attachInterrupt(digitalPinToInterrupt(LD2), handleInterrupt_C, RISING);
}  

void detachISR(){
  detachInterrupt(digitalPinToInterrupt(V1));
  detachInterrupt(digitalPinToInterrupt(V2));
  detachInterrupt(digitalPinToInterrupt(V3));
  detachInterrupt(digitalPinToInterrupt(LD1));
  detachInterrupt(digitalPinToInterrupt(LD2));
}


void LEDtoggle(){
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
}

void SerialReader(){
  if (Serial.available() > 0){
    interrupt_happend = true;  
  long x=Serial.parseInt();
  if(x>0){
  //Serial.println(x);
  Serial.println(SerialHeader);
  scope_triggered= false;
  last_interrupt= 0;    //start serial print after second interrupt
  }
  }
}

void ScopeTrigger(){
  if(scope_triggered == false) {
    if(millis()>2000){
    unsigned long delta_t_ms=delta_t/quick_pow10(6);
    unsigned long trigger_start=micros();
    //if (delta_t_ms > 20) {
        digitalWrite(SP,HIGH);
        Serial.print(";ScopeTrigger;");
	Serial.print(trigger_start);  //Zeitangabe genauer machen!
	Serial.println(";1;0;0;0;0");
	scope_triggered= true;
	digitalWrite(SP,LOW);
	//}
    }}
}

unsigned long delta_ESPcount(unsigned long cc_last,unsigned long cc_current){
  unsigned long delta=0;
  if(cc_current<cc_last){
    delta = Two32-cc_last+cc_current;}
  else { delta= cc_current-cc_last;}
  return delta;
}
  
void setup(){
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  pinMode(SP, OUTPUT);
  digitalWrite(SP, LOW);
  Serial.begin(460800);
  Serial.println("Restart");
  Serial.println(SerialHeader);
  pinMode(V1, INPUT);
  pinMode(V2, INPUT);
  pinMode(V3, INPUT);
  pinMode(LD1, INPUT);
  pinMode(LD2, INPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  attachISR();
}



void loop() {
  SerialReader();
  unsigned long cc=ESP.getCycleCount();
  if(cycle_count_last>cc){
    cycle_overflow_count++;
    //Serial.println("Overlfow");
  }
  cycle_count_last=cc;
  
  if(interruptCounter>0){
    unsigned long Time_print_start =micros();
    if(interruptCounter == 1){
      delta_t = interruptTime-last_interrupt;
      if(last_interrupt > 0){
      Serial.print(";");
      Serial.print(SignalPin);Serial.print(";");
      SignalPin=0;
      //Serial.print(interruptTime);
      Serial.print(";");
      Serial.print(numberOfInterrupts);Serial.print(";");
      //Serial.print(delta_t);
      Serial.print(";");
      Serial.print(interrupt_ESP_cycle);Serial.print(";");
      //Serial.print(delta_ESPcount(last_interrupt_ESP_cycle,interrupt_ESP_cycle));
      Serial.print(";");
      Serial.print( cycle_overflow_count );Serial.print(";");
      LEDtoggle();
      Serial.println(micros()-Time_print_start);
      }
      last_interrupt=interruptTime;
      last_interrupt_ESP_cycle = interrupt_ESP_cycle;
      numberOfInterrupts++;
    }
    else {
      Serial.print(";ErrorTooMany");
      Serial.print(SignalPin); Serial.print(";");
      Serial.print(interruptTime); Serial.print(";;;");
      Serial.print(interruptCounter);  // !Anzahl ISRs seit letztem print
      Serial.print(";0;");
      Serial.println(micros()-Time_print_start);
    }
    //attachISR();
    interruptCounter=0;
    interruptTime =0;
  }
  if(interrupt_happend == true){
    if((last_interrupt+debounce_time)<micros()){
      interrupt_happend=false;
    }
  }
   if(interruptCounter_B>0){
    unsigned long Time_print_start =micros();
    if(interruptCounter_B == 1){
      delta_t_B = interruptTime_B-last_interrupt_B;
      if(last_interrupt_B > 0){
      Serial.print(";");
      Serial.print("8");Serial.print(";");
      //SignalPin=0;
      //Serial.print(interruptTime_B);
      Serial.print(";");
      Serial.print(numberOfInterrupts_B);Serial.print(";");
      //Serial.print(delta_t_B);
      Serial.print(";");
      Serial.print(interrupt_ESP_cycle_B);Serial.print(";");
      //Serial.print(delta_ESPcount(last_interrupt_ESP_cycle_B,interrupt_ESP_cycle_B));
      Serial.print(";");
      Serial.print( cycle_overflow_count );Serial.print(";");
      LEDtoggle();
      Serial.println(micros()-Time_print_start);
      }
      last_interrupt_B=interruptTime_B;
      last_interrupt_ESP_cycle_B = interrupt_ESP_cycle_B;
      numberOfInterrupts_B++;
    }
    else {
      Serial.print(";ErrorTooMany");
      Serial.print("B"); Serial.print(";");
      Serial.print(interruptTime_B); Serial.print(";;;");
      Serial.print(interruptCounter_B);  // !Anzahl ISRs seit letztem print
      Serial.print(";0;");
      Serial.println(micros()-Time_print_start);
    }
    //attachISR();
    interruptCounter_B=0;
    interruptTime_B =0;
  }
  if(interrupt_happend_B == true){
    if((last_interrupt_B+debounce_time_B)<micros()){
      interrupt_happend_B=false;
    }
  }
   if(interruptCounter_C>0){
    unsigned long Time_print_start =micros();
    if(interruptCounter_C == 1){
      delta_t_C = interruptTime_C-last_interrupt_C;
      if(last_interrupt_C > 0){
      Serial.print(";");
      Serial.print("9");Serial.print(";");
      //SignalPin=0;
      Serial.print(interruptTime_C);Serial.print(";");
      Serial.print(numberOfInterrupts_C);Serial.print(";");
      Serial.print(delta_t_C);Serial.print(";");
      Serial.print(interrupt_ESP_cycle_C);Serial.print(";");
      Serial.print(delta_ESPcount(last_interrupt_ESP_cycle_C,interrupt_ESP_cycle_C));Serial.print(";");
      Serial.print( cycle_overflow_count );Serial.print(";");
      LEDtoggle();
      Serial.println(micros()-Time_print_start);
      }
      last_interrupt_C=interruptTime_C;
      last_interrupt_ESP_cycle_C = interrupt_ESP_cycle_C;
      numberOfInterrupts_C++;
    }
    else {
      Serial.print(";ErrorTooMany");
      Serial.print("B"); Serial.print(";");
      Serial.print(interruptTime_C); Serial.print(";;;");
      Serial.print(interruptCounter_C);  // !Anzahl ISRs seit letztem print
      Serial.print(";0;");
      Serial.println(micros()-Time_print_start);
    }
    //attachISR();
    interruptCounter_C=0;
    interruptTime_C =0;
  }
  if(interrupt_happend_C == true){
    if((last_interrupt_C+debounce_time_C)<micros()){
      interrupt_happend_C=false;
    }
  }
  
  //ScopeTrigger();
}
