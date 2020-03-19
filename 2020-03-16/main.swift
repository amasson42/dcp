
func findMissingPositive(_ array: [Int]) -> Int {
    var found: [Bool] = [Bool](repeating: false, count: array.count + 1)
    array.forEach {
        if found.indices.contains($0 - 1) {
	    found[$0 - 1] = true
	}
    }
    return 1 + (found.firstIndex(of: false) ?? 0)
}

print(findMissingPositive([3, 4, -1, 1]) == 2)
print(findMissingPositive([1, 2, 0]) == 3)
print(findMissingPositive([1, 2, 3, 4]) == 5)
