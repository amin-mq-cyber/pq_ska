# remove previous data
sudo rm -rf mres-ska-hybrid-metrics.csv
# initial csv header
echo "command name, time elapsed, cpu usage, memory usage" > mres-ska-hybrid-metrics.csv    
# repeat 30 times and save data
for i in {1..30}
    do 
    # clear trailing \r character from editing in macos
    # sed -i 's/\r$//' key-agreement-setupv4.sh 
    # save data 
    /usr/bin/time --append --output=mres-ska-hybrid-metrics.csv --format='%C','%e','%P','%M' bash ska-hybrid-keygen.sh
    /usr/bin/time --append --output=mres-ska-hybrid-metrics.csv --format='%C','%e','%P','%M' bash ska-hybrid-secretgen.sh
    /usr/bin/time --append --output=mres-ska-hybrid-metrics.csv --format='%C','%e','%P','%M' bash ska-hybrid-encrypt.sh
    /usr/bin/time --append --output=mres-ska-hybrid-metrics.csv --format='%C','%e','%P','%M' bash ska-hybrid-decrypt.sh
    /usr/bin/time --append --output=mres-ska-hybrid-metrics.csv --format='%C','%e','%P','%M' bash ska-hybrid-derive.sh
    /usr/bin/time --append --output=mres-ska-hybrid-metrics.csv --format='%C','%e','%P','%M' bash ska-hybrid-symgen.sh
done
