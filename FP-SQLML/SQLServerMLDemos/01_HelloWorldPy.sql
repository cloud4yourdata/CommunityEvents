USE SQLML;
execute sp_execute_external_script 
@language = N'Python',
@script = N'
import sys
print("*************************")
print(sys.path)
print(sys.version)
print("Hello World")
print("*************************")'

------------------------------
execute sp_execute_external_script 
@language = N'Python',
@script = N'
import os
import sys
import time
print("-------------------------")
print(os.getcwd())
sys.stdout.flush()
time.sleep(100)
print("-------------------------")'
--4D027D0C-95B0-4652-A139-6E5D387B59A4
---------------------------------------
