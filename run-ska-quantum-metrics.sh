# remove previous data
sudo rm -rf mres-ska-quantum-metrics.csv
# initial csv header
echo "command name, time elapsed, cpu usage, memory usage" > mres-ska-quantum-metrics.csv    
# repeat 30 times and save data
for i in {1..30..1}
    do 
    # clear trailing \r character from editing in macos
    # sed -i 's/\r$//' key-agreement-setupv4.sh 
    # save data 
    /usr/bin/time --append --output=mres-ska-quantum-metrics.csv --format='%C','%e','%P','%M' bash ska-quantum-keygen.sh
    /usr/bin/time --append --output=mres-ska-quantum-metrics.csv --format='%C','%e','%P','%M' bash ska-quantum-secretgen.sh
    /usr/bin/time --append --output=mres-ska-quantum-metrics.csv --format='%C','%e','%P','%M' bash ska-quantum-encrypt.sh
    /usr/bin/time --append --output=mres-ska-quantum-metrics.csv --format='%C','%e','%P','%M' bash ska-quantum-decrypt.sh
    /usr/bin/time --append --output=mres-ska-quantum-metrics.csv --format='%C','%e','%P','%M' bash ska-quantum-derive.sh
    /usr/bin/time --append --output=mres-ska-quantum-metrics.csv --format='%C','%e','%P','%M' bash ska-quantum-symgen.sh
done
