# Docker Exposed Port Checker 🛡️

## Overview

This Bash script helps you quickly identify which Docker container ports are exposed and which are internal. It's a handy tool for self-checking, especially when you're running multiple containers. The aim is to boost your security by ensuring you're not unintentionally exposing more than you should.

## How to Use 🚀

1. Download the script.
2. Run the script: `./docker_ports.sh`.


## Output 📊

- Ports that are exposed to the internet will be displayed in **red**.
- Ports that are internal-only will appear in **green**.

## Why You Need This 🤔

Managing Docker containers can get complex, and it's easy to accidentally expose a port you didn't intend to. This script offers a quick and easy way to review your port exposure, helping you identify any potential security risks.

## Disclaimer

Yeah, it's just a fancy output of `docker ps --format '{{.Names}}\t{{.Ports}}'`

Stay secure! 🛡️
