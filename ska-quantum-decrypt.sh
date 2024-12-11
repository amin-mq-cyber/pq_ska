# The key agreement server decrypt and concatenate the secrets and derive key from the concatenated secrets
# elliptic curve decrypt
# import private key id from output files of ska-hybrid-keygen.sh into variables
initial_alice_kms_cc_user_key_id=$(cat initial_alice_kms_cc_user_key_id.txt)
# covercrypt decrypt
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_1.txt alice_secret_1.enc
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_2.txt alice_secret_2.enc
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_3.txt alice_secret_3.enc
./ckms cc decrypt --key-id=$initial_alice_kms_cc_user_key_id -o decrypted_alice_secret_4.txt alice_secret_4.enc
