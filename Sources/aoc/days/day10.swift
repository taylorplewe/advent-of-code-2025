typealias LightSet = [Bool]
typealias ButtonSet = [Int]

@Sendable
func day10(input: String) {
	let lines = input.split(separator: "\n")

	var sum = 0

	for line in lines {
		let reLightSet = /\[([\.#]+)\]/
		let reButtonSets = /\(([0-9,]+)\)/

		let lightSet = line.firstMatch(of: reLightSet)!.1
		let buttonSets = line.matches(of: reButtonSets).map{ match in
			String(match.1).split(separator: ",").map{ num in
				Int(num)!
			}
		}
	}

	print("sum: \(sum)")
}
