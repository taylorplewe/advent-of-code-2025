/// Stores how many paths there are *below* this point, which go to "out", and which either contain "dac" and "fft" or don't
struct Day11CacheEntry {
	var dacYFftY: Int
	var dacYFftN: Int
	var dacNFftY: Int
	var dacNFftN: Int
}

typealias DeviceList = [String: [String]]
// typealias Day11Cache = [String: (Int, Bool, Bool)?]

// 0 - number of paths below here containing both "dac" and "fft"
// 1 - number of paths below here containing just "dac"
// 2 - number of paths below here containing both "fft"
// 3 - number of paths below here containing neither "dac" or "fft"
typealias Day11Cache = [String: Day11CacheEntry?]

@Sendable
func day11(input: String) {
	let lines = input.split(separator: "\n")

	var deviceList: DeviceList = [:]

	// parse input into data structure
	for line in lines {
		let colonSplit = line.split(separator: ":")
		let key = String(colonSplit.first!)

		let reConnectedDevices = /\b([a-z]+)\b/
		let connectedDevices = colonSplit[1].matches(of: reConnectedDevices).map({ String($0.1) })

		deviceList[key] = connectedDevices
	}

	// count how many paths lead from "you" to "out"
	var cache: Day11Cache = [:]
	let numPaths = getNumPathsToOutFromDevice(
		deviceList: deviceList,
		// device: "you",
		device: "svr",
		cache: &cache,
		level: 0,
	)

	print("num paths: \(numPaths.dacYFftY)")
	// for entry in cache {
	// 	print("\(entry.key): \(entry.value!)")
	// }
}

func getNumPathsToOutFromDevice(
	deviceList: DeviceList,
	device: String,
	cache: inout Day11Cache,
	level: Int,
) -> Day11CacheEntry {
	assert(deviceList.keys.contains(device))

	let connectedDevices = deviceList[device]!

	cache[device] = nil
	var numPathsFromHere: Day11CacheEntry = .init(
		dacYFftY: 0,
		dacYFftN: 0,
		dacNFftY: 0,
		dacNFftN: 0
	)
	let isCurrentDeviceDac = device == "dac"
	let isCurrentDeviceFft = device == "fft"
	for cd in connectedDevices {
		if cd == "out" {
			numPathsFromHere.dacYFftY += isCurrentDeviceDac && isCurrentDeviceFft ? 1 : 0
			numPathsFromHere.dacYFftN += isCurrentDeviceDac && !isCurrentDeviceFft ? 1 : 0
			numPathsFromHere.dacNFftY += !isCurrentDeviceDac && isCurrentDeviceFft ? 1 : 0
			numPathsFromHere.dacNFftN += !isCurrentDeviceDac && !isCurrentDeviceFft ? 1 : 0
		} else if cache.keys.contains(cd) {
			if cache[cd]! != nil {
				numPathsFromHere.dacYFftY += cache[cd]!!.dacYFftY
				numPathsFromHere.dacYFftN += cache[cd]!!.dacYFftN
				numPathsFromHere.dacNFftY += cache[cd]!!.dacNFftY
				numPathsFromHere.dacNFftN += cache[cd]!!.dacNFftN
			}
		} else {
			let res = getNumPathsToOutFromDevice(
				deviceList: deviceList,
				device: cd,
				cache: &cache,
				level: level + 1,
			)

			numPathsFromHere.dacYFftY += res.dacYFftY
			numPathsFromHere.dacYFftN += res.dacYFftN
			numPathsFromHere.dacNFftY += res.dacNFftY
			numPathsFromHere.dacNFftN += res.dacNFftN
		}
	}

	// now move paths over to other tracks depending on if this device is "dac" or "fft"
	if isCurrentDeviceDac {
		numPathsFromHere.dacYFftY += numPathsFromHere.dacNFftY
		numPathsFromHere.dacYFftN += numPathsFromHere.dacNFftN
		numPathsFromHere.dacNFftY = 0
		numPathsFromHere.dacNFftN = 0
	} else if isCurrentDeviceFft {
		numPathsFromHere.dacYFftY += numPathsFromHere.dacYFftN
		numPathsFromHere.dacNFftY += numPathsFromHere.dacNFftN
		numPathsFromHere.dacYFftN = 0
		numPathsFromHere.dacNFftN = 0
	}

	cache[device] = numPathsFromHere
	return numPathsFromHere
}

func getDay11CacheEntry(hasHitDac: Bool, hasHitFft: Bool) -> (Int, Int, Int, Int) {
	if hasHitDac {
		if hasHitFft {
			return (1, 0, 0, 0)
		} else {
			return (0, 1, 0, 0)
		}
	} else {
		if hasHitFft {
			return (0, 0, 1, 0)
		} else {
			return (0, 0, 0, 1)
		}
	}
}
