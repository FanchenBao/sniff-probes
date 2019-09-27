# Sniff Probes

Plug-and-play bash script for sniffing 802.11 probes requests. This is a fork of the original [`sniff-probes`](https://github.com/brannondorsey/sniff-probes), with major changes to the source code.

## What are Probe Requests?

Probe requests are an 802.11 WIFI packet type that function to automatically connect network devices to the wireless access points (APs) that they have previously associated with. Whenever a phone, computer, or other networked device has Wi-Fi enabled, but is not connected to a network, it is constantly "probing"; openly broadcating the network names (SSIDs) of previously connected APs. Because wireless access points have unique and often personal network names, it is easy to identify the device owner by recognizing the names of networks they frequently connect to.

For a creative application of probe request capture, see [ProbeKit](https://github.com/brannondorsey/ProbeKit). 

## Sniffing Probe Requests

```
$ ./sniff-probes.sh -i wlan1
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan1, link-type IEEE802_11_RADIO (802.11 plus radiotap header), capture size 256 bytes
2019-09-27 13:28:25.190555 59623239888750464us tsft 1.0 Mb/s 2427 MHz 11b -60dBm signal -60dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:cc:c0:79:4a:a4:f4 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:28:25.210787 59623239888770681us tsft 1.0 Mb/s 2427 MHz 11b -59dBm signal -59dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:cc:c0:79:4a:a4:f4 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:28:25.235660 59623239888795565us tsft 1.0 Mb/s 2427 MHz 11b -63dBm signal -63dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:cc:c0:79:4a:a4:f4 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:28:25.255916 59623239888815808us tsft 1.0 Mb/s 2427 MHz 11b -62dBm signal -62dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:cc:c0:79:4a:a4:f4 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:28:29.241325 59623239892801812us tsft 1.0 Mb/s 2427 MHz 11b -58dBm signal -58dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:0c:cb:85:ae:95:b5 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:28:29.251439 59623239892811915us tsft 1.0 Mb/s 2427 MHz 11b -59dBm signal -59dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:0c:cb:85:ae:95:b5 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
```
## Dependecies
* tcpdump
* Your wireless device must also support monitor mode. Here is [a list of WiFi cards that support monitor mode](https://www.wirelesshack.org/best-kali-linux-compatible-usb-adapter-dongles-2016.html) (2018). For WiFi adaptors supporting monitor mode and also compatible with Raspberry Pi, check this [purchase guide](https://null-byte.wonderhowto.com/how-to/buy-best-wireless-network-adapter-for-wi-fi-hacking-2019-0178550/) and this [field test report](https://null-byte.wonderhowto.com/how-to/select-field-tested-kali-linux-compatible-wireless-adapter-0180076/).

## Command line options:
```
Usage: sniff-probes.sh [--channel_hop] [-i wifi_interface] [-o output_file] [-d channel_duration]
--channel_hop	Enable channel hop while monitoring. Default: false
-i		WiFi device interface in monitor mode. Required.
-o		Output file name. Default: no file output
-d		Time to spend on each channel in channel hop, in seconds. Default: 0.5
```
By default, channel hopping is disabled. Enabling channel hopping allows for capturing more probe request. The default channel hopping frequency is every 0.5 seconds.

By default, there is no output file.

By default, if channel hopping is enabled, the duration the device stays on each channel is 0.5 seconds.

You must identify your WiFi device interface that is currently in monitor mode. In Raspberry Pi, type `iwconfig` to list available network devices. Wireless devices generally start with a "w". Also make sure the WiFi interface is in monitor mode. For example, if `wlan1` is in monitor mode, you shall have similar output as follows

```
$ iwconfig
...

wlan1     IEEE 802.11  Mode:Monitor  Frequency:2.442 GHz  Tx-Power=20 dBm
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
```

## Output
Raw data ouput from `tcpdump` without any parsing (see the output examples above). This is to reduce dependencies on the tool (original `sniff-probes` requires `gawk`) and allow for downstream app more flexibility on which data field to grab.

When channel hopping is enabled, channel information will be output as well. In the output, all probe request info in between two numbers  are detected in the channel of the first number. For example, in the following output, no probe request is detected on channels 1 and 2, but two are detected on channel 3, one on channel 4, four on channel 5, etc.

```
$ ./sniff-probes.sh -i wlan1 --channel_hop
1
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan1, link-type IEEE802_11_RADIO (802.11 plus radiotap header), capture size 256 bytes
2
3
2019-09-27 13:43:34.151401 59623240797711194us tsft 1.0 Mb/s 2422 MHz 11b -88dBm signal -88dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:8a:50:10:5e:77:7a (oui Unknown) Probe Request (WPATubez) [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:43:34.152724 59623240797712617us tsft 1.0 Mb/s 2422 MHz 11b -89dBm signal -89dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:8a:50:10:5e:77:7a (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
4
2019-09-27 13:43:35.109438 59623240798669620us tsft 1.0 Mb/s 2427 MHz 11b -63dBm signal -63dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:68:ec:c5:64:ee:6b (oui Unknown) Probe Request () [1.0* 2.0* 5.5 11.0 6.0* 9.0* 12.0 18.0 Mbit]
5
2019-09-27 13:43:35.133183 59623240798693361us tsft 1.0 Mb/s 2427 MHz 11b -60dBm signal -60dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:68:ec:c5:64:ee:6b (oui Unknown) Probe Request () [1.0* 2.0* 5.5 11.0 6.0* 9.0* 12.0 18.0 Mbit]
2019-09-27 13:43:35.158631 59623240798718802us tsft 1.0 Mb/s 2427 MHz 11b -63dBm signal -63dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:68:ec:c5:64:ee:6b (oui Unknown) Probe Request () [1.0* 2.0* 5.5 11.0 6.0* 9.0* 12.0 18.0 Mbit]
2019-09-27 13:43:35.984260 59623240799544196us tsft 1.0 Mb/s 2432 MHz 11b -89dBm signal -89dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:40:49:0f:90:e8:1e (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:43:36.004416 59623240799564346us tsft 1.0 Mb/s 2432 MHz 11b -86dBm signal -86dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:40:49:0f:90:e8:1e (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
6
7
2019-09-27 13:43:37.015929 59623240800575837us tsft 1.0 Mb/s 2437 MHz 11b -90dBm signal -90dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:2e:32:3e:8b:39:92 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
2019-09-27 13:43:37.049168 59623240800609102us tsft 1.0 Mb/s 2437 MHz 11b -91dBm signal -91dBm signal antenna 0 BSSID:Broadcast DA:Broadcast SA:2e:32:3e:8b:39:92 (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
```
