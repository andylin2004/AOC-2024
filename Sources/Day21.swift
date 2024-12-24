import Algorithms

struct Day21: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var codesToEnter: [String] {
    data.split(separator: "\n").compactMap { line in
      String(line)
    }
  }
  
  let keypadLocations: [Character: (Int, Int)] = ["7": (0, 0), "8": (0, 1), "9": (0, 2), "4": (1, 0), "5": (1, 1), "6": (1, 2), "1": (2, 0), "2": (2, 1), "3": (2, 2), "0": (3, 1), "A": (3,2)]
  
  let arrowLocations: [Character: (Int, Int)] = ["^": (0, 1), "A": (0, 2), "<": (1, 0), "v": (1,1), ">": (1,2)]

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    for code in codesToEnter {
      let numericalPart = Int(code.dropLast())
      
      // robot for numpad
      
      var robotNumPadLoc: Character = "A"
      var robotArrowLoc: Character = "A"
      var humanArrowLoc: Character = "A"
      
      var arrowDirectionsRobot1: [Character] = []
      var arrowDirectionsRobot2: [Character] = []
      var arrowDirectionsHuman: [Character] = []
      
      for character in code {
        let directionsToNextNum = generateInstructionsToWalkTo(context: .numPad, from: robotNumPadLoc, to: character)
        
        arrowDirectionsRobot1.append(contentsOf: directionsToNextNum.flatMap({ kvPair in
          Array(repeating: kvPair.key, count: kvPair.value)
        }))
        arrowDirectionsRobot1.append("A")
        
        var desiredSteps = [Character]()
        var desiredTotal = 0
        for permutation in directionsToNextNum.keys.permutations() {
          var total = 0
          var steps = [Character]()
          for direction in permutation {
            let directionsToNextDirection = generateInstructionsToWalkTo(context: .arrows, from: robotArrowLoc, to: direction)
            let directionsToA = generateInstructionsToWalkTo(context: .arrows, from: direction, to: "A")
            
            total += directionsToNextDirection.values.reduce(0) { $0 + $1 } + directionsToA.values.reduce(0) { $0 + $1 }
            steps.append(contentsOf: directionsToNextDirection.flatMap({ kvPair in
              Array(repeating: kvPair.key, count: kvPair.value)
            }))
            steps.append(contentsOf: Array(repeating: "A", count: directionsToNextNum[direction]!))
            steps.append(contentsOf: directionsToA.flatMap({ kvPair in
              Array(repeating: kvPair.key, count: kvPair.value)
            }))
            steps.append("A")
          }
          
          if total > desiredTotal {
            desiredTotal = total
            desiredSteps = steps
          }
          
          robotNumPadLoc = character
        }
        
        robotArrowLoc = desiredSteps.last!
        
        arrowDirectionsRobot2.append(contentsOf: desiredSteps)
      }
      
      print(arrowDirectionsRobot1.compactMap({String($0)}).joined())
      print(arrowDirectionsRobot2.compactMap({String($0)}).joined())
    }
    
    return ""
  }

  // Replace this with your solution for the second part of the day's challenge.
//  func part2() -> Any {
//    // Sum the maximum entries in each set of data
//  }
  
  struct Location: Hashable, AdditiveArithmetic {
    static func - (lhs: Location, rhs: Location) -> Location {
      return Location(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
    }
    
    static func + (lhs: Location, rhs: Location) -> Location {
      return Location(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
    }
    
    static let zero: Location = Location(row: 0, col: 0)
    
    let row: Int
    let col: Int
    
    var description: String {
      return "\(col),\(row)"
    }
    
    func inBounds(rowSize: Int, colSize: Int) -> Bool {
      return row >= 0 && row < rowSize && col >= 0 && col < colSize
    }
  }
  
  enum Map {
    case numPad
    case arrows
  }
  
  func generateInstructionsToWalkTo(context: Map, from: Character, to: Character) -> [Character: Int] {
    switch context {
    case .numPad:
      let origin = keypadLocations[from]!
      let dest = keypadLocations[to]!
      
      let rowNumChange = dest.0 - origin.0
      let colNumChange = dest.1 - origin.1
      
      var actionsToDo = [Character: Int]()
      
      if colNumChange > 0 {
        actionsToDo[">"] = colNumChange
      } else if colNumChange < 0 {
        actionsToDo["<"] = -colNumChange
      }
      
      if rowNumChange > 0 {
        actionsToDo["v"] = rowNumChange
      } else if rowNumChange < 0 {
        actionsToDo["^"] = -rowNumChange
      }
      
      return actionsToDo
    case .arrows:
      let origin = arrowLocations[from]!
      let dest = arrowLocations[to]!
      
      let rowNumChange = dest.0 - origin.0
      let colNumChange = dest.1 - origin.1
      
      var actionsToDo = [Character: Int]()
      
      if colNumChange > 0 {
        actionsToDo[">"] = colNumChange
      } else if colNumChange < 0 {
        actionsToDo["<"] = -colNumChange
      }
      
      if rowNumChange > 0 {
        actionsToDo["v"] = rowNumChange
      } else if rowNumChange < 0 {
        actionsToDo["^"] = -rowNumChange
      }
      
      return actionsToDo
    }
  }
}
