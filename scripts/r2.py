import os
from multiprocessing.pool import ThreadPool

def run_script(ip, username, password):
    os.system(f'sshpass -p {password} scp -o StrictHostKeyChecking=no requirements.txt {username}@{ip}:~/')
    os.system(f'sshpass -p {password} scp -o StrictHostKeyChecking=no temp5.txt {username}@{ip}:~/')
    os.system(f'sshpass -p {password} scp -o StrictHostKeyChecking=no nfs.sh {username}@{ip}:~/')
    os.system(f'sshpass -p {password} scp -o StrictHostKeyChecking=no script.sh {username}@{ip}:~/')
    os.system(f'sshpass -p {password} ssh -o StrictHostKeyChecking=no {username}@{ip} "chmod +x ~/script.sh && ~/script.sh"')
    os.system(f'sshpass -p {password} ssh -o StrictHostKeyChecking=no {username}@{ip} "chmod +x ~/nfs.sh && ~/nfs.sh"')

if __name__ == '__main__':
    # List of IP addresses to run the script on
    ips = ['172.16.96.33',
			'172.16.96.34',
			'172.16.96.35',
			'172.16.96.36',
			'172.16.96.37',
			'172.16.96.38',
			'172.16.96.39',
			'172.16.96.40',
			'172.16.96.41',
			'172.16.96.42',
			'172.16.96.43',
			'172.16.96.44',
			'172.16.96.45',
			'172.16.96.46',
			'172.16.96.47',
			'172.16.96.48',
			'172.16.96.49',
			'172.16.96.53',
			'172.16.96.54',
			'172.16.96.55',
			'172.16.96.56',
			'172.16.96.57',
			'172.16.96.58'
		]

    # Username and password for SSH authentication
    username = 'windows'
    password = 'win@123'

    # Run the script on all remote servers in parallel
    with ThreadPool(processes=len(ips)) as pool:
        pool.starmap(run_script, [(ip, username, password) for ip in ips])

    print("Script executed on all IP addresses.")

