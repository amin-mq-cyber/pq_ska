cd ~ || exit
# import the derived key raw bytes to key server
# ~/ckms sym keys import derived_key.bin -f aes 
# The SymmetricKey in file "derived_key.bin" was imported with id: e900ad4a-fc22-4a4e-982a-e471e3c1d216
# get the key id of the imported derived key
# -f, --key-format <KEY_FORMAT>
# The format of the key [default: json-ttlv] [possible values: json-ttlv, pem, sec1, pkcs1-priv, pkcs1-pub, pkcs8, spki, aes, chacha20]
# alice_derived_aes_out=$(~/ckms sym keys import derived_aes_key.txt -f aes)
# alice_derived_aes_key_id=${alice_derived_aes_out#*:}

# The key agreement server create symmetric key and encrypt it with derived key
# The symmetric key was created with id: 2917d60e-ca11-414c-850f-2fd785b45d33.
initial_alice_sym_out=$(~/ckms sym keys create | tr -d ' ')
initial_alice_sym_out_key_id=${initial_alice_sym_out#*:}
initial_alice_sym_key_id=${initial_alice_sym_out_key_id:0:36}

# Export the symmetric key 
# The key ff7e6cab-9922-4ab7-8173-9f32a23fb523 of type SymmetricKey was exported to "alice-sym-init.bin"
# Encrypt the symmetric key and wrap it with imported derived key
alice_derived_aes_key_id=$(cat alice_derived_aes_key_id.txt)
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