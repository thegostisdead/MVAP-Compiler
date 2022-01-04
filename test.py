import os
from subprocess import Popen, getstatusoutput, PIPE


files = os.listdir('./tests-code')

for checkfile in files : 
    command = "grun calculette 'calcul' -gui < tests-code/"  + checkfile
    result = subprocess.run(command , shell=True, stdout=subprocess.PIPE)

    if "line" in result : 
        print(f"[error] in file {result}" )
    else : 
        print(f"File {result} ok ." )



out = subprocess.run(["grun calculette 'calcul' -gui < tests-code/if1.code"],shell=True)