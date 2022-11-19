import subprocess
for i in range(255):
    command=['ping', '-n', '1','-w','100', '192.168.1.'+str(i)]
    subprocess.call(command)

arpa = subprocess.check_output(("arp", "-a")).decode("ascii")
n_devices=len([x for x in arpa.split('\n') if '192.168.1.' in x and  
    all(y not in x for y in ['192.168.1.1 ','192.168.1.255']) ])