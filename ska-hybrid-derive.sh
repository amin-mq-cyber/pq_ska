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
openssl rand -base64 16 > salt.txt
salt=$(cat salt.txt)
cat all_secrets.txt | argon2 $salt -id -t 3 -m 16 -p 4 -l 16 -r > derived_key.bin
derived_aes_key=$(cat derived_key.bin | tr -d ' ')
echo -n "$derived_aes_key" > derived_aes_key.txt
# derive key with openssl kdf
# Derive a key using PBKDF2
# openssl kdf -kdfopt digest:SHA256 -kdfopt iter:10000 -kdfopt salt:hex:785ade10e5deaa31 -kdfopt info:hex:beef -kdfopt pass:password -kdfopt keylen:32 pbkdf2

# Use scrypt to create a hex-encoded derived key from a password and salt:
# openssl kdf -keylen 64 -kdfopt pass:password -kdfopt salt:NaCl -kdfopt n:1024 -kdfopt r:8 -kdfopt p:16 -kdfopt maxmem_bytes:10485760 SCRYPT

# import the derived key raw bytes to key server
# ./ckms sym keys import derived_key.bin -f aes 
# The SymmetricKey in file "derived_key.bin" was imported with id: e900ad4a-fc22-4a4e-982a-e471e3c1d216
# get the key id of the imported derived key
# -f, --key-format <KEY_FORMAT>
# The format of the key [default: json-ttlv] [possible values: json-ttlv, pem, sec1, pkcs1-priv, pkcs1-pub, pkcs8, spki, aes, chacha20]
alice_derived_aes_out=$(./ckms sym keys import derived_aes_key.txt -f aes)
alice_derived_aes_key_id=${alice_derived_aes_out#*:}
echo -n "$alice_derived_aes_key_id" > alice_derived_aes_key_id.txt