@Sendable
func day2(input: String) {
	let pairs = input.split(separator: ",")
	var sum = 0
	for pair in pairs {
		let rangeSplit = pair.split(separator: "-")
		let lower_str = rangeSplit[0]
		let higher_str = rangeSplit[1]
		
		let lower = Int(lower_str)!
		let higher = Int(higher_str)!
		
		for i in lower...higher {
			let iStr = String(i)
			let iCharCount = iStr.count
			if iCharCount & 1 != 0 {
				continue
			}
			let halfInd = iCharCount / 2

			let firstHalf = iStr[iStr.startIndex..<iStr.index(iStr.startIndex, offsetBy: halfInd)]
			let secondHalf = iStr[iStr.index(iStr.startIndex, offsetBy: halfInd)..<iStr.endIndex]

			if firstHalf == secondHalf {
				sum += i
			}
		}
	}

	print("sum:", sum)
}
