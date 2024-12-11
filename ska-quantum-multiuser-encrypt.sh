cd ~ || exit
initial_alice_kms_cc_master_public_key_id=$(cat initial_alice_kms_cc_master_public_key_id.txt)
# Wrapping the secret: Cosmian encrypt with cc kyber and classical elliptic curve
# encrypt the secrets with cc kyber : ec encrypt options filename policy
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_1.enc alice_secret_1.txt "Security::Confidential && Branch::Sydney"
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_2.enc alice_secret_2.txt "Security::Confidential && Branch::Sydney"
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_3.enc alice_secret_3.txt "Security::Confidential && Branch::Sydney"
~/ckms cc encrypt --key-id=$initial_alice_kms_cc_master_public_key_id -o alice_secret_4.enc alice_secret_4.txt "Security::Confidential && Branch::Sydney"
