#!/bin/bash

# Copyright © 2023-present, Meta Platforms, Inc. and affiliates
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

set -euo pipefail

OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
ASSETS=$(curl -s "https://api.github.com/repos/marc-israel/DriftDetect/releases/latest" | awk -F '"' '/browser_download_url/{print $4}')

if [[ "$ARCH" == "x86_64" ]]; then ARCH="amd64"; fi
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then ARCH="arm64"; fi

for ASSET in $ASSETS
do
    if [[ $ASSET == *"$OS"* && $ASSET == *"$ARCH"* ]]; then
        curl -sLo "/tmp/$(basename "$ASSET")" "$ASSET"
        echo "Download of DriftDetect latest release from GitHub is complete."
        mkdir -p "$HOME/.local/bin"
        tar xf "/tmp/$(basename "$ASSET")" driftdetect
        cp driftdetect "$HOME/.local/bin/driftdetect"
        rm "/tmp/$(basename "$ASSET")"
        echo "Copied driftdetect to $HOME/.local/bin/ as driftdetect"
        exit
    fi
done
