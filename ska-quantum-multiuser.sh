#!/bin/bash
# SKA Quantum: 4 parts: 4 parts wrapped in kyber
# repeat 30 times and save data
# for i in {1..30}
#    do something
# done
# create initial public and private key pairs for Alice and KMS server admin
# this will be used to encrypt the secret between Alice and KMS server
# initial csv header
# echo "command name, time elapsed, cpu usage, memory usage" > mres-ska-hybrid-june17.csv
# save data 
# time -p --append --output mres-ska-hybrid-june17.csv --format=" '%C','%e','%P','%M' "
cd ~ || exit
echo "Current working directory: $(pwd)"

# create kyber cc master key and policy
initial_alice_kms_cc_master_out=$(~/ckms cc keys create-master-key-pair -s policy_spec.json | tr -d ' ')
# The master key pair has been properly generated.
#   Private key unique identifier: 11c4a956-92a4-43cd-87d4-04d1ff90fc96
#   Public key unique identifier : 7f594e83-e8fd-4f85-9555-ea45adb3de3d
#   Tags:
#     - cc-alice-kms
# get substring of the master private key id and save it into variable
initial_alice_kms_cc_master_out_private_key_id=${initial_alice_kms_cc_master_out#*:}
initial_alice_kms_cc_master_private_key_id=${initial_alice_kms_cc_master_out_private_key_id:0:36}    
# get substring of the public key id and save it into variable
initial_alice_kms_cc_master_public_key_id=${initial_alice_kms_cc_master_out#*:*:}

# create cc user key for alice
# cc master public key can be used to encrypt
# master secret key is used to generate user decryption keys
# use user key to decrypt
~/ckms cc keys create-user-key $initial_alice_kms_cc_master_private_key_id "Security::Confidential && Branch::Sydney"
# Created the user decryption key with ID: 8891fa9c-1e24-481b-9f11-d040e9283381
# get user key id
initial_alice_kms_cc_user_key_out=$(~/ckms cc keys create-user-key $initial_alice_kms_cc_master_private_key_id "Security::Confidential && Branch::Sydney" | tr -d ' ')
initial_alice_kms_cc_user_key_id=${initial_alice_kms_cc_user_key_out#*:}
# use tag for easier identification of secret materials, using variable is even better

# Alice generate several random secret wrapped in different post-quantum Kyber and or Classical variations, send it to key server
# Secret key generator:  https://www.tecmint.com/generate-pre-shared-key-in-linux/ 
openssl rand -base64 16 > alice_secret_1.txt
openssl rand -base64 16 > alice_secret_2.txt
openssl rand -base64 16 > alice_secret_3.txt
openssl rand -base64 16 > alice_secret_4.txt

# Wrapping the secret: Cosmian encrypt with cc kyber and classical elliptic curve
# encrypt the secrets with cc kyber : ec encrypt options filename policy
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_1.enc alice_secret_1.txt "Security::Confidential && Branch::Sydney"
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_2.enc alice_secret_2.txt "Security::Confidential && Branch::Sydney"
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_3.enc alice_secret_3.txt "Security::Confidential && Branch::Sydney"
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_4.enc alice_secret_4.txt "Security::Confidential && Branch::Sydney"

# send encrypted secret to key server
# scp alice_secret*.enc ubuntu@amin-kms.mqu.cloud:/home/ubuntu/cosmian

# The key agreement server decrypt and concatenate the secrets and derive key from the concatenated secrets
# covercrypt decrypt
~/ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_1.txt alice_secret_1.enc
~/ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_2.txt alice_secret_2.enc
~/ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_3.txt alice_secret_3.enc
~/ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_4.txt alice_secret_4.enc

# Alice and KMS derive key from the concatenated secrets
# concatenate decrypted secrets
# cat decrypted_alice_secret_1.txt decrypted_alice_secret_2.txt decrypted_alice_secret_3.txt decrypted_alice_secret_4.txt > all_secrets.txt
decrypted_alice_secret_1=$(cat decrypted_alice_secret_1.txt)
decrypted_alice_secret_2=$(cat decrypted_alice_secret_2.txt)
decrypted_alice_secret_3=$(cat decrypted_alice_secret_3.txt)
decrypted_alice_secret_4=$(cat decrypted_alice_secret_4.txt)
echo $decrypted_alice_secret_1$decrypted_alice_secret_2$decrypted_alice_secret_3$decrypted_alice_secret_4 > all_secrets.txt
# echo $decrypted_alice_secret_1$decrypted_alice_secret_2 > all_secrets.txt
# derive key from concatenated secrets
# derive key with wrap unwrap or using argon or scrypt
# derive key not clear yet, wrap and unwrap can be an option during export and import
# argon is the best option for key derivation
# Usage:  argon2 [-h] salt [-i|-d|-id] [-t iterations] [-m log2(memory in KiB) | -k memory in KiB] [-p parallelism] [-l hash length] [-e|-r] [-v (10|13)]
#         Password is read from stdin
# Parameters:
#         salt            The salt to use, at least 8 characters
#         -i              Use Argon2i (this is the default)
#         -d              Use Argon2d instead of Argon2i
#         -id             Use Argon2id instead of Argon2i
#         -t N            Sets the number of iterations to N (default = 3)
#         -m N            Sets the memory usage of 2^N KiB (default 12)
#         -k N            Sets the memory usage of N KiB (default 4096)
#         -p N            Sets parallelism to N threads (default 1)
#         -l N            Sets hash output length to N bytes (default 32)
#         -e              Output only encoded hash
#         -r              Output only the raw bytes of the hash
#         -v (10|13)      Argon2 version (defaults to the most recent version, currently 13)
#         -h              Print argon2 usage
# echo -n "password" | argon2 "somesalt" -id -t 2 -m 16 -p 4 -l 32
# Type:           Argon2id
# Iterations:     2
# Memory:         65536 KiB
# Parallelism:    4
# Hash:           1a9677b0afe81fda7b548895e7a1bfeb8668ffc19a530e37e088a668fab1c02a
# Encoded:        $argon2id$v=19$m=65536,t=2,p=4$c29tZXNhbHQ$GpZ3sK/oH9p7VIiV56G/64Zo/8GaUw434IimaPqxwCo
# 0.219 seconds
# Verification ok
cat all_secrets.txt | argon2 "spigenbuburaspal" -id -t 3 -m 16 -p 4 -l 16 -r > derived_key.bin
derived_aes_key=$(cat derived_key.bin | tr -d ' ')
echo -n "$derived_aes_key" > derived_aes_key.txt
# derive key with openssl kdf
# Derive a key using PBKDF2
# openssl kdf -kdfopt digest:SHA256 -kdfopt iter:10000 -kdfopt salt:hex:785ade10e5deaa31 -kdfopt info:hex:beef -kdfopt pass:password -kdfopt keylen:32 pbkdf2

# Use scrypt to create a hex-encoded derived key from a password and salt:
# openssl kdf -keylen 64 -kdfopt pass:password -kdfopt salt:NaCl -kdfopt n:1024 -kdfopt r:8 -kdfopt p:16 -kdfopt maxmem_bytes:10485760 SCRYPT

# import the derived key raw bytes to key server
# ~/ckms sym keys import derived_key.bin -f aes 
# The SymmetricKey in file "derived_key.bin" was imported with id: e900ad4a-fc22-4a4e-982a-e471e3c1d216
# get the key id of the imported derived key
# -f, --key-format <KEY_FORMAT>
# The format of the key [default: json-ttlv] [possible values: json-ttlv, pem, sec1, pkcs1-priv, pkcs1-pub, pkcs8, spki, aes, chacha20]
alice_derived_aes_out=$(~/ckms sym keys import derived_aes_key.txt -f aes)
alice_derived_aes_key_id=${alice_derived_aes_out#*:}

# The key agreement server create symmetric key and encrypt it with derived key
# The symmetric key was created with id: 2917d60e-ca11-414c-850f-2fd785b45d33.
initial_alice_sym_out=$(~/ckms sym keys create | tr -d ' ')
initial_alice_sym_out_key_id=${initial_alice_sym_out#*:}
initial_alice_sym_key_id=${initial_alice_sym_out_key_id:0:36}

# Export the symmetric key 
# The key ff7e6cab-9922-4ab7-8173-9f32a23fb523 of type SymmetricKey was exported to "alice-sym-init.bin"
# Encrypt the symmetric key and wrap it with imported derived key
~/ckms sym keys export --key-id=$initial_alice_sym_key_id alice-sym-init.txt -w $alice_derived_aes_key_id
# Import the key back and unwrap it with the derived key
# ~/ckms sym keys import alice-sym-init.txt -u $alice_derived_aes_key_id

# ~/ckms sym encrypt --key-id=$alice_derived_aes_key_id alice-sym-init.txt -o alice-sym-init.enc 
# Send the encrypted symmetric key to Alice
# scp alice-sym-init.enc ubuntu@alice-mres.mqu.cloud:/home/ubuntu/cosmian
# Alice decrypts root-trusted-key to create initial-authentication and session key
# ~/ckms sym decrypt --key-id=$alice_derived_aes_key_id alice-sym-init.enc -o alice-sym-init.bin 
# run authentication and cascading session key generation later on
# derive further symmetric key from previous key
# with rotate or re-key function of the key server or some other method with argon or scrypt