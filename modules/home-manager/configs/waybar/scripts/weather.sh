#!/bin/sh

# Location: Humble, Texas
LOC="Humble,Texas"
# Alternative: LOC="29.99,-95.26"

# Fetch weather
# format=1: one line output (e.g., "☀️ +25°C")
# u: USCS (Fahrenheit, mph, etc.)
text="$(curl -s "https://wttr.in/$LOC?format=1&u")"

# Fetch full forecast for tooltip
# 0: current weather
# Q: super quiet
# T: no terminal sequences (plain text)
# u: USCS
tooltip="$(curl -s "https://wttr.in/$LOC?0QTu" |
    sed 's/\\/\\\\/g' |
    sed ':a;N;$!ba;s/\n/\\n/g' |
    sed 's/"/\\"/g')"

if [[ -n "$text" ]] && ! grep -q "Unknown location" <<< "$text"; then
    echo "{\"text\": \"$text\", \"tooltip\": \"<tt>$tooltip</tt>\", \"class\": \"weather\"}"
fi