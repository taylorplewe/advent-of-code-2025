enum Cell {
	case Empty
	case Paper
}

let offsetsToCheck: [(Int, Int)] = [
	(-1, -1),
	(0, -1),
	(1, -1),
	(-1, 0),
	(1, 0),
	(-1, 1),
	(0, 1),
	(1, 1),
]

@Sendable
func day4(input: String) {
	// create board
	var board: [[Cell]] = []
	let lines = input.split(separator: "\n")
	for line in lines {
		var row: [Cell] = []
		for c in line {
			row.append(c == "@" ? .Paper : .Empty)
		}
		board.append(row)
	}

	var exes = 0
	var lastAmtRemoved = 1
	while lastAmtRemoved > 0 {
		lastAmtRemoved = 0
		for row in 0..<board.count {
			for col in 0..<board.first!.count {
				if checkCell(board: &board, exes: &exes, x: col, y: row) {
					lastAmtRemoved += 1
				}
			}
		}
	}

	print("exes:", exes)
}

func checkCell(board: inout [[Cell]], exes: inout Int, x: Int, y: Int) -> Bool {
	if board[y][x] == .Empty { return false }

	var numSurroundingPapers = 0

	let width = board.first!.count
	let height = board.count

	for (xOffs, yOffs) in offsetsToCheck {
		let xToCheck = x + xOffs
		let yToCheck = y + yOffs
		if xToCheck < 0 || xToCheck >= width {
			continue
		}
		if yToCheck < 0 || yToCheck >= height {
			continue
		}
		numSurroundingPapers += board[yToCheck][xToCheck] == .Paper ? 1 : 0
		if numSurroundingPapers == 4 { return false }
	}

	board[y][x] = .Empty
	exes += 1

	for (xOffs, yOffs) in offsetsToCheck {
		let xToCheck = x + xOffs
		let yToCheck = y + yOffs
		if xToCheck < 0 || xToCheck >= width {
			continue
		}
		if yToCheck < 0 || yToCheck >= height {
			continue
		}
		_ = checkCell(board: &board, exes: &exes, x: xToCheck, y: yToCheck)
	}

	return true
}
