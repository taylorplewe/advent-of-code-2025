struct CacheEntry {
	var row: Int
	var col: Int
	var val: Int
}

@MainActor
var cache: [CacheEntry] = []

@Sendable
func day7(input: String) {
	let lines = input.split(separator: "\n")

	let firstLine = lines[0]
	let firstLineBytes: [UInt8] = getByteArrayFromString(str: firstLine)
	let startingInd: Int = firstLineBytes.firstIndex(of: UInt8(ascii: "S"))!

	let linesBytes = lines[1...].map(getByteArrayFromString)

	var cache: [CacheEntry] = []
	let totalPart2 = navigateOnSplitter(
		cache: &cache,
		lineInd: 1,
		lines: linesBytes[0...],
		beamCol: startingInd,
	) + 1
	print("total from part 2:", totalPart2)
	
	var numSplits = 0
	var beamCols: [Int] = [startingInd]
	for line in linesBytes {
		var newBeamCols: [Int] = []
		for beamCol in beamCols {
			assert(beamCol >= 0)
			assert(beamCol < line.count)
			if line[beamCol] == UInt8(ascii: "^") {
				numSplits += 1
				// print(" split!", beamCol)
				if !newBeamCols.contains(beamCol - 1) {
					newBeamCols.append(beamCol - 1)
				}
				if !newBeamCols.contains(beamCol + 1) {
					newBeamCols.append(beamCol + 1)
				}
			} else {
				if !newBeamCols.contains(beamCol) {
					newBeamCols.append(beamCol)
				}
			}
		}
		beamCols = newBeamCols

		// for i in 0..<line.count {
		// 	if beamCols.contains(i) {
		// 		print("|", separator: "", terminator: "")
		// 	} else {
		// 		print(line[i] == UInt8(ascii: "^") ? "^" : ".", separator: "", terminator: "")
		// 	}
		// }
		// print()
	}

	print("num splits:", numSplits)
}

func navigateOnSplitter(cache: inout [CacheEntry], lineInd: Int, lines: ArraySlice<[UInt8]>, beamCol: Int) -> Int {
	// print("splitting on:", beamCol)
	// print("lineInd:", lineInd)
	// print("lines.count", lines.count)
	var sum = 0
	lineLoop: for (offsetLineInd, line) in lines.enumerated() {
		// print(" line:", line)
		if line[beamCol] == UInt8(ascii: "^") {
			sum = 1
			for newBeamCol in [beamCol - 1, beamCol + 1] {
				if let memoizedVal = getCacheEntry(
					cache: cache,
					row: lineInd + offsetLineInd,
					col: newBeamCol,
				) {
					sum += memoizedVal
				} else {
					let val = navigateOnSplitter(
						cache: &cache,
						lineInd: lineInd + offsetLineInd,
						lines: lines[(lineInd + offsetLineInd)...],
						beamCol: newBeamCol,
					)
					sum += val
				 addCacheEntry(
				 	cache: &cache,
				 	row: lineInd + offsetLineInd,
				 	col: newBeamCol,
				 	val: val,
				 )
				}
			}
			break lineLoop
		}
	}
	return sum
}

func addCacheEntry(cache: inout [CacheEntry], row: Int, col: Int, val: Int) {
	if getCacheEntry(cache: cache, row: row, col: col) == nil {
		cache.append(.init(row: row, col: col, val: val))
	}
}

func getCacheEntry(cache: [CacheEntry], row: Int, col: Int) -> Int? {
	for entry in cache {
		if entry.row == row && entry.col == col {
			return entry.val
		}
	}
	return nil
}
