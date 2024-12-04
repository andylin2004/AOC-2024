import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var grid: [[Character]] {
    data.split(separator: "\n").compactMap {
      Array($0)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async -> Any {
    
    var total = 0
    await withTaskGroup(of: Int.self) { group in
      for row in 0..<grid.count {
        for col in 0..<grid[0].count {
          group.addTask {
            return await seeIfXmasDirectionsMatch(row, col)
          }
        }
      }
      
      for await value in group {
        total += value
      }
    }
    
    return total
    
    func seeIfXmasDirectionsMatch(_ row: Int, _ col: Int) async -> Int {
      var total = 0
      
      await withTaskGroup(of: Bool.self) { group in
        if 3 <= row {
          group.addTask {
            return (grid[row][col] == "X" && grid[row - 1][col] == "M" && grid[row - 2][col] == "A" && grid[row - 3][col] == "S")
          }
          group.addTask {
            return 3 <= col && (grid[row][col] == "X" && grid[row - 1][col - 1] == "M" && grid[row - 2][col - 2] == "A" && grid[row - 3][col - 3] == "S")
          }
          group.addTask {
            return col <= grid[0].count - 4 && (grid[row][col] == "X" && grid[row - 1][col + 1] == "M" && grid[row - 2][col + 2] == "A" && grid[row - 3][col + 3] == "S")
          }
        }
        group.addTask {
          return 3 <= col && (grid[row][col] == "X" && grid[row][col - 1] == "M" && grid[row][col - 2] == "A" && grid[row][col - 3] == "S")
        }
        if row <= grid.count - 4 {
          group.addTask {
            return (grid[row][col] == "X" && grid[row + 1][col] == "M" && grid[row + 2][col] == "A" && grid[row + 3][col] == "S")
          }
          group.addTask {
            return 3 <= col && grid[row][col] == "X" && grid[row + 1][col - 1] == "M" && grid[row + 2][col - 2] == "A" && grid[row + 3][col - 3] == "S"
          }
          group.addTask {
            return col <= grid[0].count - 4 && (grid[row][col] == "X" && grid[row + 1][col + 1] == "M" && grid[row + 2][col + 2] == "A" && grid[row + 3][col + 3] == "S")
          }
        }
        group.addTask {
         return col <= grid[0].count - 4 && (grid[row][col] == "X" && grid[row][col + 1] == "M" && grid[row][col + 2] == "A" && grid[row][col + 3] == "S")
        }
        
        for await value in group {
          total += value ? 1 : 0
        }
      }
      
      return total
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() async -> Any {
    var total = 0
    await withTaskGroup(of: Bool.self) { group in
      for row in 2..<grid.count {
        for col in 2..<grid[0].count {
          group.addTask {
            return seeIfX_mas(row, col)
          }
        }
      }
      
      for await value in group {
        total += value ? 1 : 0
      }
    }
    
    return total
    
    func seeIfX_mas(_ row: Int, _ col: Int) -> Bool {
      if 2 <= row && 2 <= col {
        return grid[row - 1][col - 1] == "A" && ((grid[row - 2][col - 2] == "M" && grid[row - 2][col] == "M" && grid[row][col - 2] == "S" && grid[row][col] == "S") || (grid[row - 2][col - 2] == "S" && grid[row - 2][col] == "S" && grid[row][col - 2] == "M" && grid[row][col] == "M") || (grid[row - 2][col - 2] == "M" && grid[row][col - 2] == "M" && grid[row - 2][col] == "S" && grid[row][col] == "S") || (grid[row - 2][col - 2] == "S" && grid[row][col - 2] == "S" && grid[row - 2][col] == "M" && grid[row][col] == "M"))
      } else {
        return false
      }
    }
  }
}
