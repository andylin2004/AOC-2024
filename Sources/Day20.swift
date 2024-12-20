import Algorithms
import Collections

struct Day20: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var map: [[Character]] {
    data.split(separator: "\n").compactMap { line in
      Array(line)
    }
  }
  
  var start: Location?
  var end: Location?
  
  var whenVisited = OrderedDictionary<Location, Int>()
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    return runCheat(maxTime: 2).filter({$0.key >= 100}).values.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    return runCheat(maxTime: 20/*, minSavedTimeFilter: 50*/).filter({$0.key >= 100}).values.reduce(0, +)
  }
  
  func runCheat(maxTime: Int, minSavedTimeFilter: Int = 2) -> [Int: Int] {
    var cheatQty = [Int: Int]()
    
    for curLocation in whenVisited.keys {
      for (rowChange, colChange) in product(-maxTime...maxTime, -maxTime...maxTime) {
        let change = abs(rowChange) + abs(colChange)
        if change <= maxTime && change != 0 {
          let addingValues = Location(row: rowChange, col: colChange)
          let newLocation = curLocation + addingValues
          if let destStep = whenVisited[newLocation], let originStep = whenVisited[curLocation], destStep > originStep {
            let saved = destStep - originStep - change
            
            if saved >= minSavedTimeFilter {
              if let _ = cheatQty[saved] {
                cheatQty[saved]! += 1
              } else {
                cheatQty[saved] = 1
              }
            }
          }
        }
      }
    }
    
    return cheatQty
  }
  
  struct Location: Hashable, AdditiveArithmetic {
    static func - (lhs: Day20.Location, rhs: Day20.Location) -> Day20.Location {
      return Location(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
    }
    
    static func + (lhs: Day20.Location, rhs: Day20.Location) -> Day20.Location {
      return Location(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
    }
    
    static let zero: Day20.Location = Location(row: 0, col: 0)
    
    let row: Int
    let col: Int
    
    var description: String {
      return "\(col),\(row)"
    }
    
    func inBounds(rowSize: Int, colSize: Int) -> Bool {
      return row >= 0 && row < rowSize && col >= 0 && col < colSize
    }
  }
  
  enum Direction {
    case up
    case down
    case left
    case right
  }
  
  init(data: String) {
    self.data = data
    
    var travelMap = Array(repeating: Array(repeating: false, count: map[0].count), count: map.count)
    
    for row in map.indices {
      for col in map[0].indices {
        if map[row][col] == "S" {
          start = Location(row: row, col: col)
        } else if map[row][col] == "E" {
          end = Location(row: row, col: col)
        }
      }
    }
    
    var cursor = start!
    var stepNum = 0
    
    while cursor != end! {
      travelMap[cursor.row][cursor.col] = true
      whenVisited[cursor] = stepNum
      
      if 0 < cursor.row && !travelMap[cursor.row - 1][cursor.col] && map[cursor.row - 1][cursor.col] != "#" {
        cursor = Location(row: cursor.row - 1, col: cursor.col)
      } else if 0 < cursor.col && !travelMap[cursor.row][cursor.col - 1] && map[cursor.row][cursor.col - 1] != "#" {
        cursor = Location(row: cursor.row, col: cursor.col - 1)
      } else if cursor.row < map.count - 1 && !travelMap[cursor.row + 1][cursor.col] && map[cursor.row + 1][cursor.col] != "#" {
        cursor =  Location(row: cursor.row + 1, col: cursor.col)
      } else if cursor.col < map.count - 1 && !travelMap[cursor.row][cursor.col + 1] && map[cursor.row][cursor.col + 1] != "#" {
        cursor = Location(row: cursor.row, col: cursor.col + 1)
      }
      
      stepNum += 1
    }
    
    travelMap[cursor.row][cursor.col] = true
    whenVisited[cursor] = stepNum
  }
}
