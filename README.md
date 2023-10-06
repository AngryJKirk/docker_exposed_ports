# Docker Exposed Port Checker 🛡️

## Overview

This Bash script is designed to help you identify which Docker container ports are exposed to the internet. It's a useful tool for self-auditing, especially if you're managing multiple containers. The goal is to enhance your security posture by making sure you're not accidentally exposing more than you intend to.

## How to Use 🚀

1. Download the script.
2. Make it executable with `chmod +x script.sh`.
3. Run the script, passing your external IP as an argument: `./script.sh 1.2.3.4`.

## Output 📊

- Ports that are exposed to the internet will be displayed in **red**.
- Ports that are not exposed will appear in **green**.

## Why You Need This 🤔

Managing Docker containers often involves juggling various port mappings. It's easy to inadvertently expose a port that should remain internal. This script provides a quick way to review your current exposure, helping you catch any potential security risks before they become actual problems.

## Disclamer

I am a lame Linux user, so this script must suck. Feel free to shoot a PR.

Stay secure! 🛡️
