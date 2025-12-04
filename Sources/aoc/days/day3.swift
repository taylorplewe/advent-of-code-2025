import Foundation

@Sendable
func day3(input: String) {
	let banks = input.split(separator: "\n")

	var totalVoltage = 0
	for bank in banks {
		totalVoltage += part2Solution(bank: bank)
	}

	print("total:", totalVoltage)
}

func part2Solution(bank: String.SubSequence) -> Int {
	var voltage = 0
	var digitPlace = 11
	var startInd = 0
	while digitPlace >= 0 {
		print("digitPlace:", digitPlace)
		let slice = bank[bank.index(bank.startIndex, offsetBy: startInd)..<bank.index(bank.endIndex, offsetBy: -digitPlace)]
		let (num, ind) = findHighestDigitWithIndex(str: slice)
		print(" num: \(num) ind: \(ind)")
		startInd += ind + 1
		let factor = Int(pow(10.0, Double(digitPlace)))
		voltage += num * factor
		digitPlace -= 1
	}
	print(" voltage:", voltage)
	return voltage
}

func findHighestDigitWithIndex(str: Substring) -> (Int, Int) {
	var num = 9
	while num > 0 {
		var ind = 0
		for c in str {
			if c.wholeNumberValue! == num {
				return (num, ind)
			}
			ind += 1
		}
		num -= 1
	}

	print("ERROR: digits 0-9 not found in string: \"\(str)\"")
	return (-1, -1)
}

func part1Solution(bank: String.SubSequence) -> Int {
	var voltage = 0
	var num1 = 9
	outerNumLoop: while num1 > 0 {
		// print("num1:", num1, "end")
		var ind1 = 0
		for c1 in bank[bank.startIndex..<bank.index(before: bank.endIndex)] {
			// print(" c1:", c1, "end")
			if String(c1) == String(num1) {
				// print("matcheddd")
				voltage = num1 * 10
				var num2 = 9
				while num2 > 0 {
					// print("  num2:", num2)
					for c2 in bank[bank.index(after: bank.index(bank.startIndex, offsetBy: ind1))...] {
						// print("  c2:", c2)
						if c2 == String(num2).first! {
							voltage += num2
							break outerNumLoop
						}
					}
					num2 -= 1
				}
			}
			ind1 += 1
		}
		num1 -= 1
	}

	return voltage
}
