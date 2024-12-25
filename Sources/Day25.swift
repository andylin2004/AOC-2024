import Algorithms

struct Day25: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Substring]] {
    data.split(separator: "\n\n").compactMap { map in
      map.split(separator: "\n")
    }
  }
  
  var keys: [[Substring]] {
    entities.filter { map in
      map.first == "....."
    }
  }
  
  var locks: [[Substring]] {
    entities.filter { map in
      map.first == "#####"
    }
  }
  
  var keyFlattened: [[Int]] {
    keys.compactMap { map in
      var result = Array(repeating: 0, count: map[0].count)
      
      for row in 0..<map.count {
        for col in 0..<map[0].count {
          if Array(map[row])[col] == "#" {
            result[col] += 1
          }
        }
      }
      
      return result
    }
  }
  
  var locksFlattened: [[Int]] {
    locks.compactMap { map in
      var result = Array(repeating: 0, count: map[0].count)
      
      for row in 0..<map.count {
        for col in 0..<map[0].count {
          if Array(map[row])[col] == "#" {
            result[col] += 1
          }
        }
      }
      
      return result
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var total = 0
    for (key, lock) in product(keyFlattened, locksFlattened) {
      var failed = false
      
      for (keyNum, lockNum) in zip(key, lock) {
        if (keyNum - 1) + (lockNum - 1) > 5 {
          failed = true
          break
        }
      }
      
      if !failed {
        total += 1
      }
    }
    
    return total
  }
}
