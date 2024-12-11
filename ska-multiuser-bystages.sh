# scale ska process by running multiple ska processes from many different users

# generate bulk users with password and home directory
# sudo newusers users.txt
# get usernames from users.txt
# users=$(awk -F: '{print $1}' users.txt)

# run ska process for each user at the same time while saving the data 
# would the time app collect data separately for each user?
# run time app outside of this script
# users=(alice bob charlie david eve frank grace helen ivy jack kathy leo mia nathan olivia paul quinn rose sam tina uma vince wendy xavier yara zoe)
# for user in "${users[@]}"
        # do
        # # create a group for all users and add them to the group
        # # sudo groupadd ska-users
        # sudo usermod -a -G ska-users ${user}
        # # share the file permission with the group
        # done

# ask the number of users to run the process for: 5, 10, 15, 20, 25
read -p "Enter the number of users to run the process for (5, 10, 15, 20, 25): " num_users
# create case statement for the number of users
case $num_users in
    5)
        echo "Running the process for 5 users"
        users=(alice bob charlie david eve)
        ;;
    10)
        echo "Running the process for 10 users"
        users=(alice bob charlie david eve frank grace helen ivy jack)
        ;;
    15)
        echo "Running the process for 15 users"
        users=(alice bob charlie david eve frank grace helen ivy jack kathy leo mia nathan olivia)
        ;;
    20)
        echo "Running the process for 20 users"
        users=(alice bob charlie david eve frank grace helen ivy jack kathy leo mia nathan olivia paul quinn rose sam tina)
        ;;
    25)
        echo "Running the process for 25 users"
        users=(alice bob charlie david eve frank grace helen ivy jack kathy leo mia nathan olivia paul quinn rose sam tina uma vince wendy xavier)
        ;;
    *)
        echo "Invalid number of users"
        ;;
esac

# next steps: run all scripts 30 times for 5 users in classic, quantum, hybrid and save data from all users in one file
# then run the same thing for more users, create plots from the data
# create a case statement for: hybrid, quantum, classic
read -p "Choose SKA Type to run (hybrid, quantum, classic): " ska_type
case $ska_type in

    hybrid)
        
        # echo "Running SKA Hybrid for ${num_users} users"
        echo "command name, time elapsed, cpu usage, memory usage" >> /home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv    
        sudo chown :ska-users /home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv
        sudo chmod g+w /home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv
        
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-hybrid-multiuser-keygen.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-hybrid-multiuser-secretgen.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-hybrid-multiuser-encrypt.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-hybrid-multiuser-decrypt.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-hybrid-multiuser-derive.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-hybrid-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-hybrid-multiuser-symgen.sh &
            done
        wait

        ;;

    quantum)
        
        # echo "Running SKA Quantum for ${num_users} users"
        echo "command name, time elapsed, cpu usage, memory usage" >> /home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv    
        sudo chown :ska-users /home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv
        sudo chmod g+w /home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv

        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-quantum-multiuser-keygen.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-quantum-multiuser-secretgen.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-quantum-multiuser-encrypt.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-quantum-multiuser-decrypt.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-quantum-multiuser-derive.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-quantum-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-quantum-multiuser-symgen.sh &
            done
        wait

        ;;
        
    classic)
        # echo "Running SKA Classic for ${num_users} users" > /home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv
        echo "command name, time elapsed, cpu usage, memory usage" >> /home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv    
        sudo chown :ska-users /home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv
        sudo chmod g+w /home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv
        
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-classic-multiuser-keygen.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-classic-multiuser-secretgen.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-classic-multiuser-encrypt.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-classic-multiuser-decrypt.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-classic-multiuser-derive.sh &
            done
        wait
        for user in "${users[@]}"
            do
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-classic-multiuser-bystages-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-classic-multiuser-symgen.sh &
            done
        wait

        ;;
    *)
        echo "Invalid SKA Type"
        ;;
esac
