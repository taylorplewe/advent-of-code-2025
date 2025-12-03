let evenDivisors: [Int: [Int]] = [
	1: [],
	2: [],
	3: [],
	4: [2],
	5: [],
	6: [2, 3],
	7: [],
	8: [2, 4],
	9: [3],
	10: [2, 5],
	11: [],
	12: [2, 3, 4, 6],
]

@Sendable
func day2(input: String) {
	let pairs = input.split(separator: ",")
	var sum: UInt64 = 0
	for pair in pairs {
		let rangeSplit = pair.split(separator: "-")
		let lower_str = rangeSplit[0]
		let higher_str = rangeSplit[1]
		
		let lower = Int(lower_str)!
		let higher = Int(higher_str)!
		
		checkNumber: for i in lower...higher {
			let iStr = String(i)
			let iCharCount = iStr.count

			if iCharCount == 1 {
				continue checkNumber
			}

			let divisors = evenDivisors[iCharCount]
			if divisors == nil {
				print("ERROR: length of number string not found in evenDivisors.\n length: \(iCharCount)\n num: \(iStr)")
			}

			var areAllSameChar = true
			allSameCharCheck: for c in 1..<iCharCount {
				if iStr[iStr.index(iStr.startIndex, offsetBy: c)] != iStr.first! {
					areAllSameChar = false
					break allSameCharCheck
				}
			}
			if areAllSameChar {
				sum += UInt64(i)
				continue checkNumber
			}

			checkDivisorForNumber: for divisor in divisors! {
				let sectionToMatch = iStr[iStr.startIndex..<iStr.index(iStr.startIndex, offsetBy: divisor)]
				var ind = divisor
				while ind < iCharCount {
					let startInd = iStr.index(iStr.startIndex, offsetBy: ind)
					let endInd = iStr.index(startInd, offsetBy: divisor)
					let section = iStr[startInd..<endInd]
					if (section != sectionToMatch) {
						continue checkDivisorForNumber
					}
					ind += divisor
				}

				sum += UInt64(i)
				continue checkNumber
			}

			// PART 1
			// if iCharCount & 1 != 0 {
			// 	continue
			// }
			// let halfInd = iCharCount / 2

			// let firstHalf = iStr[iStr.startIndex..<iStr.index(iStr.startIndex, offsetBy: halfInd)]
			// let secondHalf = iStr[iStr.index(iStr.startIndex, offsetBy: halfInd)..<iStr.endIndex]

			// if firstHalf == secondHalf {
			// 	sum += i
			// }
		}
	}

	print("sum:", sum)
}
