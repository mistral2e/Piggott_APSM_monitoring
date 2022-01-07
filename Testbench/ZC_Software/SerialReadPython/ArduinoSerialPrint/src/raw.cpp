#include <Arduino.h>



void setup() {
  //Serial.begin(115200);
  Serial.begin(460800);

}

unsigned long millis1=0;
int counter=0;
void loop() {
millis1=millis()+millis1;
Serial.print(millis1);
Serial.print(";");
counter++;
Serial.print(counter);
Serial.print(";");
Serial.println();
delay(3);
}
