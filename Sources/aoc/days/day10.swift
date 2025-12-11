enum Day10CacheEntry {
	case Result(Int)
	case Empty
}

typealias LightSet = [Bool]
typealias ButtonSet = [Int]
typealias Cache = [String: Day10CacheEntry]

@Sendable
func day10(input: String) {
	let lines = input.split(separator: "\n")

	var sum = 0

	for line in lines {
		let reLightSet = /\[([\.#]+)\]/
		let reButtonSets = /\(([0-9,]+)\)/

		let targetLightSet: LightSet = line.firstMatch(of: reLightSet)!.1.map({ $0 == "." ? false : true })
		let startingLightSet = targetLightSet.map({ light in
			false
		})
		let buttonSets = line.matches(of: reButtonSets).map{ match in
			String(match.1).split(separator: ",").map{ num in
				Int(num)!
			}
		}

		var lowest: Int? = nil
		var cache: Cache = [:]
		for set in buttonSets {
			let res = tryButtonSet(
				targetLightSet: targetLightSet,
				currentLightSet: startingLightSet,
				buttonSetToTry: set,
				buttonSets: buttonSets,
				cache: &cache,
				level: 0,
			)
			switch res {
				case .Empty:
					continue
				case .Result(var val):
					val += 1
					if lowest == nil || val < lowest! {
						lowest = val
					}
			}
		}

		// print("\n\nLOWEST:", lowest!, "\n\n\n\n")

		sum += lowest!
	}

	print("sum: \(sum)")
}

func tryButtonSet(
	targetLightSet: LightSet,
	currentLightSet: LightSet,
	buttonSetToTry: ButtonSet,
	buttonSets: [ButtonSet],
	cache: inout Cache,
	level: Int, // for debugging
) -> Day10CacheEntry {
	// print("\(getSpacesForLevel(level: level))from:", getStringFromLightSet(lightSet: currentLightSet))
	// print("\(getSpacesForLevel(level: level))applying:", buttonSetToTry)
	let newLightSet = applyButtonSet(originalLightSet: currentLightSet, buttonSet: buttonSetToTry)
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

		let res = tryButtonSet(
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

func applyButtonSet(originalLightSet: LightSet, buttonSet: ButtonSet) -> LightSet {
	var newLightSet: LightSet = []
	for (index, l) in originalLightSet.enumerated() {
		newLightSet.append(buttonSet.contains(index) ? !l : l)
	}
	return newLightSet
}

func getStringFromLightSet(lightSet: LightSet) -> String {
	return String(lightSet.map({ $0 ? "#" : "." }))
}

func getSpacesForLevel(level: Int) -> String {
	return String(repeating: " ", count: level)
}
