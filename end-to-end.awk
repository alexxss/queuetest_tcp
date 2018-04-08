#測量TCP End-to-End Delay的awk程式
#awk –f delay.awk out.tr
BEGIN {
	#紀錄packet最大的id
	highest_packet_id = 0;
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

	#記錄目前已處理數據包最大的ID
	if (packet_id>highest_packet_id)
		highest_packet_id = packet_id;
	#記錄packet的發送時間
	if (action=="+" && start_time[packet_id]==0){
		start_time[packet_id] = time;
		srcn[packet_id] = src;
	}
	#記錄TCP的接收時間
	if(action=="r" && end_time[packet_id]<time){
		end_time[packet_id]=time;
	}

	
}
END {
	#讀完trace檔後 計算有效packet的End-to-End Delay
	total = 0; count = 0;
	for(packet_id=0; packet_id <= highest_packet_id; packet_id++){
		start=start_time[packet_id];
		end=end_time[packet_id];
		packet_duration=end-start;
		if (packet_duration > 0) {		
			total += packet_duration;
			count ++;
		} 
	}
	printf("Average end-to-end delay: %.3fs\n",total/count);

}
