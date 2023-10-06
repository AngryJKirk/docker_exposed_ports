#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Initialize output variables and max length
exposed_output=""
not_exposed_output=""
max_length=0

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
  ports=$(echo "$ports" | sed 's/0.0.0.0://g' | sed 's/127.0.0.1://g')

  ports=$(echo "$ports" | sed 's/,$//')

  # Align output
  padding=$(printf "%*s" $((max_length - ${#container})) "")

  # Check if ports are exposed
  if [[ "$line" == *"0.0.0.0:"* ]] || [[ "$line" == *":::"* ]]; then
    exposed_output+="${RED}${container}${padding}   ${ports}${NC}\n"
  else
    not_exposed_output+="${GREEN}${container}${padding}   ${ports}${NC}\n"
  fi
done <<< "$docker_output"

# Sort and print output
echo -e "$exposed_output"
echo -e "$not_exposed_output"
