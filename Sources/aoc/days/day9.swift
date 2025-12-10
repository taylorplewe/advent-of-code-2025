struct Tile {
	var x: Int
	var y: Int
}

@Sendable
func day9(input: String) {
	var tiles: [Tile] = []

	let lines = input.split(separator: "\n")
	for line in lines {
		let ints = line.split(separator: ",").map({ Int($0)! })
		tiles.append(.init(x: ints[0], y: ints[1]))
	}

	day9Part2(tiles: tiles)

	var largestArea = 0
	for i in 0..<tiles.count {
		for j in (i + 1)..<tiles.count {
			let area = (abs(tiles[i].x - tiles[j].x) + 1) * (abs(tiles[i].y - tiles[j].y) + 1)
			if area > largestArea {
				largestArea = area
			}
		}
	}
	print("largest area: \(largestArea)")
}

struct Area {
	var value: Int
	var tile1: Tile
	var tile2: Tile
}

func day9Part2(tiles: [Tile]) {
	// create board
	let sortedXDesc = tiles.sorted(by: { $0.x > $1.x })
	let sortedYDesc = tiles.sorted(by: { $0.y > $1.y })
	let maxX = sortedXDesc[0].x + 2
	let maxY = sortedYDesc[0].y + 2
	let minX = sortedXDesc.last!.x
	let minY = sortedYDesc.last!.y
	var board: [[Bool]] = .init(repeating: .init(repeating: false, count: maxX), count: maxY)

	print(board.count)
	print(board[0].count)

	// draw edges
	for i in 0..<tiles.count {
		let tile = tiles[i]
		let otherTile = i < tiles.count - 1 ? tiles[i + 1] : tiles[0]
		drawEdge(board: &board, tile1: tile, tile2: otherTile)
	}

	fillShape(board: &board, minX: minX, minY: minY)

	// printBaord(board: board)

	// calculate areas
	var areas: [Area] = []
	for i in 0..<tiles.count {
		for j in (i + 1)..<tiles.count {
			let area = (abs(tiles[i].x - tiles[j].x) + 1) * (abs(tiles[i].y - tiles[j].y) + 1)
			areas.append(.init(value: area, tile1: tiles[i], tile2: tiles[j]))
		}
	}
	areas.sort(by: { $0.value > $1.value })

	// find largest area that has a complete filled-in perimeter
	for area in areas {
		if !isPerimeterFilledIn(board: board, tile1: area.tile1, tile2: area.tile2) {
			continue
		}
		print("tile1: \(area.tile1.x),\(area.tile1.y)")
		print("tile2: \(area.tile2.x),\(area.tile2.y)")
		print("largest part 2: \(area.value)")
		break
	}
}

func drawEdge(board: inout [[Bool]], tile1: Tile, tile2: Tile) {
	if tile1.x == tile2.x {
		for row in min(tile1.y, tile2.y)...max(tile1.y, tile2.y) {
			board[row][tile1.x] = true
		}
	} else {
		for col in min(tile1.x, tile2.x)...max(tile1.x, tile2.x) {
			board[tile1.y][col] = true
		}
	}
}

func fillShape(board: inout [[Bool]], minX: Int, minY: Int) {
	enum OnDirection {
		case Above
		case Middle
		case Below
		case Off
	}
	rowLoop: for row in minY..<board.count {
		var onDir: OnDirection = .Off
		colLoop: for col in minX..<board[0].count {
			if !board[row][col] {
				switch onDir {
					case .Off:
						continue colLoop
					default:
						board[row][col] = true
						continue colLoop
				}
			} else {
				if col == board[0].count - 1 {
					continue rowLoop
				}
				switch onDir {
					case .Off:
						if board[row][col + 1] {
							if board[row - 1][col] {
								onDir = .Above
								continue colLoop
							} else {
								onDir = .Below
								continue colLoop
							}
						} else {
							onDir = .Middle
							continue colLoop
						}
					case .Above:
						if !board[row][col + 1] {
							if board[row + 1][col] {
								onDir = .Middle
								continue colLoop
							} else {
								onDir = .Off
								continue colLoop
							}
						}
					case .Below:
						if !board[row][col + 1] {
							if board[row + 1][col] {
								onDir = .Off
								continue colLoop
							} else {
								onDir = .Middle
								continue colLoop
							}
						}
					case .Middle:
						if board[row][col + 1] {
							if board[row + 1][col] {
								onDir = .Above
								continue colLoop
							} else {
								onDir = .Below
								continue colLoop
							}
						} else {
							onDir = .Off
							continue colLoop
						}
				}
			}
		}
	}
}

func isPerimeterFilledIn(board: [[Bool]], tile1: Tile, tile2: Tile) -> Bool {
	for x in min(tile1.x, tile2.x)...max(tile1.x, tile2.x) {
		if !board[tile1.y][x] || !board[tile2.y][x] { return false }
	}
	for y in min(tile1.y, tile2.y)...max(tile1.y, tile2.y) {
		if !board[y][tile1.x] || !board[y][tile2.x] { return false }
	}
	return true
}

func printBaord(board: [[Bool]]) {
	for row in board {
		for col in row {
			print(col ? "X" : ".", separator: "", terminator: "")
		}
		print()
	}
}
