# Get CPU model (removed "(R)", "(TM)", and clock speed)
model=$(awk -F ': ' '/model name/{print $2}' /proc/cpuinfo | head -n 1 | sed 's/@.*//; s/ *\((R)\|(TM)\)//g; s/^[ \t]*//; s/[ \t]*$//')

# Get CPU usage percentage
load=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')

# Get CPU temperature
temp=$(sensors | awk '/Package id 0/ {print $4}' | awk -F '[+.]' '{print $2}')

# Gets average CPU frequency
freqlist=$(awk '/cpu MHz/ {print $4}' /proc/cpuinfo)
maxfreq=$(sed 's/...$//' /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
average_freq=$(echo "$freqlist" | tr ' ' '\n' | awk "{sum+=\$1} END {printf \"%.0f/%s MHz\", sum/NR, $maxfreq}")

# Color red if load is high
if [ "$load" -ge 80 ]; then
  text_output="<span color='#f38ba8'>󰀩 ${load}%</span>"
else
  text_output="󰻠 ${load}%"
fi

tooltip="${model}"
tooltip+="\nCPU Freq: ${average_freq}"
tooltip+="\nCPU Temperature: ${temp}°C"

# Module and tooltip
echo "{\"text\": \"$text_output\", \"tooltip\": \"$tooltip\"}"
