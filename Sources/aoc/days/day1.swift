enum Direction {
	case Left
	case Right
}

@Sendable
func day1(input: String) {
	let lines = input.split(separator: "\n")

	var pos = 50
	var zeroes = 0

	for line in lines {
		let dir: Direction = (line[line.startIndex] == "R") ? .Right : .Left
		let amt = Int(line[line.index(after: line.startIndex)...])!

		switch dir {
			case .Right: pos += amt
			case .Left: pos -= amt
		}

		if (pos == 0) {
			zeroes += 1
		}
		while (pos < 0) {
			pos += 100
			zeroes += 1
		}
		while (pos >= 100) {
			pos -= 100
			zeroes += 1
		}
	}

	print("zeroes: ", zeroes)
}