# Get CPU usage percentage
ram_used=$(free | awk '/Mem:/ {printf "%d", ($3/$2)*100}')
ram_stats=$(free --giga -h | awk '/Mem:/ {printf "Total Memory: %dGB\\nUsed Memory: %dGB", $2, $3}')

# Set color based on CPU load
if [ "$ram_used" -ge 90 ]; then
  # If CPU usage is >= 90%, set color to #f38ba8
  text_output="<span color='#f38ba8'>󰀩 ${ram_used}%</span>"
else
  # Default color
  text_output=" ${ram_used}%"
fi

tooltip="${ram_stats}"

# Module and tooltip
echo "{\"text\": \"$text_output\", \"tooltip\": \"$tooltip\"}"
