USE RevoScaleDb;
EXECUTE sp_execute_external_script 
@language = N'Python',
@script = N'
import sys
print("*************************")
print(sys.path)
print(sys.version)
print("Hello World")
print("*************************")'