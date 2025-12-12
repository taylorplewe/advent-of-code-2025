typealias DeviceList = [String: [String]]
typealias Day11Cache = [String: (Int, Bool, Bool)?]

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
		hasHitFft: false,
		hasHitDac: false,
		cache: &cache,
		level: 0,
	)

	print("num paths: \(numPaths)")
	for entry in cache {
		print("\(entry.key): \(entry.value!)")
	}
}

func getNumPathsToOutFromDevice(
	deviceList: DeviceList,
	device: String,
	hasHitFft: Bool,
	hasHitDac: Bool,
	cache: inout Day11Cache,
	level: Int,
) -> (Int, Bool, Bool) {
	assert(deviceList.keys.contains(device))

	let connectedDevices = deviceList[device]!

	if hasHitFft && hasHitDac {
		cache[device] = nil
	}
	var numPathsFromHere = 0
	var hitDacFromHereDown = device == "dac"
	var hitFftFromHereDown = device == "fft"
	for cd in connectedDevices {
		if cd == "out" {
			numPathsFromHere += 1
		} else if cache.keys.contains(cd) {
			if cache[cd]! != nil {
				if (cache[cd]!!.1 || hasHitDac) && (cache[cd]!!.2 || hasHitFft) {
					numPathsFromHere += cache[cd]!!.0
				}
			}
		} else {
			let res = getNumPathsToOutFromDevice(
				deviceList: deviceList,
				device: cd,
				hasHitFft: hasHitFft || hitFftFromHereDown,
				hasHitDac: hasHitDac || hitDacFromHereDown,
				cache: &cache,
				level: level + 1,
			)
			numPathsFromHere += res.0
			if res.1 { hitDacFromHereDown = true }
			if res.2 { hitFftFromHereDown = true }
		}
	}
	cache[device] = (numPathsFromHere, hitDacFromHereDown, hitFftFromHereDown)
	return (numPathsFromHere, hitDacFromHereDown, hitFftFromHereDown)
}
