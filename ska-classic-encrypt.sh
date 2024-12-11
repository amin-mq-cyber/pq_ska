# Wrapping the secret: Cosmian encrypt with cc kyber and classical elliptic curve
# encrypt the secrets with classical elliptic curve : ec encrypt options filename
# ckms ec encrypt --key-id <FILE>
# import the key files from ska-hybrid-keygen.sh to variables
initial_alice_kms_ec_public_key_id=$(cat initial_alice_kms_ec_public_key_id.txt)
# encrypt the secrets with classical elliptic curve
./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_1.txt -o alice_secret_1.enc
./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_2.txt -o alice_secret_2.enc
./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_3.txt -o alice_secret_3.enc
./ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_4.txt -o alice_secret_4.enc