set ns [new Simulator]

set nf [open out.nam w]

$ns namtrace-all $nf

proc finish {} {

    global ns nf

    $ns flush-trace

    close $nf

    exec nam out.nam &

    exit 0

}



$ns color 1 Green

set n0 [$ns node]

set n1 [$ns node]

set n2 [$ns node]

set n3 [$ns node]



set lan0 [$ns newLan "$n0 $n1 $n2 $n3" 0.7Mb 20ms LL Queue/DropTail MAC/Csma/-802_3 channel] 



set udp [new Agent/UDP]

$udp set fid_ 1

$ns attach-agent $n0 $udp

set cbr [new Application/Traffic/CBR]

$cbr set packetSize _1000

$cbr set interval _0.005

$cbr attach-agent $udp

set sinkUDP [new Agent/Null]

$ns attach-agent $n2 $sinkUDP

$ns connect $udp $sinkUDP

$ns at 1.0 "$cbr start"

$ns at 4.0 "$cbr stop"

$ns at 5.0 "finish"

puts "CBR packet Size = [$cbr set packet_size_]"

$ns run