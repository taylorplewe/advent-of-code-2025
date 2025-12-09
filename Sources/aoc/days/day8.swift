import Foundation

class Box {
	var id = UUID()
	var x: Int = 0
	var y: Int = 0
	var z: Int = 0

	init(x: Int, y: Int, z: Int) {
		self.x = x;
		self.y = y;
		self.z = z;
	}
}

struct Distance {
	var value: Double
	var box1: Box
	var box2: Box
}

extension Box: Hashable {
	static func == (lhs: Box, rhs: Box) -> Bool {
		return lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

typealias Circuit = Set<Box>

@Sendable
func day8(input: String) {
	var circuits: [Circuit] = []
	var boxes: [Box] = []

	let lines = input.split(separator: "\n")
	for line in lines {
		let values = line.split(separator: ",").map({ Int($0)! })
		let box: Box = .init(x: values[0], y: values[1], z: values[2])
		boxes.append(box)
		circuits.append(Set.init([box]))
	}

	// calculate distances
	var distances: [Distance] = []
	for (index1, box1) in boxes.enumerated() {
		for box2 in boxes[(index1 + 1)...] {
			let dist = sqrt(pow(Double(abs(box2.x - box1.x)), 2.0) + pow(Double(abs(box2.y - box1.y)), 2.0) + pow(Double(abs(box2.z - box1.z)), 2.0))
			// let dist = abs(box2.x - box1.x) + abs(box2.y - box1.y) + abs(box2.z - box1.z)
			distances.append(.init(value: dist, box1: box1, box2: box2))
		}
	}

	distances.sort(by: { $0.value < $1.value })

	let NUM_CONNECTIONS = 1000
	let NUM_TOP_CIRCUITS = 3

	// for distance in distances[0..<NUM_CONNECTIONS] {
	for distance in distances {
		connectTwoBoxes(circuits: &circuits, box1: distance.box1, box2: distance.box2)
	}

	circuits.sort(by: { $0.count > $1.count })

	// printCircuits(circuits: circuits)

	var product = 1
	for i in 0..<NUM_TOP_CIRCUITS {
		product *= circuits[i].count
	}
	print(product)
}

func connectTwoBoxes(circuits: inout [Circuit], box1: Box, box2: Box) {
	let circuit1Index = getCircuitOfBox(circuits: circuits, box: box1)
	let circuit2Index = getCircuitOfBox(circuits: circuits, box: box2)
	if circuit1Index == circuit2Index {
		return
	}
	circuits[circuit1Index] = circuits[circuit1Index].union(circuits[circuit2Index])
	circuits.remove(at: circuit2Index)

	// part 2
	if circuits.count == 1 {
		print("last connection!\nbox1.x * box2.x: \(box1.x * box2.x)")
	}
}

/// Returns the index into `circuits` of the circuit this box is in, or `nil` if it wasn't found in any
func getCircuitOfBox(circuits: [Circuit], box: Box) -> Int {
	for (index, circuit) in circuits.enumerated() {
		if circuit.contains(box) {
			return index
		}
	}
	assert(false) // unreachable; every box must be in a circuit
}

// debug functions
func printCircuits(circuits: [Circuit]) {
	for circuit in circuits {
		for box in circuit {
			print("\(box.x),\(box.y),\(box.z)", separator: "", terminator: " ")
		}
		print()
	}
}

func testConnectingCircuits(circuits: inout [Circuit], boxes: [Box]) {
	connectTwoBoxes(circuits: &circuits, box1: boxes[0], box2: boxes[1])
	connectTwoBoxes(circuits: &circuits, box1: boxes[2], box2: boxes[3])
	connectTwoBoxes(circuits: &circuits, box1: boxes[0], box2: boxes[3])
	printCircuits(circuits: circuits)
	print("number of circuits: \(circuits.count)")
}

func print4ShortestConnections(distances: [Distance]) {
	print("shortest distance: \(distances[0].value) between \(distances[0].box1.x),\(distances[0].box1.y),\(distances[0].box1.z) and \(distances[0].box2.x),\(distances[0].box2.y),\(distances[0].box2.z)")
	print("next shortest distance: \(distances[1].value) between \(distances[1].box1.x),\(distances[1].box1.y),\(distances[1].box1.z) and \(distances[1].box2.x),\(distances[1].box2.y),\(distances[1].box2.z)")
	print("next shortest distance: \(distances[2].value) between \(distances[2].box1.x),\(distances[2].box1.y),\(distances[2].box1.z) and \(distances[2].box2.x),\(distances[2].box2.y),\(distances[2].box2.z)")
	print("next shortest distance: \(distances[3].value) between \(distances[3].box1.x),\(distances[3].box1.y),\(distances[3].box1.z) and \(distances[3].box2.x),\(distances[3].box2.y),\(distances[3].box2.z)")
}
