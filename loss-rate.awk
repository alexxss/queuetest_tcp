#這是測量CBR封包遺失率的awk程式
BEGIN {
	#程式初始化,設定一變數記錄packet被drop的數目
	packetSent = 0;
	packetReceived = 0;
}
{
	action=$1;
	time=$2;
	from=$3;
	to=$4;
	type=$5;
	pktsize=$6;
	flow_id=$8;
	src=$9;
	dst=$10;
	seq_no=$11;
	packet_id=$12;

	#統計從n1+n3送出多少packets
	if (from==0 && action == "+")
		packetSent++;
	if(from==1 && action == "+")
		packetSent++;
	if(from==2 && action == "+")
		packetSent++;
	#統計收到多少packets
	if (to==4 && action == "r")
		packetReceived++;	
}
END {
	printf("Packets sent:%d, Received:%d\nLoss rate:%.2f%%\n", packetSent, packetReceived, (packetSent-packetReceived)/packetSent);
}
