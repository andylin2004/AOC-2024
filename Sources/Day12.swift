import Algorithms

struct Day12: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var map: [[Character]] {
    data.split(separator: "\n").compactMap {
      Array($0)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var mapped = Array(repeating: Array(repeating: false, count: map[0].count), count: map.count)
    
    var earliestUnmapped: Location? {
      for row in mapped.indices {
        for col in mapped[row].indices {
          if !mapped[row][col] {
            return Location(row: row, col: col)
          }
        }
      }
      return nil
    }
    
    var allDimensions = [Dimensions]()
    var total = 0
    
    while let earliestUnmapped {
      var cursors: Set<Location> = [earliestUnmapped]
      var updatedCursors: Set<Location> = []
      let letter = map[earliestUnmapped.row][earliestUnmapped.col]
      var walkedThrough = Set<Location>()
      var perimeter = 0
      
//      print(letter, earliestUnmapped)
      
      while !cursors.isEmpty {
        for cursor in cursors {
          if map[cursor.row][cursor.col] == letter {
            walkedThrough.insert(cursor)
            mapped[cursor.row][cursor.col] = true
            
            let thisPerimeter = numAdditionalPerimeter(cursor)
//            print(thisPerimeter, cursor)
            
            perimeter += thisPerimeter
            
            if cursor.col + 1 < map[0].count && map[cursor.row][cursor.col + 1] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row, col: cursor.col + 1))
            }
            if cursor.row + 1 < map.count && map[cursor.row + 1][cursor.col] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row + 1, col: cursor.col))
            }
            
            if cursor.col - 1 >= 0 && map[cursor.row][cursor.col - 1] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row, col: cursor.col - 1))
            }
            if cursor.row - 1 >= 0 && map[cursor.row - 1][cursor.col] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row - 1, col: cursor.col))
            }
          }
        }
        
        updatedCursors.subtract(walkedThrough)
        cursors = updatedCursors
        
//        printMap()
//        print(cursors)
      }
      
      allDimensions.append(Dimensions(letter: letter, area: walkedThrough.count, perimeter: perimeter))
    }
    
    func numAdditionalPerimeter(_ location: Location) -> Int {
      var total = 0
      let upDiff = location.row == 0 || map[location.row - 1][location.col] != map[location.row][location.col]
      let dwnDiff = location.row == map.count - 1 || map[location.row + 1][location.col] != map[location.row][location.col]
      let lftDiff = location.col == 0 || map[location.row][location.col - 1] != map[location.row][location.col]
      let rightDiff = location.col == map[0].count - 1 || map[location.row][location.col + 1] != map[location.row][location.col]
      
      if upDiff { total += 1 }
      if dwnDiff { total += 1 }
      if lftDiff { total += 1 }
      if rightDiff { total += 1 }
      
      return total
    }
    
    func printMap() {
      for row in mapped {
        for col in row {
          print(col ? "X" : "O", terminator: "")
        }
        print()
      }
    }
    
    for dimension in allDimensions {
      total += dimension.area * dimension.perimeter
    }
    
//    print(allDimensions)
    
    return total
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var mapped = Array(repeating: Array(repeating: false, count: map[0].count), count: map.count)
    
    var earliestUnmapped: Location? {
      for row in mapped.indices {
        for col in mapped[row].indices {
          if !mapped[row][col] {
            return Location(row: row, col: col)
          }
        }
      }
      return nil
    }
    
    var allDimensions = [Dimensions]()
    var total = 0
    
    while let earliestUnmapped {
      var cursors: Set<Location> = [earliestUnmapped]
      var updatedCursors: Set<Location> = []
      let letter = map[earliestUnmapped.row][earliestUnmapped.col]
      var walkedThrough = Set<Location>()
      var sideInventory = Set<LocationSide>()
      
      while !cursors.isEmpty {
        for cursor in cursors {
          if map[cursor.row][cursor.col] == letter {
            walkedThrough.insert(cursor)
            mapped[cursor.row][cursor.col] = true
            
            let sides = getSides(cursor)
            
            sideInventory.formUnion(sides)
            
            if cursor.col + 1 < map[0].count && map[cursor.row][cursor.col + 1] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row, col: cursor.col + 1))
            }
            if cursor.row + 1 < map.count && map[cursor.row + 1][cursor.col] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row + 1, col: cursor.col))
            }
            
            if cursor.col - 1 >= 0 && map[cursor.row][cursor.col - 1] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row, col: cursor.col - 1))
            }
            if cursor.row - 1 >= 0 && map[cursor.row - 1][cursor.col] == map[cursor.row][cursor.col] {
              updatedCursors.insert(Location(row: cursor.row - 1, col: cursor.col))
            }
          }
        }
        
        updatedCursors.subtract(walkedThrough)
        cursors = updatedCursors
      }
      
      let colGroup = sideInventory.grouped(by: {$0.col}).filter({abs($0.key.truncatingRemainder(dividingBy: 0.5)) == 0.25}).compactMapValues({$0.compactMap({$0.row}).sorted().chunked(by: {$0 + 1 == $1}).count})
      let colTotal = colGroup.values.reduce(0, +)
      let rowGroup = sideInventory.grouped(by: {$0.row}).filter({abs($0.key.truncatingRemainder(dividingBy: 0.5)) == 0.25}).compactMapValues({$0.compactMap({$0.col}).sorted().chunked(by: {$0 + 1 == $1}).count})
      let rowTotal = rowGroup.values.reduce(0, +)
      
      allDimensions.append(Dimensions(letter: letter, area: walkedThrough.count, perimeter: colTotal + rowTotal))
    }
    
    func getSides(_ location: Location) -> Set<LocationSide> {
      var results = Set<LocationSide>()
      let upDiff = location.row == 0 || map[location.row - 1][location.col] != map[location.row][location.col]
      let dwnDiff = location.row == map.count - 1 || map[location.row + 1][location.col] != map[location.row][location.col]
      let lftDiff = location.col == 0 || map[location.row][location.col - 1] != map[location.row][location.col]
      let rightDiff = location.col == map[0].count - 1 || map[location.row][location.col + 1] != map[location.row][location.col]
      
      if upDiff { results.insert(LocationSide(row: Double(location.row) - 0.25, col: Double(location.col))) }
      if dwnDiff { results.insert(LocationSide(row: Double(location.row) + 0.25, col: Double(location.col))) }
      if lftDiff { results.insert(LocationSide(row: Double(location.row), col: Double(location.col) - 0.25)) }
      if rightDiff { results.insert(LocationSide(row: Double(location.row), col: Double(location.col) + 0.25)) }
      
      return results
    }
    
    func printMap() {
      for row in mapped {
        for col in row {
          print(col ? "X" : "O", terminator: "")
        }
        print()
      }
    }
    
    for dimension in allDimensions {
      total += dimension.area * dimension.perimeter
    }
    
//    print(allDimensions)
    
    return total
  }
  
  struct Location: Hashable {
    let row: Int
    let col: Int
  }
  
  struct LocationSide: Hashable {
    let row: Double
    let col: Double
  }
  
  struct Dimensions {
    let letter: Character
    let area: Int
    let perimeter: Int
  }
}
