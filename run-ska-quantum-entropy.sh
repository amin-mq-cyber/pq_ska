# remove previous data
sudo rm -rf quantum_entropy.csv
# initial csv header
# echo "command name, time elapsed, cpu usage, memory usage" > mres-ska-quantum-june20.csv    
# repeat 30 times and save data
for i in {1..30}
    do 
    # clear trailing \r character from editing in macos
    # sed -i 's/\r$//' ska-quantum-entropy.sh 
    # save data 
    echo "quantum-entropy-stages-run: $i" >> quantum_entropy.csv
    bash ska-quantum-entropy.sh 
done
