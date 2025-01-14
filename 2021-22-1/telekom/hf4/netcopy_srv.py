from socket import socket, AF_INET, SOCK_STREAM, SOCK_DGRAM
from hashlib import md5
import sys

server_addr = (sys.argv[1], int(sys.argv[2]))
check_adr = (sys.argv[3], int(sys.argv[4]))
file = (sys.argv[5], sys.argv[6])
pck_size = 16

hash = md5()
with socket(AF_INET, SOCK_STREAM) as server:
	server.bind(server_addr)
	server.listen(1)

	client, client_addr = server.accept()

	end = False
	with open(file[1], "wb") as f:
		while not end:
			data = client.recv(pck_size)
			if data:
				hash.update(data)
				f.write(data)
			else:
				client.close()
				end = True

data = hash.hexdigest()
print(f'RECIVED | {data}')

with socket(AF_INET, SOCK_STREAM) as client:
    client.connect(check_adr)
    client.sendall(f'KI|{file[0]}'.encode())
    res = client.recv(256).decode().split('|')
    if int(res[0]) > 0 and res[1] == data:
        print(f'CSUM OK')
    else:
        print('CSUM CORRUPTED')