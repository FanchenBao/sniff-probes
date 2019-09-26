#!/bin/bash

# channel hop every 0.5 seconds
channel_hop() {
    IEEE80211bg="1 2 3 4 5 6 7 8 9 10 11"
    IEEE80211bg_intl="$IEEE80211b 12 13 14"
    IEEE80211a="36 40 44 48 52 56 60 64 149 153 157 161"
    IEEE80211bga="$IEEE80211bg $IEEE80211a"
    IEEE80211bga_intl="$IEEE80211bg_intl $IEEE80211a"

    while true ; do
        for CHAN in $IEEE80211bg ; do
            echo $CHAN
            # echo "switching $IFACE to channel $CHAN"
            sudo iwconfig $IFACE channel $CHAN
            sleep 0.5
        done
    done
}

main() {
    if ! [ -x "$(command -v gawk)" ]; then
      echo 'gawk (GNU awk) is not installed. Please install gawk.' >&2
      exit 1
    fi

    if [[ $IFACE == "" ]]; then
        echo "WiFi interface env variable must be set in [-i wifi_interface]. Type \"ifconfig\" to view network interaces."
        exit 1
    fi

    if [[ $CHANNEL_HOP == "true" ]]; then
        # channel hop in the background
        channel_hop &
    fi

    # filter with awk, output timestamp, MAC, and signal strength
    sudo tcpdump -tttt -l -I -i "$IFACE" -e -s 256 type mgt subtype probe-req | awk -f parse-tcpdump.awk | tee -a "$OUTPUT" 
}

# DEFAULTS
CHANNEL_HOP="false"
OUTPUT="probes.txt"
IFACE=""

print_usage() {
    printf "Usage: sniff-probes.sh [--channel_hop] [-i wifi_interface] [-o output_file]\n"
    printf "--channel_hop\tEnable channel hop while monitoring\n"
    printf "-i\t\tWiFi device interface in monitor moden\n"
    printf "-o\t\tOutput file name"
}

# Parse options and flags
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --channel_hop)  # enable channel hop
      CHANNEL_HOP="true"
      shift 1
      ;;
    -i)  # wifi device interface that is in monitor mode
      if [[ "$2" != "" ]]; then
        IFACE="$2"
        shift 1
      else # -i must be followed by a second argument
        print_usage
        exit 1
      fi
      shift 1
      ;;
    -o)  # output file name
      if [[ "$2" != "" ]]; then
        OUTPUT="$2"
        shift 1
      else # -o must be followed by a second argument
        print_usage
        exit 1
      fi
      shift 1
      ;;
    *) # unsupported flags
      print_usage
      exit 1
      ;;
  esac
done

main