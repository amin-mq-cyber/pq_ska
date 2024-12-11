#!/bin/bash
# SKA Classic: 4 parts: 4 parts in classical elliptic curve
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

