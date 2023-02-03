import datetime
import random
import json
import time

class DevMeasurement:
    def __init__(self, devId, initLevelValue, initTempValue, initHumidityValue):
        self.devId = devId
        self.levelValue = initLevelValue
        self.tempValue = initTempValue
        self.humidityValue = initHumidityValue
        self.timestamp = datetime.datetime.utcnow()

    def computeTemp(self):
        tmpTemp = int(0.2 * self.tempValue)
        delta = random.randint(-tmpTemp , tmpTemp)
        self.tempValue = self.tempValue + delta
        if self.tempValue > 35:
            self.tempValue = 35
        if self.tempValue < -30:
            self.tempValue = -30

    def computeHumidity(self):
        tmpHumidity = int(0.2 * self.humidityValue)
        delta = random.randint(-tmpHumidity, tmpHumidity)
        self.humidityValue = self.tempValue + delta
        if self.tempValue > 95:
            self.tempValue = 95
        if self.tempValue < 10:
            self.tempValue = 10

    def computeLevel(self):
        tmplevelValue = int(0.2 * self.levelValue)
        delta = random.randint(-tmplevelValue, tmplevelValue)
        self.levelValue = self.levelValue + delta
        if self.levelValue < 0:
            self.levelValue = 0

    def setTimestamp(self):
           self.timestamp = datetime.datetime.utcnow()

    def read(self, date = ""):
        self.computeTemp()
        self.computeHumidity()
        self.computeLevel()
        if(date == ""):
            self.setTimestamp()
        else:
             now = datetime.datetime.utcnow();
             newDate = datetime.datetime.strptime(date,'%Y-%m-%d')
             self.timestamp = datetime.datetime.combine(newDate.date(),now.time())
        return

    
    def getJson(self):
         reading = {'id': self.devId, 'timestamp': str(self.timestamp), 'waterLevel': self.levelValue,
                   'temperature': self.tempValue, 'humidity': self.humidityValue}
         return json.dumps(reading)

    def getCvs(self):
        return [self.devId,self.timestamp,self.levelValue,self.tempValue,self.humidityValue]