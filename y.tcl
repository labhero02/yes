#hello.tcl
# Create a simulator object
set ns [new Simulator]

$ns color 1 blue
$ns color 0 red

# Open the NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf
# Define a 'finish' procedure
proc finish {} {
global ns nf
$ns flush-trace
close $nf
exec nam out.nam 
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

#Create a tcp agent and attach it to node n0
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

#Create a udp agent and attach it to node n1
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

#coloring
$tcp0 set fid_ 0
$udp1 set fid_ 1

# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set rate_ 1mb

$cbr0 attach-agent $udp1

#Create a FTP traffic source and attack it to tcp
set ftp1 [new Application/FTP]
$ftp1 set packetSize_ 1000
$ftp1 set rate_ 1mb
$ftp1 attach-agent $tcp0

#Create NULL & SINK
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

#connection
$ns connect $udp1 $null0
$ns connect $tcp0 $sink
$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$ftp1 start"
$ns at 4.0 "$ftp1 stop"
$ns at 4.5 "$cbr0 stop"
# Call the finish procedure after # 5 seconds of simulation time
$ns at 5.0 "finish"
# Run the simulation
$ns run


