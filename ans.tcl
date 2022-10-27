# create a simulator object
set ns [new Simulator]

# open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}


# create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


# create links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns duplex-link $n0 $n4 2Mb 10ms DropTail
$ns duplex-link $n0 $n5 2Mb 10ms DropTail


# create a TCP agent and attach it to node node 0
set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n0 $tcp2

set tcp3 [new Agent/TCP]
$ns attach-agent $n0 $tcp3

set tcp4 [new Agent/TCP]
$ns attach-agent $n0 $tcp4

set tcp5 [new Agent/TCP]
$ns attach-agent $n0 $tcp5


# create a FTP traffic source and attach it to tcp
set ftp1 [new Application/FTP]
set maxpkts_ 1000
$ftp1 attach-agent $tcp1

set ftp2 [new Application/FTP]
set maxpkts_ 1000
$ftp2 attach-agent $tcp2

set ftp3 [new Application/FTP]
set maxpkts_ 1000
$ftp3 attach-agent $tcp3

set ftp4 [new Application/FTP]
set maxpkts_ 1000
$ftp4 attach-agent $tcp4

set ftp5 [new Application/FTP]
set maxpkts_ 1000
$ftp5 attach-agent $tcp5


# create a Sink agent (a traffic sink) and at
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp1 $sink1

set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $sink2
$ns connect $tcp2 $sink2

set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp3 $sink3

set sink4 [new Agent/TCPSink]
$ns attach-agent $n4 $sink4
$ns connect $tcp4 $sink4

set sink5 [new Agent/TCPSink]
$ns attach-agent $n5 $sink5
$ns connect $tcp5 $sink5


#Create a udp agent and attach it to node n1
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1


# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set rate_ 1mb

$cbr0 attach-agent $udp1

#Create NULL
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0




# schedule events for all the flows

$ns at 0.1 "$ftp1 start"
$ns at 4.0 "$ftp1 stop"
$ns at 0.1 "$ftp2 start"
$ns at 4.0 "$ftp2 stop"
$ns at 0.1 "$ftp3 start"
$ns at 4.0 "$ftp3 stop"
$ns at 0.1 "$ftp4 start"
$ns at 4.0 "$ftp4 stop"
$ns at 0.1 "$ftp5 start"
$ns at 4.0 "$ftp5 stop"


# call the finish procedure after 6 seconds of simulation time
$ns at 5.0 "finish"


# run the simulation
$ns run



