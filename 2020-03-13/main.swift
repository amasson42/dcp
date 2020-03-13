
func hasTwoAddingTo(array: [Int], targetValue: Int) -> Bool {
    var completers: Set<Int> = []
    for num in array {
        if completers.contains(num) {
            return true
        }
        completers.insert(targetValue - num)
    }
    return false
}

func testWithValues(array: [Int], targetValue: Int, answer: Bool) {
    if hasTwoAddingTo(array: array, targetValue: targetValue) == answer {
        print("Ok")
    } else {
        print("\(array) -> \(targetValue) should say \(answer) but is wrong !")
    }
}

testWithValues(array: [1, 2, 7, 4, 7], targetValue: 14, answer: true)
testWithValues(array: [1, 2, 7, 4, 7], targetValue: 6, answer: true)
testWithValues(array: [1, 2, 7, 4, 7], targetValue: 7, answer: false)
testWithValues(array: [1, 2, 7, 4, 7], targetValue: -1, answer: false)
testWithValues(array: [-4, 2, 7, 4, 7], targetValue: -2, answer: true)
testWithValues(array: [1, 2, 7, 4, 7], targetValue: -3, answer: false)
testWithValues(array: [-1, -2, 7, 4, 7], targetValue: -3, answer: true)
testWithValues(array: [1, 2, 7, 4, 7], targetValue: 8, answer: true)
testWithValues(array: [1, 2, 12, 4, -8], targetValue: 4, answer: true)
