
func possibleWayToStep(n: Int, withSteps steps: [Int]) -> Int {
    if n == 0 {
        return 0
    }
    return steps.reduce(0) {
        total, step in
        if n == step {
            return total + 1
        } else if n > step {
            return total + possibleWayToStep(n: n - step, withSteps: steps)
        } else {
            return total
        }
    }
}

func testWith(n: Int, steps: [Int], answer: Int) {
    let ans = possibleWayToStep(n: n, withSteps: steps)
    if ans == answer {
        print("OK")
    } else {
        print("\(n), \(steps) -> \(answer) : \(ans)")
    }
}

testWith(n: 1, steps: [1, 2], answer: 1)
testWith(n: 2, steps: [1, 2], answer: 2)
testWith(n: 3, steps: [1, 2], answer: 3)
testWith(n: 4, steps: [1, 2], answer: 5)
testWith(n: 0, steps: [1, 2], answer: 0)
testWith(n: 0, steps: [0, 1], answer: 0)
testWith(n: 5, steps: [1], answer: 1)
testWith(n: 5, steps: [1, 3, 5], answer: 5)
testWith(n: 7, steps: [4, 5], answer: 0)
testWith(n: 13, steps: [1, 9], answer: 6)
