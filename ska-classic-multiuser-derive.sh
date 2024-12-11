# Alice and KMS derive key from the concatenated secrets
# concatenate decrypted secrets
# cat decrypted_alice_secret_1.txt decrypted_alice_secret_2.txt decrypted_alice_secret_3.txt decrypted_alice_secret_4.txt > all_secrets.txt
cd ~ || exit

decrypted_alice_secret_1=$(cat decrypted_alice_secret_1.txt)
decrypted_alice_secret_2=$(cat decrypted_alice_secret_2.txt)
decrypted_alice_secret_3=$(cat decrypted_alice_secret_3.txt)
decrypted_alice_secret_4=$(cat decrypted_alice_secret_4.txt)
echo $decrypted_alice_secret_1$decrypted_alice_secret_2$decrypted_alice_secret_3$decrypted_alice_secret_4 > all_secrets.txt

cat all_secrets.txt | argon2 "spigenbuburaspal" -id -t 3 -m 16 -p 4 -l 16 -r > derived_key.bin
derived_aes_key=$(cat derived_key.bin | tr -d ' ')
echo -n "$derived_aes_key" > derived_aes_key.txt
# derive key with openssl kdf
# Derive a key using PBKDF2
# openssl kdf -kdfopt digest:SHA256 -kdfopt iter:10000 -kdfopt salt:hex:785ade10e5deaa31 -kdfopt info:hex:beef -kdfopt pass:password -kdfopt keylen:32 pbkdf2
alice_derived_aes_out=$(~/ckms sym keys import derived_aes_key.txt -f aes)
alice_derived_aes_key_id=${alice_derived_aes_out#*:}
echo -n "$alice_derived_aes_key_id" > alice_derived_aes_key_id.txt