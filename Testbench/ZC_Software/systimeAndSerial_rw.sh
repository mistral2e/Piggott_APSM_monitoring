# bash systimeAndSerial.sh | tee bla.log
echo "unixtime_ms;input;time;count;delta_t;ESP_CC;delta_cc;cc_overflo"
port="/dev/ttyUSB1"
stty -F $port 460800
stty -F $port raw
stty -F $port -echo
#echo "5" > $port
while read  -r line < $port; do
  # $line is the line read, do something with it
  # which produces $result
  #echo $result > /dev/ttyS2
  #echo $line
  zeit=`date +%s%3N`
  #out="$zeit;$line"
  out="$zeit$line"
  echo $out
done

