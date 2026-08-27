#!/bin/bash
set -euo pipefail

app_path="dist/Night Owl.app"
mkdir -p "$app_path/Contents/MacOS"
swiftc -framework Cocoa macos/NightOwl.swift -o "$app_path/Contents/MacOS/Night Owl"
cp macos/Info.plist "$app_path/Contents/Info.plist"
echo "Built $app_path"
