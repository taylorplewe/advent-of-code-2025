import Foundation

let NUM_DAYS = 12

let USAGE = """

\(COL_YELLOW)usage:\(COL_RESET) aoc <day>

<day> must be between 1 and \(NUM_DAYS)
"""

let dayFuncs: [Int: @Sendable (String) -> ()] = [
    1: day1,
    2: day2,
    3: day3,
    4: day4,
    5: day5,
    6: day6,
    7: day7,
    8: day8,
    9: day9,
    10: day10,
    11: day11,
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
        let dayInput = try String(contentsOfFile: "DayInputs/day\(dayToRun)ex.txt", encoding: .utf8)
        if dayFuncs[dayToRun] == nil {
            printError(msg: "day function not added to dayFuncs in aoc.swift")
            return
        }
        let dayFunc = dayFuncs[dayToRun]!

        dayFunc(dayInput)
    }
}
