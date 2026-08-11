#!/usr/bin/env python3
"""Print the UDID of the first available iPhone simulator, if any."""
import json
import sys

data = json.load(sys.stdin)
for runtime, devices in data.get("devices", {}).items():
    if "iOS" not in runtime:
        continue
    for device in devices:
        if device.get("isAvailable") and "iPhone" in device.get("name", ""):
            print(device["udid"])
            raise SystemExit(0)
raise SystemExit(1)
