#!/bin/bash

xcodebuild test  -workspace HighPerformance.xcworkspace -scheme HighPerformance -destination "platform=iOS Simulator,name=iPhone 5s,OS=8.2"
