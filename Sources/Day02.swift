import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var total = 0
    for row in entities {
      var direction: Int = 0
      for i in 1..<row.count {
        let diff = row[i] - row[i-1]
        if (1 <= diff && diff <= 3 && direction >= 0) || (-3 <= diff && diff <= -1 && direction <= 0) {
          direction = diff
          if i == row.count - 1 {
            total += 1
          }
        } else {
          break
        }
      }
      
    }
    return total
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var total = 0
    
    for row in entities {
      var add = false
      for combo in row.combinations(ofCount: row.count - 1) {
        var direction: Int = 0
        for i in 1..<combo.count {
          let diff = combo[i] - combo[i-1]
          if (1 <= diff && diff <= 3 && direction >= 0) || (-3 <= diff && diff <= -1 && direction <= 0) {
            direction = diff
            if i == combo.count - 1 {
              add = true
              break
            }
          } else {
            break
          }
        }
        if add {
          break
        }
      }
      
      if add {
        total += 1
      }
    }
    
    return total
  }
}
