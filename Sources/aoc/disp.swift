let COL_RED = "\u{1b}[31m"
let COL_GREEN = "\u{1b}[32m"
let COL_YELLOW = "\u{1b}[33m"
let COL_RESET = "\u{1b}[0m"

func printError(msg: String) {
	print("\(COL_RED)error\(COL_RESET) -", msg)
}