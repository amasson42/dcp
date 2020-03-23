func largestNonAdjacents(in array: [Int]) -> Int {
    guard array.count > 2 else {
        return max(0, array.max() ?? 0)
    }
    var cache = (0, 0)
    cache.0 = max(0, array[0])
    cache.1 = max(cache.0, array[1])
    for i in 2 ..< array.count {
        cache = (cache.1, max(array[i] + cache.0, cache.1))
    }
    return cache.1
}

func testWith(arr: [Int], answer: Int) {
    if largestNonAdjacents(in: arr) == answer {
        print("ok")
    } else {
        print("NOPE")
    }
}

testWith(arr: [2, 4, 6, 2, 5], answer: 13)
testWith(arr: [5, 1, 1, 5], answer: 10)
testWith(arr: [], answer: 0)
testWith(arr: [5], answer: 5)
testWith(arr: [-5], answer: 0)
testWith(arr: [-10, -3, -4, -2], answer: 0)
let randomArr = (0 ... 10).map { _ in Int.random(in: -10 ... 20) }

print(randomArr, largestNonAdjacents(in: randomArr))
