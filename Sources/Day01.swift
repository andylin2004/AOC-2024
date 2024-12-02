import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }
  
  var left: [Int] {
    entities.compactMap { a in
      a[0]
    }
  }
  
  var right: [Int] {
    entities.compactMap { a in
      a[1]
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var left: [Int] = left.sorted().reversed()
    var right: [Int] = right.sorted().reversed()
    
    var total = 0
    
    while !left.isEmpty || !right.isEmpty {
      let a = left.popLast() ?? 0
      let b = right.popLast() ?? 0
      
      total += abs(a-b)
    }
    
    return total
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let rightDict = left.keyed { a in
      right.count(where: { $0 == a })
    }
    
    var total = 0
    
    for i in left {
      total += (rightDict[i] ?? 0) * i
    }
    
    return total
  }
}
