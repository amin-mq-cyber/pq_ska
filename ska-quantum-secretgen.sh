# Alice generate several random secret wrapped in different post-quantum Kyber and or Classical variations, send it to key server
# Secret key generator:  https://www.tecmint.com/generate-pre-shared-key-in-linux/ 
openssl rand -base64 16 > alice_secret_1.txt
openssl rand -base64 16 > alice_secret_2.txt
openssl rand -base64 16 > alice_secret_3.txt
openssl rand -base64 16 > alice_secret_4.txt
