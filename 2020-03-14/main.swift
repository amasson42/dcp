
// MARK: - function
func arrayOfProd(array: [Int]) -> [Int] {
    guard array.isEmpty == false else {
        return []
    }
    var leftProd = [Int](repeating: 1, count: array.count)
    var rightProd = [Int](repeating: 1, count: array.count)
    let li = array.count - 1
    
    for i in 1 ..< array.count {
        leftProd[i] = leftProd[i - 1] * array[i - 1]
        rightProd[li - i] = rightProd[li - i + 1] * array[li - i + 1]
    }
    return (0 ... li).map { leftProd[$0] * rightProd[$0] }
}

// MARK: - tester
func testArrayWith(array: [Int], answer: [Int]) {
    let res = arrayOfProd(array: array)
    if res == answer {
        print("Ok")
    } else {
        print("\(array) -> \(res) != \(answer)")
    }
}

func makeArray(count: Int) -> [Int] {
    return (0..<count).map {_ in Int.random(in: 1...10)}
}

func getBruteForceAnswer(array: [Int]) -> [Int] {
    let prod = array.reduce(1, *)
    return array.enumerated().map {
        prod / array[$0.offset]
    }
}

testArrayWith(array: [], answer: [])
testArrayWith(array: [42], answer: [1])
testArrayWith(array: [1, 2, 3, 4, 5], answer: [120, 60, 40, 30, 24])
testArrayWith(array: [3, 2, 1], answer: [2, 3, 6])
testArrayWith(array: [5, 6, 7, 0, 2, 4, 0], answer: [0, 0, 0, 0, 0, 0, 0])
testArrayWith(array: [5, 6, 2, 4, -2, 0, 5], answer: [0, 0, 0, 0, 0, -2400, 0])

for count in [5, 7, 9] {
    let array = makeArray(count: count)
    let answer = getBruteForceAnswer(array: array)
    testArrayWith(array: array, answer: answer)
}
