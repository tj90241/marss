#!/usr/bin/expect

# Start qemu, let it boot a bit
set timeout 300
spawn /data/nvme2/marss/qemu/qemu-system-x86_64 -nographic -serial mon:stdio -m 2048 -hda /data/nvme2/marss/trusty.qcow2
sleep 5

# Configure the simulator
send "\x01"; send "c"; 
expect "(qemu)"
send "simconfig -machine ooo_2_th\n"
expect "Simulator is now waiting for a 'run' command."
expect "(qemu)"
send "\x01"; send "c"; 

# Wait for the thing to boot
expect "ubuntu login:"
send "root\n"
expect "Password:"
send "root\n"
expect "root@ubuntu:~#"

# Run a simulation
send "./start_sim; ./FFT; ./stop_sim; echo EXPECT_MAGIC_STRING\n"
expect "MARSSx86::Command received : -run"
expect "Overall transpose time"
expect "seconds of sim time (cycle/sec:"
expect "EXPECT_MAGIC_STRING"
expect "root@ubuntu:~#"

# Shutdown the VM
send "shutdown -h now\n"
expect "reboot: Power down"
expect eof
