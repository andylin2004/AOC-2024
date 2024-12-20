import Algorithms
import Collections

struct Day18: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var coords: [Location] {
    data.split(separator: "\n").compactMap { line in
      let coord = line.split(separator: ",").compactMap { num in
        Int(num)
      }
      return Location(row: coord[1], col: coord[0])
    }
  }
  
  func testPart1() -> Any {
    let truncatedCoords = coords.prefix(12)
    
    return dijkstra(mapSize: 7, unwalkableCoords: Array(truncatedCoords))!
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let truncatedCoords = coords.prefix(1024)
    
    return dijkstra(mapSize: 71, unwalkableCoords: Array(truncatedCoords))!
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var left = 1025
    var right = coords.count
    var mid = (left + right) / 2
    
    while left < right {
      mid = (left + right) / 2
      
      let leftResult = dijkstra(mapSize: 71, unwalkableCoords: Array(coords.prefix(left)), checkExitAccessibilityOnly: true)?.description ?? nil
      let midResult = dijkstra(mapSize: 71, unwalkableCoords: Array(coords.prefix(mid)), checkExitAccessibilityOnly: true)?.description ?? nil
      let rightResult = dijkstra(mapSize: 71, unwalkableCoords: Array(coords.prefix(right)), checkExitAccessibilityOnly: true)?.description ?? nil
      
      if midResult == nil {
        right = mid
      } else {
        left = mid
      }
      
      if right - left <= 1 {
        if leftResult != nil && rightResult == nil {
          return coords[right - 1].description
        }
      }
    }
    
    return ""
  }
  
  func testPart2() -> Any {
    var left = 14
    var right = coords.count
    var mid = (left + right) / 2
    
    while left < right {
      mid = (left + right) / 2
      
      let leftResult = dijkstra(mapSize: 7, unwalkableCoords: Array(coords.prefix(left)), checkExitAccessibilityOnly: true)?.description ?? nil
      let midResult = dijkstra(mapSize: 7, unwalkableCoords: Array(coords.prefix(mid)), checkExitAccessibilityOnly: true)?.description ?? nil
      let rightResult = dijkstra(mapSize: 7, unwalkableCoords: Array(coords.prefix(right)), checkExitAccessibilityOnly: true)?.description ?? nil
      
      if midResult == nil {
        right = mid
      } else {
        left = mid
      }
      
      if right - left <= 1 {
        if leftResult != nil && rightResult == nil {
          return coords[right - 1].description
        }
      }
    }
    
    return ""
  }
  
  func dijkstra(mapSize: Int, unwalkableCoords: [Location], checkExitAccessibilityOnly: Bool = false) -> Int? {
    
    var unvisited = Heap([LocationShortDistance(location: Location(row: 0, col: 0), distance: 0)])
    var visited = Set<Location>()
    var minDistanceToLocation: [Location : LocationShortDistance] = [Location(row: 0, col: 0): unvisited.min!]
    
    while let curNode = unvisited.popMin(), curNode.distance != .max {
      if 0 < curNode.location.row {
        let location = Location(row: curNode.location.row - 1, col: curNode.location.col)
        
        if !visited.contains(location) && !unwalkableCoords.contains(location) {
          if let curDist = minDistanceToLocation[location]?.distance {
            minDistanceToLocation[location]?.distance = min(curDist, curNode.distance + 1)
          } else {
            minDistanceToLocation[location] = LocationShortDistance(location: location, distance: curNode.distance + 1)
            
            unvisited.insert(minDistanceToLocation[location]!)
          }
        }
      }
      if 0 < curNode.location.col {
        let location = Location(row: curNode.location.row, col: curNode.location.col - 1)
        
        if !visited.contains(location) && !unwalkableCoords.contains(location) {
          if let curDist = minDistanceToLocation[location]?.distance {
            minDistanceToLocation[location]?.distance = min(curDist, curNode.distance + 1)
          } else {
            minDistanceToLocation[location] = LocationShortDistance(location: location, distance: curNode.distance + 1)
            
            unvisited.insert(minDistanceToLocation[location]!)
          }
        }
      }
      if curNode.location.row < mapSize - 1 {
        let location = Location(row: curNode.location.row + 1, col: curNode.location.col)
        
        if !visited.contains(location) && !unwalkableCoords.contains(location) {
          if let curDist = minDistanceToLocation[location]?.distance {
            minDistanceToLocation[location]?.distance = min(curDist, curNode.distance + 1)
          } else {
            minDistanceToLocation[location] = LocationShortDistance(location: location, distance: curNode.distance + 1)
            
            unvisited.insert(minDistanceToLocation[location]!)
          }
        }
      }
      if curNode.location.col < mapSize - 1 {
        let location = Location(row: curNode.location.row, col: curNode.location.col + 1)
        
        if !visited.contains(location) && !unwalkableCoords.contains(location) {
          if let curDist = minDistanceToLocation[location]?.distance {
            minDistanceToLocation[location]?.distance = min(curDist, curNode.distance + 1)
          } else {
            minDistanceToLocation[location] = LocationShortDistance(location: location, distance: curNode.distance + 1)
            
            unvisited.insert(minDistanceToLocation[location]!)
          }
        }
      }
      
      visited.insert(curNode.location)
      
      if checkExitAccessibilityOnly, let result = minDistanceToLocation[Location(row: mapSize - 1, col: mapSize - 1)] {
        return result.distance
      }
    }
    
    return minDistanceToLocation[Location(row: mapSize - 1, col: mapSize - 1)]?.distance
  }
  
  struct Location: Hashable, Comparable {
    static func < (lhs: Day18.Location, rhs: Day18.Location) -> Bool {
      return lhs.row < rhs.row || lhs.row == rhs.row && lhs.col < rhs.col
    }
    
    let row: Int
    let col: Int
    
    var description: String {
      return "\(col),\(row)"
    }
  }
  
  class LocationShortDistance: Comparable, Hashable {
    static func == (lhs: Day18.LocationShortDistance, rhs: Day18.LocationShortDistance) -> Bool {
      return lhs.location == rhs.location
    }
    
    static func < (lhs: Day18.LocationShortDistance, rhs: Day18.LocationShortDistance) -> Bool {
      return lhs.distance < rhs.distance
    }
    
    let location: Location
    var distance: Int
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(location)
    }
    
    init(location: Location, distance: Int) {
      self.location = location
      self.distance = distance
    }
  }
}
