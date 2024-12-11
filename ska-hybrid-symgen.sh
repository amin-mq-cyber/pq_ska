initial_alice_sym_out=$(./ckms sym keys create | tr -d ' ')
initial_alice_sym_out_key_id=${initial_alice_sym_out#*:}
initial_alice_sym_key_id=${initial_alice_sym_out_key_id:0:36}

# Export the symmetric key 
# The key ff7e6cab-9922-4ab7-8173-9f32a23fb523 of type SymmetricKey was exported to "alice-sym-init.bin"
# Encrypt the symmetric key and wrap it with imported derived key
# import the derived key id from files into variables
alice_derived_aes_key_id=$(cat alice_derived_aes_key_id.txt)
./ckms sym keys export --key-id=$initial_alice_sym_key_id alice-sym-init.txt -w $alice_derived_aes_key_id