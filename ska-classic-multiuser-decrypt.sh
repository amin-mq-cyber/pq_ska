# The key agreement server decrypt and concatenate the secrets and derive key from the concatenated secrets
# elliptic curve decrypt
cd ~ || exit
initial_alice_kms_ec_private_key_id=$(cat initial_alice_kms_ec_private_key_id.txt)
# classical elliptic curve decrypt
~/ckms ec decrypt alice_secret_1.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_1.txt
~/ckms ec decrypt alice_secret_2.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_2.txt
~/ckms ec decrypt alice_secret_3.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_3.txt
~/ckms ec decrypt alice_secret_4.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_4.txt