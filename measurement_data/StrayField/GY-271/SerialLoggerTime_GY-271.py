# getestet funktioniert aus 3ms genau...
import serial
import time
import os
import datetime
datum=datetime.datetime.today().strftime('%Y%m%d_%H%M%S')
filename='Hall_'+datum+".csv"

ser = serial.Serial('/dev/ttyUSB0',115200,timeout=5)
ser.flushInput()
t1=time.time()

res="unixtime;Bx;By;Bz"
with open(filename,"a") as f:
  f.write(res+os.linesep)


while True:
    try:
        counter=0
        ser_bytes = ser.readline()
        t1_alt=t1
        t1=time.time()
        #print(t1-t1_alt)
        decoded_bytes =(ser_bytes[0:len(ser_bytes)-2].decode("utf-8"))
        res= str(t1)+''+decoded_bytes
        print(res)
        with open(filename,"a") as f:
            f.write(res+os.linesep)
        if(counter<20): f.close()
    except:
        f.close()
        print("saved file,Keyboard Interrupt")
        break
