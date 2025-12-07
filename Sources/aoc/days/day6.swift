import Foundation

enum Operation {
	case Add
	case Mul
}

struct Expression {
	var nums: [Int]
	var operation: Operation?
}

@Sendable
func day6(input: String) {
	let lines = input.split(separator: "\n")

	var exprs: [Expression] = []

	for line in lines {
		let parts = line.split(separator: " ")
		if exprs.count == 0 {
			for _ in parts {
				exprs.append(.init(nums: []))
			}
		}
		for (ind, part) in parts.enumerated() {
			if Int(part) != nil {
				exprs[ind].nums.append(Int(part)!)
			} else {
				exprs[ind].operation = part == "*" ? .Mul : .Add
			}
		}
	}

	var sum = 0
	for expr in exprs {
		switch expr.operation {
			case .Add:
				sum += expr.nums.reduce(0, +)
			case .Mul:
				sum += expr.nums.reduce(1, *)
			default:
				()
		}
	}

	print("sum: \(sum)")

	part2(input: input)
}

func part2(input: String) {
	let lines = input.split(separator: "\n")
	var exprs: [Expression] = []

	// iterate through the lines sideways
	exprs.append(.init(nums: []))
	var exprInd = 0
	var col = lines.first!.count - 1
	while col >= 0 {
		let verticalLine = lines.reduce("", { result, line in
			result + String(line[line.index(line.startIndex, offsetBy: col)])
		})

		let numStr = verticalLine[verticalLine.startIndex..<verticalLine.index(before: verticalLine.endIndex)].trimmingCharacters(in: [" "])
		let opStr = verticalLine[verticalLine.index(before: verticalLine.endIndex)]

		if Int(numStr) != nil {
			exprs[exprInd].nums.append(Int(numStr)!)
		} else {
			exprs.append(.init(nums: []))
			exprInd += 1
		}
		if opStr == "*" {
			exprs[exprInd].operation = .Mul
		} else if opStr == "+" {
			exprs[exprInd].operation = .Add
		}

		col -= 1
	}

	// calculate sum
	var sum = 0
	for expr in exprs {
		switch expr.operation {
			case .Add:
				sum += expr.nums.reduce(0, +)
			case .Mul:
				sum += expr.nums.reduce(1, *)
			default:
				()
		}
	}
	print("sum: \(sum)")
}
