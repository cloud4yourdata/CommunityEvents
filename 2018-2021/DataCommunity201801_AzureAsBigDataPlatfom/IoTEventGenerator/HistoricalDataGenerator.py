import devices as dv
import time
import csv

devices = []
for x in range(1, 11):
    devices.append(dv.DevMeasurement(x, x*10, 20, 50))

date = "2017-10-30";
filename ="D:\\"+date+".csv";
f = open(filename,'a',newline='')
csv_file = csv.writer(f)

while True:
  for dev in devices:
       dev.read(date)
       item = dev.getJson()
       csv_file.writerow(dev.getCvs())
       print(item)
  time.sleep(5)
  f.flush()
f.close()

