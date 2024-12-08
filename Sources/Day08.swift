import Algorithms

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var map: [[Character]] {
    data.split(separator: "\n").compactMap {
      Array($0)
    }
  }
  
  var nodePostions = [Character: Set<Location>]()

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var antinodes = Set<Location>()
    
    for nodePosition in nodePostions {
      let combos = nodePosition.value.combinations(ofCount: 2)
      
      for combo in combos {
        let diff = combo[0] - combo[1]
        
        var possiblePositions = Set(
          [
            combo[0] + diff,
            combo[0] - diff,
            combo[1] + diff,
            combo[1] - diff
          ]
        )
        
        possiblePositions = possiblePositions.subtracting(combo)
        
        for possiblePosition in possiblePositions {
          if possiblePosition.isInBounds(in: map) {
            antinodes.insert(possiblePosition)
          }
        }
      }
    }
    
    return antinodes.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var antinodes = Set<Location>()
    
    for nodePosition in nodePostions {
      if nodePosition.value.count > 1 {
        let combos = nodePosition.value.combinations(ofCount: 2)
        
        for combo in combos {
          let diff = combo[0] - combo[1]
          
          var possiblePositions = Set<Location>()
          
          var plus = combo[0]
          var minus = combo[0]
          
          while plus.isInBounds(in: map) || minus.isInBounds(in: map) {
            if plus.isInBounds(in: map) {
              possiblePositions.insert(plus)
            }
            if minus.isInBounds(in: map) {
              possiblePositions.insert(minus)
            }
            plus += diff
            minus -= diff
          }
          
          for possiblePosition in possiblePositions {
            if possiblePosition.isInBounds(in: map) {
              antinodes.insert(possiblePosition)
            }
          }
        }
      }
    }
    
    return antinodes.count
  }
  
  struct Location: Hashable, AdditiveArithmetic {
    static func - (lhs: Day08.Location, rhs: Day08.Location) -> Day08.Location {
      return Location(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
    }
    
    static func + (lhs: Day08.Location, rhs: Day08.Location) -> Day08.Location {
      return Location(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
    }
    
    func isInBounds(in map: [[Character]]) -> Bool {
      return 0 <= row && row < map.count && 0 <= col && col < map[0].count
    }
    
    static let zero: Location = Location(row: 0, col: 0)
    
    let row: Int
    let col: Int
  }
  
  init(data: String) {
    self.data = data
    
    for row in map.indices {
      for col in map[row].indices {
        if map[row][col] != "." {
          if !nodePostions.keys.contains(map[row][col]) {
            nodePostions[map[row][col]] = []
          }
          nodePostions[map[row][col]]?.insert(Location(row: row, col: col))
        }
      }
    }
  }
}
