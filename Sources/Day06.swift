import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var map: [[Character]] {
    data.split(separator: "\n").compactMap {
      Array($0)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var curRow = map.firstIndex(where: {$0.contains(where: {$0 == "^"})}) ?? 0
    var curCol = map[curRow].firstIndex(of: "^") ?? 0
    var direction = Direction.up
    var positions: Set<Location> = [Location(row: curRow, col: curCol)]
    
    while 0 <= curRow && curRow < map.count && 0 <= curCol && curCol < map[0].count {
      if let next = step(map: map, direction: &direction, curRow: &curRow, curCol: &curCol) {
        positions.insert(next)
      } else {
        break
      }
    }
    
    return positions.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var curRow = map.firstIndex(where: {$0.contains(where: {$0 == "^"})}) ?? 0
    var curCol = map[curRow].firstIndex(of: "^") ?? 0
    var direction = Direction.up
    var total = 0
    var steps: Set<Location> = []
    
    while 0 <= curRow && curRow < map.count && 0 <= curCol && curCol < map[0].count {
      if canContinue(map: map, direction: direction, curRow: curRow, curCol: curCol) == .yes && canTurnAndCollide(map: map, direction: direction, curRow: curRow, curCol: curCol){
        let blockLoc = nextBlock(direction: direction, curRow: curRow, curCol: curCol)
        if !steps.contains(blockLoc) {
          var tempMap = map
          tempMap[blockLoc.row][blockLoc.col] = "#"
          if turnCausesALoop(map: tempMap, direction: direction, curRow: curRow, curCol: curCol) {
            total += 1
          }
        }
      }
      
      if let step = step(map: map, direction: &direction, curRow: &curRow, curCol: &curCol) {
        steps.insert(step)
      } else {
        break
      }
    }
    
    return total
  }
  
  enum Direction: Int {
    case up = 0
    case down = 2
    case left = 3
    case right = 1
  }
  
  struct Location: Hashable {
    let row: Int
    let col: Int
  }
  
  struct LocationDirection: Hashable {
    let location: Location
    let direction: Direction
  }
  
  func step(map: [[Character]], direction: inout Direction, curRow: inout Int, curCol: inout Int) -> Location? {
    do {
      switch canContinue(map: map, direction: direction, curRow: curRow, curCol: curCol) {
      case .ifTurned:
        direction = Direction(rawValue: (direction.rawValue + 1) % 4)!
        return Location(row: curRow, col: curCol)
      case .no:
        return nil
      case .yes:
        return move(direction: direction, curRow: &curRow, curCol: &curCol)
      }
    }
  }
  
  func canContinue(map: [[Character]], direction: Direction, curRow: Int, curCol: Int) -> CanContinue {
    switch direction {
    case .up:
      if 0 <= curRow - 1 {
        return map[curRow - 1][curCol] != "#" ? .yes : .ifTurned
      } else {
        return .no
      }
    case .down:
      if curRow + 1 < map.count {
        return map[curRow + 1][curCol] != "#" ? .yes : .ifTurned
      } else {
        return .no
      }
    case .left:
      if 0 <= curCol - 1 {
        return map[curRow][curCol - 1] != "#" ? .yes : .ifTurned
      } else {
        return .no
      }
    case .right:
      if curCol + 1 < map[0].count {
        return map[curRow][curCol + 1] != "#" ? .yes : .ifTurned
      } else {
        return .no
      }
    }
  }
  
  func move(direction: Direction, curRow: inout Int, curCol: inout Int) -> Location {
    switch direction {
    case .up:
      curRow -= 1
    case .down:
      curRow += 1
    case .left:
      curCol -= 1
    case .right:
      curCol += 1
    }
    return Location(row: curRow, col: curCol)
  }
           
  func nextBlock(direction: Direction, curRow: Int, curCol: Int) -> Location{
    switch direction {
    case .up:
      return Location(row: curRow - 1, col: curCol)
    case .down:
      return Location(row: curRow + 1, col: curCol)
    case .left:
      return Location(row: curRow, col: curCol - 1)
    case .right:
      return Location(row: curRow, col: curCol + 1)
    }
  }
  
  func canTurnAndCollide(map: [[Character]], direction: Direction, curRow: Int, curCol: Int) -> Bool {
    let newDirection: Direction = Day06.Direction(rawValue: (direction.rawValue + 1) % 4)!
    
    switch newDirection {
    case .up:
      for row in 0..<curRow {
        if map[row][curCol] == "#" {
          return true
        }
      }
    case .down:
      for row in curRow + 1..<map.count {
        if map[row][curCol] == "#" {
          return true
        }
      }
    case .left:
      for col in 0..<curCol {
        if map[curRow][col] == "#" {
          return true
        }
      }
    case .right:
      for col in curCol..<map[0].count {
        if map[curRow][col] == "#" {
          return true
        }
      }
    }
    
    return false
  }
  
  enum CanContinue {
    case ifTurned
    case no
    case yes
  }
  
  func turnCausesALoop(map: [[Character]], direction: Direction, curRow: Int, curCol: Int) -> Bool {
    var steps: Set<LocationDirection> = []
    var direction = Direction(rawValue: (direction.rawValue + 1) % 4)!
    var curRow = curRow
    var curCol = curCol
    
    while 0 <= curRow && curRow < map.count && 0 <= curCol && curCol < map[0].count {
      let oldCount = steps.count
      if let next = step(map: map, direction: &direction, curRow: &curRow, curCol: &curCol) {
        let newStep = LocationDirection(location: next, direction: direction)
        steps.insert(newStep)
        if oldCount == steps.count {
          return true
        }
      } else {
        break
      }
    }
    
    return false
  }
}
