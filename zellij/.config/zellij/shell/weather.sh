#!/bin/sh

# Get current location (latitude and longitude)
loc=$(curl -s ipinfo.io | jq -r '.loc')
lat=$(echo "$loc" | cut -d',' -f1)
long=$(echo "$loc" | cut -d',' -f2)

# Fetch current weather in Fahrenheit
weather=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current=temperature,weathercode&temperature_unit=fahrenheit")

# Extract temperature and weather code
tem=$(echo "$weather" | jq '.current.temperature')
wea=$(echo "$weather" | jq '.current.weathercode')

# Define weather code groups
clear=("0" "1")
cloudy=("2" "3")
fog=("45" "48")
drizzle=("51" "53" "55" "56" "57")
rain=("61" "63" "65" "66" "67")
snow=("71" "73" "75" "77" "85" "86")
showers=("80" "81" "82")
thunderstorm=("95" "96" "99")

# Match weather code to emoji
if [[ ${clear[@]} =~ $wea ]]; then
  curwea=
elif [[ ${cloudy[@]} =~ $wea ]]; then
  curwea=
elif [[ ${fog[@]} =~ $wea ]]; then
  curwea=
elif [[ ${drizzle[@]} =~ $wea ]]; then
  curwea=
elif [[ ${rain[@]} =~ $wea ]]; then
  curwea=
elif [[ ${snow[@]} =~ $wea ]]; then
  curwea=󰼶
elif [[ ${showers[@]} =~ $wea ]]; then
  curwea=
elif [[ ${thunderstorm[@]} =~ $wea ]]; then
  curwea=
else
  curwea=❓
fi

# Output: icon and temperature (Fahrenheit, plain number)
echo "$curwea $tem"
