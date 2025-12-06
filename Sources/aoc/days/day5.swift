struct Range {
	var lower: UInt64
	var upper: UInt64
}

@Sendable
func day5(input: String) {
	let lines = input.split(separator: "\n")

	var ranges: [Range] = []
	var numValidIDs = 0
	for line in lines {
		if line.contains("-") {
			let rangeStr = line.split(separator: "-")
			let range: Range = .init(lower: UInt64(rangeStr[0])!, upper: UInt64(rangeStr[1])!)
			ranges.append(range)
		} else {
			let id = UInt64(line)!
			numValidIDs += checkID(id: id, ranges: ranges) ? 1 : 0
		}
	}

	print("num valid IDs: \(numValidIDs)")

	// part 2
	consolidateRanges(ranges: &ranges)
	let sum = countAllValidIds(ranges: ranges)
	print(sum)
}

func checkID(id: UInt64, ranges: [Range]) -> Bool {
	for range in ranges {
		if id >= range.lower && id <= range.upper {
			return true
		}
	}
	return false
}

/// Leave only unique ranges, combining and deleting when necessary
func consolidateRanges(ranges: inout [Range]) {
	// sort ranges by lower
	ranges.sort(by: {$0.lower < $1.lower})

	var i = 0
	rangeLoop: while i < ranges.count {
		if i > 0 {
			if ranges[i].lower <= ranges[i-1].upper {
				if ranges[i].upper > ranges[i-1].upper {
					ranges[i-1].upper = ranges[i].upper
				}
				ranges.remove(at: i)
				continue rangeLoop
			}
		}
		i += 1
	}
}

func countAllValidIds(ranges: [Range]) -> UInt64 {
	var sum: UInt64 = 0

	for range in ranges {
		sum += (range.upper - range.lower) + 1
	}

	return sum
}
