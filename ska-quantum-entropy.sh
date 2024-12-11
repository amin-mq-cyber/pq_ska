#!/bin/bash
# SKA Quantum: 4 parts: 4 parts wrapped in kyber
# repeat 30 times and save data
# Script for randomness check and data collection
# Edit SKA script to output different key string file for each SKA variation, This will be the input to entropy calculator
# Check for every stages: initial public key, secrets, encrypted secrets, derived key, initial symmetric key, next symmetric key
# Call entropy measurement script on each stages
# entropy -s -f alice-sym-init.txt 
# Save data, append to csv file, add id for each iteration

# create kyber cc master key and policy
initial_alice_kms_cc_master_out=$(./ckms cc keys create-master-key-pair -s policy_spec.json | tr -d ' ')
# get substring of the master private key id and save it into variable
initial_alice_kms_cc_master_out_private_key_id=${initial_alice_kms_cc_master_out#*:}
initial_alice_kms_cc_master_private_key_id=${initial_alice_kms_cc_master_out_private_key_id:0:36}    
# export alice initial cc master private key then measure entropy and save entropy value
printf "initial_alice_kms_cc_master_private_key," >> quantum_entropy.csv
./ckms cc keys export --key-id=$initial_alice_kms_cc_master_private_key_id alice-cc-master-private-key.txt
# filter the key byte string and save it into a file
alice_cc_master_private_key=$(cat alice-cc-master-private-key.txt)
alice_cc_master_private_key_byte=${alice_cc_master_private_key#*\"ByteString\"\,\"value\"\:\"}
alice_cc_master_private_key_byte_string=${alice_cc_master_private_key_byte%%\"*}
# decode the key byte string to a file with hex or base 64 encoding
echo "$alice_cc_master_private_key_byte_string" | xxd -r -p > alice-cc-master-private-key-decoded.txt
printf "$(entropy -s -f alice-cc-master-private-key-decoded.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv

# get substring of the public key id and save it into variable
initial_alice_kms_cc_master_public_key_id=${initial_alice_kms_cc_master_out#*:*:}
# export alice initial cc master public key then measure entropy and save entropy value
printf "initial_alice_kms_cc_master_public_key," >> quantum_entropy.csv
./ckms cc keys export --key-id=$initial_alice_kms_cc_master_public_key_id alice-cc-master-public-key.txt
# filter the key byte string and save it into a file
alice_cc_master_public_key=$(cat alice-cc-master-public-key.txt)
alice_cc_master_public_key_byte=${alice_cc_master_public_key#*\"ByteString\"\,\"value\"\:\"}
alice_cc_master_public_key_byte_string=${alice_cc_master_public_key_byte%%\"*}
# decode the key byte string to a file with hex or base 64 encoding
echo "$alice_cc_master_public_key_byte_string" | xxd -r -p > alice-cc-master-public-key-decoded.txt
printf "$(entropy -s -f alice-cc-master-public-key-decoded.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv
# create cc user key for alice
# cc master public key can be used to encrypt
# master secret key is used to generate user decryption keys
# use user key to decrypt
./ckms cc keys create-user-key $initial_alice_kms_cc_master_private_key_id "Security::Confidential && Branch::Sydney"
# get user key id
initial_alice_kms_cc_user_key_out=$(./ckms cc keys create-user-key $initial_alice_kms_cc_master_private_key_id "Security::Confidential && Branch::Sydney" | tr -d ' ')
initial_alice_kms_cc_user_key_id=${initial_alice_kms_cc_user_key_out#*:}
# export alice initial cc user key then measure entropy and save entropy value
printf "initial_alice_kms_cc_user_key," >> quantum_entropy.csv
./ckms cc keys export --key-id=$initial_alice_kms_cc_user_key_id alice-cc-user-key.txt
# filter the key byte string and save it into a file
alice_cc_user_key=$(cat alice-cc-user-key.txt)
alice_cc_user_key_byte=${alice_cc_user_key#*\"ByteString\"\,\"value\"\:\"}
alice_cc_user_key_byte_string=${alice_cc_user_key_byte%%\"*}
# decode the key byte string to a file with hex or base 64 encoding
echo "$alice_cc_user_key_byte_string" | xxd -r -p > alice-cc-user-key-decoded.txt
printf "$(entropy -s -f alice-cc-user-key-decoded.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv
# Alice generate several random secret wrapped in different post-quantum Kyber and or Classical variations, send it to key server
# measure entropy of the secret
openssl rand 16 > alice_secret_1.txt
printf "alice_secret_1," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_1.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv

openssl rand 16 > alice_secret_2.txt
printf "alice_secret_2," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_2.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv

openssl rand 16 > alice_secret_3.txt
printf "alice_secret_3," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_3.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv

openssl rand 16 > alice_secret_4.txt
printf "alice_secret_4," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_4.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv
# Wrapping the secret: Cosmian encrypt with cc kyber and classical elliptic curve
# encrypt the secrets with cc kyber : ec encrypt options filename policy
./ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_1.enc alice_secret_1.txt "Security::Confidential && Branch::Sydney"
printf "alice_secret_1.enc," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_1.enc)" >> quantum_entropy.csv
echo >> quantum_entropy.csv

./ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_2.enc alice_secret_2.txt "Security::Confidential && Branch::Sydney"
printf "alice_secret_2.enc," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_2.enc)" >> quantum_entropy.csv
echo >> quantum_entropy.csv

./ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_3.enc alice_secret_3.txt "Security::Confidential && Branch::Sydney"
printf "alice_secret_3.enc," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_3.enc)" >> quantum_entropy.csv
echo >> quantum_entropy.csv

./ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_4.enc alice_secret_4.txt "Security::Confidential && Branch::Sydney"
printf "alice_secret_4.enc," >> quantum_entropy.csv
printf "$(entropy -s -f alice_secret_4.enc)" >> quantum_entropy.csv
echo >> quantum_entropy.csv
# The key agreement server decrypt and concatenate the secrets and derive key from the concatenated secrets
# covercrypt decrypt
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_1.txt alice_secret_1.enc
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_2.txt alice_secret_2.enc
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_3.txt alice_secret_3.enc
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_4.txt alice_secret_4.enc

# Alice and KMS derive key from the concatenated secrets
# concatenate decrypted secrets
# cat decrypted_alice_secret_1.txt decrypted_alice_secret_2.txt decrypted_alice_secret_3.txt decrypted_alice_secret_4.txt > all_secrets.txt
decrypted_alice_secret_1=$(cat decrypted_alice_secret_1.txt)
decrypted_alice_secret_2=$(cat decrypted_alice_secret_2.txt)
decrypted_alice_secret_3=$(cat decrypted_alice_secret_3.txt)
decrypted_alice_secret_4=$(cat decrypted_alice_secret_4.txt)
echo $decrypted_alice_secret_1$decrypted_alice_secret_2$decrypted_alice_secret_3$decrypted_alice_secret_4 > all_secrets.txt
# measure entropy of the concatenated secrets
printf "all_secrets," >> quantum_entropy.csv
printf "$(entropy -s -f all_secrets.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv
# derive key from the concatenated secrets
cat all_secrets.txt | argon2 "spigenbuburaspal" -id -t 3 -m 16 -p 4 -l 16 -r > derived_key.bin
derived_aes_key=$(cat derived_key.bin | tr -d ' ')
echo -n "$derived_aes_key" > derived_aes_key.txt
# measure entropy of the derived key
printf "derived_aes_key," >> quantum_entropy.csv
printf "$(entropy -s -f derived_aes_key.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv
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
printf "alice-sym-init-decoded.txt," >> quantum_entropy.csv
printf "$(entropy -s -f alice-sym-init-decoded.txt)" >> quantum_entropy.csv
echo >> quantum_entropy.csv
# run authentication and cascading session key generation later on
# derive further symmetric key from previous key
# with rotate or re-key function of the key server or some other method with argon or scrypt