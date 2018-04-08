set ns [new Simulator]

$ns color 0 pink
$ns color 1 purple
$ns color 2 green

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

set f [open out.tr w]
$ns trace-all $f
set nf [open out.nam w]
$ns namtrace-all $nf

$ns duplex-link $n0 $n3 5Mb 2ms DropTail
$ns duplex-link $n1 $n3 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 5Mb 2ms DropTail
$ns duplex-link $n3 $n4 1.2Mb 10ms DropTail

$ns queue-limit $n3 $n4 [lindex $argv 0]

$ns duplex-link-op $n0 $n3 orient right-up
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n2 $n3 orient right-down
$ns duplex-link-op $n3 $n4 orient right

$ns duplex-link-op $n3 $n4 queuePos 0.5

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
$tcp0 set class_ 0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
$tcp1 set class_ 1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
$tcp2 set class_ 2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

set sink0 [new Agent/TCPSink]
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns attach-agent $n4 $sink1
$ns attach-agent $n4 $sink2

$ns connect $tcp0 $sink0
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

$ns at 1.0 "$ftp0 start"
$ns at 1.2 "$ftp1 start"
$ns at 1.4 "$ftp2 start"

$ns at 3.0 "finish"

proc finish {} {
	global ns f nf
	$ns flush-trace
	close $f
	close $nf

#	puts "running nam..."
#	exec nam out.nam &
	exit 0
}

$ns run
