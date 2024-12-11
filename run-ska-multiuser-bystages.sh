# HYBRID MULTIUSER bystages
# clean up the previous files
# sudo rm -rf /home/ubuntu/ska-hybrid-multiuser-${num_users}.csv
# # create file and seed initial data

for i in {1..30..1}
    do
# # run ska-multiuser-bystages.sh for 5 users and hybrid ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "5\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "hybrid\r"
    expect eof
EOF

# # run ska-multiuser-bystages.sh for 10 users and hybrid ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "10\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "hybrid\r"
    expect eof
EOF

# # run ska-multiuser-bystages.sh for 15 users and hybrid ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "15\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "hybrid\r"
    expect eof
EOF

# run ska-multiuser-bystages.sh for 20 users and hybrid ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "20\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "hybrid\r"
    expect eof
EOF

# run ska-multiuser-bystages.sh for 25 users and hybrid ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "25\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "hybrid\r"
    expect eof
EOF
# echo "Iteration: $i"
done

# QUANTUM MULTIUSER bystages
# clean up the previous files
# sudo rm -rf /home/ubuntu/ska-quantum-multiuser-${num_users}.csv
# # create file and seed initial data
 for i in {1..30..1}
    do
# # run ska-multiuser-bystages.sh for 5 users and quantum ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "5\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "quantum\r"
    expect eof
EOF

# # run ska-multiuser-bystages.sh for 10 users and quantum ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "10\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "quantum\r"
    expect eof
EOF

# # run ska-multiuser-bystages.sh for 15 users and quantum ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "15\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "quantum\r"
    expect eof
EOF

# run ska-multiuser-bystages.sh for 20 users and quantum ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "20\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "quantum\r"
    expect eof
EOF

# run ska-multiuser-bystages.sh for 25 users and quantum ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "25\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "quantum\r"
    expect eof
EOF
# echo "Iteration: $i"
    done

# CLASSIC MULTIUSER bystages
# clean up the previous files
# sudo rm -rf /home/ubuntu/ska-classic-multiuser-${num_users}.csv
# # create file and seed initial data

for i in {1..30..1}
    do
# # run ska-multiuser-bystages.sh for 5 users and classic ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "5\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "classic\r"
    expect eof
EOF

# # run ska-multiuser-bystages.sh for 10 users and classic ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "10\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "classic\r"
    expect eof 
EOF

# # run ska-multiuser-bystages.sh for 15 users and classic ska type for 30 iterations (use spawn and expect)
     expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "15\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "classic\r"
    expect eof
EOF

# run ska-multiuser-bystages.sh for 20 users and classic ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "20\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "classic\r"
    expect eof
EOF

# run ska-multiuser-bystages.sh for 25 users and classic ska type for 30 iterations (use spawn and expect)
    expect <<EOF
    spawn bash ska-multiuser-bystages.sh
    expect "Enter the number of users to run the process for (5, 10, 15, 20, 25): "
    send "25\r"
    expect "Choose SKA Type to run (hybrid, quantum, classic): "
    send "classic\r"
    expect eof
EOF
# echo "Iteration: $i"
    done

# End of run-ska-multiuser-bystages.sh