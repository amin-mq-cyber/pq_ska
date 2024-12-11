# remove previous data
sudo rm -rf classic_entropy.csv
# initial csv header
# echo "command name, time elapsed, cpu usage, memory usage" > mres-ska-quantum-june20.csv    
# repeat 30 times and save data
for i in {1..30}
    do 
    # clear trailing \r character from editing in macos
    # sed -i 's/\r$//' key-agreement-setupv4.sh 
    # save data 
    echo "classic-entropy-stages-run: $i" >> classic_entropy.csv
    bash ska-classic-entropy.sh 
done
