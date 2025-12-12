enum Day10CacheEntry {
	case Result(Int)
	case Empty
}

typealias LightSet = [Bool]
typealias ButtonSet = [Int]
typealias VoltageSet = [Int]
typealias Cache = [String: Day10CacheEntry]

@Sendable
func day10(input: String) {
	let lines = input.split(separator: "\n")

	var sum: UInt64 = 0

	for line in lines {
		let reLightSet = /\[([\.#]+)\]/
		let reButtonSets = /\(([0-9,]+)\)/
		let reVoltageSet = /\{([0-9,]+)\}/

		let targetLightSet: LightSet = line.firstMatch(of: reLightSet)!.1.map({ $0 == "." ? false : true })
		let startingLightSet = targetLightSet.map({ light in
			false
		})
		let buttonSets = line.matches(of: reButtonSets).map{ match in
			String(match.1).split(separator: ",").map{ num in
				Int(num)!
			}
		}
		let targetVoltageSet = line.firstMatch(of: reVoltageSet)!.1.split(separator: ",").map({ Int($0)! })
		let startingVoltageSet = targetVoltageSet.map({ voltage in
			0
		})

		// var lowest: Int? = nil
		var lowest: UInt64 = UInt64.max
		// var cache: Cache = [:]
		for set in buttonSets {
			// let res = tryButtonSetPart1(
			// 	targetLightSet: targetLightSet,
			// 	currentLightSet: startingLightSet,
			// 	buttonSetToTry: set,
			// 	buttonSets: buttonSets,
			// 	cache: &cache,
			// 	level: 0,
			// )
			var res = tryButtonSetPart2(
				targetVoltageSet: targetVoltageSet,
				currentVoltageSet: startingVoltageSet,
				buttonSetToTry: set,
				buttonSets: buttonSets,
				level: 0,
			)
			// switch res {
			// 	case .Empty:
			// 		continue
			// 	case .Result(var val):
			// 		val += 1
			// 		if lowest == nil || val < lowest! {
			// 			lowest = val
			// 		}
			// }
			res += 1
			if res < lowest {
				lowest = res
			}
		}

		// print("\n\nLOWEST:", lowest!, "\n\n\n\n")

		// if lowest == nil {
		// 	print("ERROR: lowest was nil on line: \(line)!")
		// } else {
		// 	print("lowest for line: \(line)\n \(lowest!)")
		// 	sum += lowest!
		// }
		print("lowest for line: \(line)\n \(lowest)")
		sum += lowest
	}

	print("sum: \(sum)")
}

func tryButtonSetPart1(
	targetLightSet: LightSet,
	currentLightSet: LightSet,
	buttonSetToTry: ButtonSet,
	buttonSets: [ButtonSet],
	cache: inout Cache,
	level: Int, // for debugging
) -> Day10CacheEntry {
	// print("\(getSpacesForLevel(level: level))from:", getStringFromLightSet(lightSet: currentLightSet))
	// print("\(getSpacesForLevel(level: level))applying:", buttonSetToTry)
	let newLightSet = applyButtonSetPart1(originalLightSet: currentLightSet, buttonSet: buttonSetToTry)
	let newLightSetString = getStringFromLightSet(lightSet: newLightSet)

	// base case
	if newLightSet == targetLightSet {
		// print("\(getSpacesForLevel(level: level))FOUND!!!!!")
		return .Result(0)
	}

	if cache[newLightSetString] != nil {
		// print("\(getSpacesForLevel(level: level))value was already in cache: \(cache[newLightSetString])")
		switch cache[newLightSetString]! {
			case .Empty:
				return .Empty
			case .Result(let val):
				return .Result(val)
		}
	}

	// indicate we are still searching for the result form this point.
	// if it remains nil, it means it ends in an endless loop.
	cache[newLightSetString] = .Empty

	var lowest: Day10CacheEntry = .Empty
	for set in buttonSets {
		if set == buttonSetToTry {
			continue
		}

		let res = tryButtonSetPart1(
			targetLightSet: targetLightSet,
			currentLightSet: newLightSet,
			buttonSetToTry: set,
			buttonSets: buttonSets,
			cache: &cache,
			level: level + 1,
		)
		switch res {
			case .Empty:
				continue
			case .Result(var val):
				val += 1
				// print("\(getSpacesForLevel(level: level))got back:", val)
				switch lowest {
					case .Empty:
						lowest = .Result(val)
					case .Result(let lowestVal):
						if val < lowestVal {
							lowest = .Result(val)
						}
				}
		}
	}
	
	// print("\(getSpacesForLevel(level: level))returning: \(lowest)")
	cache[newLightSetString] = lowest
	return lowest
}

func tryButtonSetPart2(
	targetVoltageSet: VoltageSet,
	currentVoltageSet: VoltageSet,
	buttonSetToTry: ButtonSet,
	buttonSets: [ButtonSet],
	level: Int, // for debugging
) -> UInt64 {
	// if level > 20 {
	// 	return .Empty
	// }
	// print("\(getSpacesForLevel(level: level))from:", getStringFromVoltageSet(voltageSet: currentVoltageSet))
	// print("\(getSpacesForLevel(level: level))applying:", buttonSetToTry)
	let newVoltageSet = applyButtonSetPart2(originalVoltageSet: currentVoltageSet, buttonSet: buttonSetToTry)

	// base case
	if newVoltageSet == targetVoltageSet {
		// print("\(getSpacesForLevel(level: level))FOUND!!!!!")
		return 0
	}

	// too high?
	for (index, num) in newVoltageSet.enumerated() {
		if num > targetVoltageSet[index] {
			return UInt64.max
		}
	}

	var lowest: UInt64 = UInt64.max
	for set in buttonSets {
		var res = tryButtonSetPart2(
			targetVoltageSet: targetVoltageSet,
			currentVoltageSet: newVoltageSet,
			buttonSetToTry: set,
			buttonSets: buttonSets,
			level: level + 1,
		)
		switch res {
			case UInt64.max:
				continue
			default:
				res += 1
				if res < lowest {
					lowest = res
				}
		}
	}
	
	// print("\(getSpacesForLevel(level: level))returning: \(lowest)")
	return lowest
}

func applyButtonSetPart1(originalLightSet: LightSet, buttonSet: ButtonSet) -> LightSet {
	var newLightSet: LightSet = []
	for (index, l) in originalLightSet.enumerated() {
		newLightSet.append(buttonSet.contains(index) ? !l : l)
	}
	return newLightSet
}

func applyButtonSetPart2(originalVoltageSet: VoltageSet, buttonSet: ButtonSet) -> VoltageSet {
	var newVoltageSet: VoltageSet = []
	for (index, l) in originalVoltageSet.enumerated() {
		newVoltageSet.append(buttonSet.contains(index) ? l + 1 : l)
	}
	return newVoltageSet
}

func getStringFromLightSet(lightSet: LightSet) -> String {
	return String(lightSet.map({ $0 ? "#" : "." }))
}

func getStringFromVoltageSet(voltageSet: VoltageSet) -> String {
	return voltageSet.map({ String($0) }).joined(separator: ",")
}

func getSpacesForLevel(level: Int) -> String {
	return String(repeating: " ", count: level)
}
