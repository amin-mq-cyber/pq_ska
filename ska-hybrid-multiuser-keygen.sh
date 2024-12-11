#!/bin/bash
# SKA Hybrid: 4 parts: 2 parts wrapped in kyber, 2 parts in classical elliptic curve
# Set the working directory
cd ~ || exit
echo "Current working directory: $(pwd)"

initial_alice_kms_ec_out=$(~/ckms ec keys create | tr -d ' ')
# get substring of the private key id and save it into variable
initial_alice_kms_ec_out_private_key_id=${initial_alice_kms_ec_out#*:}
initial_alice_kms_ec_private_key_id=${initial_alice_kms_ec_out_private_key_id:0:36} 
# save the private key id into a file
echo -n "$initial_alice_kms_ec_private_key_id" > initial_alice_kms_ec_private_key_id.txt   
# get substring of the public key id and save it into variable
initial_alice_kms_ec_public_key_id=${initial_alice_kms_ec_out#*:*:}
# save the public key id into a file
echo -n "$initial_alice_kms_ec_public_key_id" > initial_alice_kms_ec_public_key_id.txt
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
# save the master private key id into a file
echo -n "$initial_alice_kms_cc_master_private_key_id" > initial_alice_kms_cc_master_private_key_id.txt
# get substring of the public key id and save it into variable
initial_alice_kms_cc_master_public_key_id=${initial_alice_kms_cc_master_out#*:*:}
# save the master public key id into a file
echo -n "$initial_alice_kms_cc_master_public_key_id" > initial_alice_kms_cc_master_public_key_id.txt

# create cc user key for alice
# cc master public key can be used to encrypt
# master secret key is used to generate user decryption keys
# use user key to decrypt
~/ckms cc keys create-user-key $initial_alice_kms_cc_master_private_key_id "Security::Confidential && Branch::Sydney"
# Created the user decryption key with ID: 8891fa9c-1e24-481b-9f11-d040e9283381
# get user key id
initial_alice_kms_cc_user_key_out=$(~/ckms cc keys create-user-key $initial_alice_kms_cc_master_private_key_id "Security::Confidential && Branch::Sydney" | tr -d ' ')
initial_alice_kms_cc_user_key_id=${initial_alice_kms_cc_user_key_out#*:}
# save the user key id into a file
echo -n "$initial_alice_kms_cc_user_key_id" > initial_alice_kms_cc_user_key_id.txt
# use tag for easier identification of secret materials, using variable is even better
