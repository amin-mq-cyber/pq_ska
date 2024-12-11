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
        echo "command name, time elapsed, cpu usage, memory usage" >> /home/ubuntu/ska-hybrid-multiuser-${num_users}.csv    
        sudo chown :ska-users /home/ubuntu/ska-hybrid-multiuser-${num_users}.csv
        sudo chmod g+w /home/ubuntu/ska-hybrid-multiuser-${num_users}.csv
        
        for user in "${users[@]}"
            do
              # echo "Running SKA Hybrid for: ${user} at iteration: ${i}" > /home/ubuntu/ska-hybrid-multiuser-${num_users}.csv
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-hybrid-multiuser-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-hybrid-multiuser.sh &
            done
        wait
        ;;

    quantum)
        
        # echo "Running SKA Quantum for ${num_users} users"
        echo "command name, time elapsed, cpu usage, memory usage" >> /home/ubuntu/ska-quantum-multiuser-${num_users}.csv    
        sudo chown :ska-users /home/ubuntu/ska-quantum-multiuser-${num_users}.csv
        sudo chmod g+w /home/ubuntu/ska-quantum-multiuser-${num_users}.csv

        for user in "${users[@]}"
            do
            # echo "Running SKA Quantum for: ${user} at iteration: ${i}" >> /home/ubuntu/ska-quantum-multiuser-${num_users}.csv
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-quantum-multiuser-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-quantum-multiuser.sh &
            done
        wait
        ;;
        
    classic)
        # echo "Running SKA Classic for ${num_users} users" > /home/ubuntu/ska-classic-multiuser-${num_users}.csv
        echo "command name, time elapsed, cpu usage, memory usage" >> /home/ubuntu/ska-classic-multiuser-${num_users}.csv    
        sudo chown :ska-users /home/ubuntu/ska-classic-multiuser-${num_users}.csv
        sudo chmod g+w /home/ubuntu/ska-classic-multiuser-${num_users}.csv
        
        for user in "${users[@]}"
            do
              # echo "Running SKA Classic for: ${user} at iteration: ${i}" > /home/ubuntu/ska-classic-multiuser-${num_users}.csv
              sudo -u ${user} /usr/bin/time --append --output=/home/ubuntu/ska-classic-multiuser-${num_users}.csv --format='%C','%e','%P','%M' bash /home/${user}/ska-classic-multiuser.sh &
            done
        wait
        ;;
    *)
        echo "Invalid SKA Type"
        ;;
esac

# ubuntu@ip-10-0-8-13:~$ sudo cat /home/bob/ska-classic-5users-alice.csv 
# cat: /home/bob/ska-classic-5users-alice.csv: No such file or directory
# ubuntu@ip-10-0-8-13:~$ sudo cat /home/alice/ska-classic-5users-alice.csv 
# bash /home/alice/ska-classic-multiuser.sh,2.59,38%,66816
# ubuntu@ip-10-0-8-13:~$ sudo cat /home/bob/ska-classic-5users-bob.csv 
# bash /home/bob/ska-classic-multiuser.sh,2.51,39%,66944
# ubuntu@ip-10-0-8-13:~$ sudo cat /home/charlie/ska-classic-5users-charlie.csv 
# bash /home/charlie/ska-classic-multiuser.sh,2.64,37%,66944
# ubuntu@ip-10-0-8-13:~$ sudo cat /home/david/ska-classic-5users-david.csv 
# bash /home/david/ska-classic-multiuser.sh,2.43,40%,66944
# ubuntu@ip-10-0-8-13:~$ sudo cat /home/eve/ska-classic-5users-eve.csv 
# bash /home/eve/ska-classic-multiuser.sh,2.48,40%,66944