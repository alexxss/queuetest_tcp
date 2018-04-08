#測量jitter(抖動率)
#抖動率(jitter) = 延遲時間變化量(delay variance)
#網路流量大時, 許多封包就必須在佇列中等待被傳送
#因此每個封包從傳送端到目的端的時間不一定會相同, 而這個差異就是jitter
#jitter = [(recvtime(j)-sendtime(j)) - (recvtime(i)-sendtime(i))] /(j-i), 其中j>i

#awk -f jitter.awk out.tr > jitter_out.txt
BEGIN{
	#程式初始化，設定一變數以記錄目前最高處理封包的ID
	highest_packet_id = 0;
}
{
	action = $1;	#+/- 表示進入/離開了佇列   r/d表示封包被某個節點接收/丟棄  
	time = $2;	#事件發生的時間 
	from = $3;      #事件發生地點 (from node)
	to = $4;        #事件發生地點 (to node)
	type = $5;      #封包的型態
	pktsize = $6;   #封包的大小
	flow_id = $8;   #封包屬於哪個資料流
	src = $9;       #封包的來源端   (a.b) a = 節點編號, b = port number
	dst = $10;	# 封包的目的端   (a.b) a = 節點編號, b = port number
	seq_no = $11;   # 封包的序號
	packet_id = $12;# 封包的ID
	
	#紀錄目前最高的packet ID
	if(packet_id > highest_packet_id )
		highest_packet_id = packet_id;
	#紀錄封包的傳送時間
	if(start_time[packet_id] == 0){
		#記錄下包的seq_no
		pkt_seqno[packet_id] = seq_no;
		start_time[packet_id] = time;
	}
	#紀錄(flow_id = 2)的接收時間
	if(action != "d"){
		if(action == "r"){
			end_time[packet_id] = time;
		}
	}else{
		#把不是flow_id = 2的封包
		#或是flow_id = 2但此封包被丟棄的時間設為-1
		end_time[packet_id] = -1;
	}	
}

END{
	#初始化jitter計算所需變量
	last_seqno = 0;
	last_delay = 0;
	seqno_diff = 0;
	#當資料列全部讀取完後，開始計算有效封包的端點到端點延遲時間
	for(packet_id = 0; packet_id <= highest_packet_id; packet_id++){
		start = start_time[packet_id];
		end   = end_time[packet_id]; 
		packet_duration = end - start;
		#只把接收時間大於傳送時間的紀錄列出來
		if(start < end) {
			#得到了delay值(packet_duration)後計算jitter 
	seqno_diff = pkt_seqno[packet_id] - last_seqno;
	delay_diff = packet_duration - last_delay;
			if(seqno_diff == 0){
				jitter = 0;
			}else{
				jitter = delay_diff/seqno_diff;
			}
		printf("%f %f\n", start, jitter);
		last_seqno = pkt_seqno[packet_id];
		last_delay = packet_duration;
		}
	}
}
