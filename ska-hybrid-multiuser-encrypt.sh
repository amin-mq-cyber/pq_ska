cd ~ || exit

# import the key files from ska-hybrid-keygen.sh to variables
initial_alice_kms_ec_public_key_id=$(cat initial_alice_kms_ec_public_key_id.txt)
initial_alice_kms_cc_master_public_key_id=$(cat initial_alice_kms_cc_master_public_key_id.txt)
# Wrapping the secret: Cosmian encrypt with cc kyber and classical elliptic curve
# encrypt the secrets with classical elliptic curve : ec encrypt options filename
# ckms ec encrypt --key-id <FILE>
~/ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_1.txt -o alice_secret_1.enc
~/ckms ec encrypt --key-id=$initial_alice_kms_ec_public_key_id alice_secret_2.txt -o alice_secret_2.enc
# The encrypted file is available at "alice_secret_1.enc"
# The encrypted file is available at alice_secret_2.enc
# encrypt the secrets with cc kyber : ec encrypt options filename policy
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_3.enc alice_secret_3.txt "Security::Confidential && Branch::Sydney"
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_4.enc alice_secret_4.txt "Security::Confidential && Branch::Sydney"

# send encrypted secret to key server
# scp alice_secret*.enc ubuntu@amin-kms.mqu.cloud:/home/ubuntu/cosmian
