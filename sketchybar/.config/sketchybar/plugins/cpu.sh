#!/bin/bash

CPU_PERCENT=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')

sketchybar --set "$NAME" label="${CPU_PERCENT}%"