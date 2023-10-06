#!/bin/bash

# Get external IP from input
external_ip=$1

# Validate IP
if [[ -z "$external_ip" ]]; then
  echo "Usage: $0 <external_ip>"
  exit 1
fi

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Initialize output variables
exposed_output=""
not_exposed_output=""

# Loop through Docker containers
for container in $(docker ps --format '{{.Names}}'); do
  # Get port mappings
  mappings=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{$p}} -> {{(index $conf 0).HostPort}}{{"\n"}}{{end}}{{end}}' $container)

  # Check each mapping
  while read -r mapping; do
    if [ -z "$mapping" ]; then continue; fi

    internal=$(echo $mapping | cut -d/ -f1)
    external=$(echo $mapping | awk -F' -> ' '{print $2}')

    # Check port
    if nc -z -w2 $external_ip $external 2>/dev/null; then
      exposed_output+="${RED}$container: $internal -> $external${NC}\n"
    else
      not_exposed_output+="${GREEN}$container: $internal -> $external${NC}\n"
    fi
  done <<< "$mappings"
done

# Sort and print output
echo -e "$exposed_output"
echo -e "$not_exposed_output"
