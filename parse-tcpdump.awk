# extrace dBM
match($0, /-?[0-9]+dBm/, strength) {
	STRENGTH=strength[0]
}

# extract sender MAC address
match($0, /SA(:[a-f0-9]{2}){6}/, mac) {
	gsub(/SA:/, "", mac[0])
	MAC=mac[0]
	TIMESTAMP=$1" "$2  # get date and time
	print TIMESTAMP " " STRENGTH " " MAC
	system("")  # flush the buffer
}
