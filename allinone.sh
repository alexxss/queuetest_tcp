set -x
ns simple.tcl $1
awk -f loss-rate.awk out.tr
awk -f throughput.awk out.tr
awk -f end-to-end.awk out.tr 
awk -f jitter.awk out.tr >jitter.txt
python jitter.py
