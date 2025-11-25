import Foundation

let NUM_DAYS = 12

let USAGE = """

\(COL_YELLOW)usage:\(COL_RESET) aoc <day>

<day> must be between 1 and \(NUM_DAYS)
"""

let dayFuncs: [Int: @Sendable (String) -> String] = [
    1: day1,
]

@main
struct aoc {
    static func main() throws {
        let args = CommandLine.arguments

        if args.count == 1 {
            print(USAGE)
            return
        }

        if Int(args[1]) == nil {
            printError(msg: "day argument must be a number")
            return
        }

        let dayToRun = Int(args[1])!
        if dayToRun > NUM_DAYS {
            printError(msg: "day must be < " + String(NUM_DAYS))
            return
        }
        let dayInput = try String(contentsOfFile: "DayInputs/day1.txt", encoding: .utf8)
        let dayFunc = dayFuncs[dayToRun]!

        print(dayFunc(dayInput))
    }
}
