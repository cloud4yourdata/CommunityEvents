import devices as dv
import time
import os
from azure.servicebus import ServiceBusService

def cls():
    os.system('cls' if os.name=='nt' else 'clear')

serviceNamespace  = "bdpmydevlabs"
sharedAccessKeyName = "RootManageSharedAccessKey"
sharedAccessKeyValue = "t1oWq1KYT8eQJoSkqVQaPFBsdgtlTK7MtfU+A/FLSYk="
eventHubName = "mydemodevices"
devices = []
for x in range(1, 11):
    devices.append(dv.DevMeasurement(x, x*10, 20, 50))

sbs = ServiceBusService(service_namespace=serviceNamespace,
                       shared_access_key_name=sharedAccessKeyName,
                       shared_access_key_value=sharedAccessKeyValue)
while True:
  for dev in devices:
       dev.read()
       eventData = dev.getJson()
       r = sbs.send_event(eventHubName, eventData)
       print(eventData)
       
  time.sleep(2)
  cls()
