cd ~ || exit
# import private key id from output files of ska-hybrid-keygen.sh into variables
initial_alice_kms_ec_private_key_id=$(cat initial_alice_kms_ec_private_key_id.txt)
initial_alice_kms_cc_user_key_id=$(cat initial_alice_kms_cc_user_key_id.txt)

# The key agreement server decrypt and concatenate the secrets and derive key from the concatenated secrets
# elliptic curve decrypt
~/ckms ec decrypt alice_secret_1.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_1.txt
~/ckms ec decrypt alice_secret_2.enc --key-id=$initial_alice_kms_ec_private_key_id -o decrypted_alice_secret_2.txt
# covercrypt decrypt
~/ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_3.txt alice_secret_3.enc
~/ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_4.txt alice_secret_4.enc
