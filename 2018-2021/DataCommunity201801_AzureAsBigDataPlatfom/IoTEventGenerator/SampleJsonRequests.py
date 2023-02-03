import devices as dv
import time
import csv

devices = []
for x in range(1, 11):
    devices.append(dv.DevMeasurement(x, x*10, 20, 50))

date = "2017-10-31";
filename ="D:\\"+date+".json";
f = open(filename,'a',newline='')


while True:
  for dev in devices:
       dev.read(date)
       item = dev.getJson()
       f.write(item)
       print(item)
  time.sleep(5)
  f.flush()
f.close()


