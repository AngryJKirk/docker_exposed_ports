#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Initialize output variables and max length
exposed_output=""
not_exposed_output=""
max_length=0
color_blind_mode=0
sort_field_exposed=3
sort_field_not_exposed=3

# Check for color-blind mode flag
if [[ "$1" == "--i-am-colorblind" ]]; then
  color_blind_mode=1
  sort_field_exposed=4
  sort_field_not_exposed=5
fi

# Get Docker container info
docker_output=$(docker ps --format '{{.Names}}\t{{.Ports}}')

# First pass to find the longest container name
while read -r line; do
  container=$(echo -e "$line" | awk '{print $1}')
  length=${#container}
  if (( length > max_length )); then
    max_length=$length
  fi
done <<< "$docker_output"

# Second pass to generate the output
while read -r line; do
  container=$(echo -e "$line" | awk '{print $1}')
  ports=$(echo -e "$line" | cut -f2-)

  # Skip containers with no ports or no mappings
  if [ -z "$ports" ] || [[ "$ports" == *"<->"* ]] || [[ ! "$ports" == *'->'* ]]; then
    continue
  fi

  # Remove IP prefixes and trailing comma
  ports=$(echo "$ports" | sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}://g' | sed 's/,$//')

  # Align output
  padding=$(printf "%*s" $((max_length - ${#container})) "")

  # Check if ports are exposed
  if [[ "$line" == *"0.0.0.0:"* ]] || [[ "$line" == *":::"* ]]; then
    if (( color_blind_mode )); then
      exposed_output+="Exposed: ${container}${padding} : ${ports}\n"
    else
      exposed_output+="${RED}${container}${padding} : ${ports}${NC}\n"
    fi
  else
    if (( color_blind_mode )); then
      not_exposed_output+="Not Exposed: ${container}${padding} : ${ports}\n"
    else
      not_exposed_output+="${GREEN}${container}${padding} : ${ports}${NC}\n"
    fi
  fi
done <<< "$docker_output"

# Sort and print output
echo -e "$exposed_output" | sort -n -k $sort_field_exposed
echo -e "$not_exposed_output" | sort -n -k $sort_field_not_exposed
