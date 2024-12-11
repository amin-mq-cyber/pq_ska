#!/bin/bash
# SKA Classic: 4 parts: 4 parts in classical elliptic curve
# repeat 30 times and save data
# Script for randomness check and data collection
# Edit SKA script to output different key string file for each SKA variation, This will be the input to entropy calculator
# Check for every stages: initial public key, secrets, encrypted secrets, derived key, initial symmetric key, next symmetric key
# Call entropy measurement script on each stages
# entropy -s -f alice-sym-init.txt 
# Save data, append to csv file, add id for each iteration

initial_alice_kms_ec_out=$(./ckms ec keys create | tr -d ' ')
# get substring of the private key id and save it into variable
initial_alice_kms_ec_out_private_key_id=${initial_alice_kms_ec_out#*:}
initial_alice_kms_ec_private_key_id=${initial_alice_kms_ec_out_private_key_id:0:36}    
# For initial alice kms ec private key
printf "initial_alice_kms_ec_private_key," >> classic_entropy.csv
# export the key with metadata in ttlv format
./ckms ec keys export --key-id=$initial_alice_kms_ec_private_key_id alice-ec-private-key.txt
# filter the key byte string and save it into a file
alice_ec_private_key=$(cat alice-ec-private-key.txt)
alice_ec_private_key_byte=${alice_ec_private_key#*\"BigInteger\"\,\"value\"\:\"}
alice_ec_private_key_byte_string=${alice_ec_private_key_byte%%\"*}
# decode the key byte string to a file with hex or base 64 encoding
echo "$alice_ec_private_key_byte_string" | xxd -r -p > alice-ec-private-key-decoded.txt
printf "$(entropy -s -f alice-ec-private-key-decoded.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv

# For initial alice kms ec public key
initial_alice_kms_ec_public_key_id=${initial_alice_kms_ec_out#*:*:}
printf "initial_alice_kms_ec_public_key," >> classic_entropy.csv
./ckms ec keys export --key-id=$initial_alice_kms_ec_public_key_id alice-ec-public-key.txt
# filter the key byte string and save it into a file
alice_ec_public_key=$(cat alice-ec-public-key.txt)
alice_ec_public_key_byte=${alice_ec_public_key#*\"ByteString\"\,\"value\"\:\"}
alice_ec_public_key_byte_string=${alice_ec_public_key_byte%%\"*}
# decode the key byte string to a file with hex or base 64 encoding
echo "$alice_ec_public_key_byte_string" | xxd -r -p > alice-ec-public-key-decoded.txt
printf "$(entropy -s -f alice-ec-public-key-decoded.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv

# Alice generate several random secret wrapped in different post-quantum Kyber and or Classical variations, send it to key server
# measure entropy of the secret
openssl rand 16 > alice_secret_1.txt
printf "alice_secret_1," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_1.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv

openssl rand 16 > alice_secret_2.txt
printf "alice_secret_2," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_2.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv

openssl rand 16 > alice_secret_3.txt
printf "alice_secret_3," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_3.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv

openssl rand 16 > alice_secret_4.txt
printf "alice_secret_4," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_4.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv
# Wrapping the secret: Cosmian encrypt with cc kyber and classical elliptic curve
# encrypt the secrets with classical elliptic curve : ec encrypt options filename
# ckms ec encrypt --key-id <FILE>
./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_1.txt -o alice_secret_1.enc
printf "alice_secret_1.enc," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_1.enc)" >> classic_entropy.csv
echo >> classic_entropy.csv

./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_2.txt -o alice_secret_2.enc
printf "alice_secret_2.enc," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_2.enc)" >> classic_entropy.csv
echo >> classic_entropy.csv

./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_3.txt -o alice_secret_3.enc
printf "alice_secret_3.enc," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_3.enc)" >> classic_entropy.csv
echo >> classic_entropy.csv

./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_4.txt -o alice_secret_4.enc
printf "alice_secret_4.enc," >> classic_entropy.csv
printf "$(entropy -s -f alice_secret_4.enc)" >> classic_entropy.csv
echo >> classic_entropy.csv

# The key agreement server decrypt and concatenate the secrets and derive key from the concatenated secrets
# elliptic curve decrypt
./ckms ec decrypt alice_secret_1.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_1.txt
./ckms ec decrypt alice_secret_2.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_2.txt
./ckms ec decrypt alice_secret_3.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_3.txt
./ckms ec decrypt alice_secret_4.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_4.txt

# Alice and KMS derive key from the concatenated secrets
# concatenate decrypted secrets
# cat decrypted_alice_secret_1.txt decrypted_alice_secret_2.txt decrypted_alice_secret_3.txt decrypted_alice_secret_4.txt > all_secrets.txt
decrypted_alice_secret_1=$(cat decrypted_alice_secret_1.txt)
decrypted_alice_secret_2=$(cat decrypted_alice_secret_2.txt)
decrypted_alice_secret_3=$(cat decrypted_alice_secret_3.txt)
decrypted_alice_secret_4=$(cat decrypted_alice_secret_4.txt)
echo $decrypted_alice_secret_1$decrypted_alice_secret_2$decrypted_alice_secret_3$decrypted_alice_secret_4 > all_secrets.txt
# measure entropy of the concatenated secrets
printf "all_secrets," >> classic_entropy.csv
printf "$(entropy -s -f all_secrets.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv
# derive key from the concatenated secrets
cat all_secrets.txt | argon2 "spigenbuburaspal" -id -t 3 -m 16 -p 4 -l 16 -r > derived_key.bin
derived_aes_key=$(cat derived_key.bin | tr -d ' ')
echo -n "$derived_aes_key" > derived_aes_key.txt
# measure entropy of the derived key
printf "derived_aes_key," >> classic_entropy.csv
printf "$(entropy -s -f derived_aes_key.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv
# import the derived key raw bytes to key server as aes key
alice_derived_aes_out=$(./ckms sym keys import derived_aes_key.txt -f aes)
alice_derived_aes_key_id=${alice_derived_aes_out#*:}

# The key agreement server create symmetric key and encrypt it with derived key
initial_alice_sym_out=$(./ckms sym keys create | tr -d ' ')
initial_alice_sym_out_key_id=${initial_alice_sym_out#*:}
initial_alice_sym_key_id=${initial_alice_sym_out_key_id:0:36}

# Export the symmetric key 
# Encrypt the symmetric key and wrap it with imported derived key
./ckms sym keys export --key-id=$initial_alice_sym_key_id alice-sym-init.txt -w $alice_derived_aes_key_id
# filter the key byte string and save it into a file
alice_sym_key=$(cat alice-sym-init.txt)
alice_sym_key_byte=${alice_sym_key#*\"ByteString\"\,\"value\"\:\"}
alice_sym_key_byte_string=${alice_sym_key_byte%%\"*}
# decode the key byte string to a file with hex or base 64 encoding
echo "$alice_sym_key_byte_string" | xxd -r -p > alice-sym-init-decoded.txt
# measure entropy of the symmetric key
printf "alice-sym-init-decoded.txt," >> classic_entropy.csv
printf "$(entropy -s -f alice-sym-init-decoded.txt)" >> classic_entropy.csv
echo >> classic_entropy.csv
# run authentication and cascading session key generation later on
# derive further symmetric key from previous key
# with rotate or re-key function of the key server or some other method with argon or scrypt