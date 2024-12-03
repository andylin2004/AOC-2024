import Algorithms
import RegexBuilder

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let regex = /mul\(([0-9]+),([0-9]+)\)/
    
    var total = 0
    
    for captureGroup in data.matches(of: regex) {
      total += (Int(captureGroup.output.1) ?? 0) * (Int(captureGroup.output.2) ?? 0)
    }
    
    return total
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
   let regex = /mul\(([0-9]+),([0-9]+)\)|(do\(\))|(don't\(\))/

    var total = 0
    
    var enabled = true
    
    for captureGroup in data.matches(of: regex) {
      if captureGroup.output.3 != nil {
        enabled = true
      } else if captureGroup.output.4 != nil {
        enabled = false
      } else if enabled {
        total += (Int(captureGroup.output.1 ?? "0") ?? 0) * (Int(captureGroup.output.2 ?? "0") ?? 0)
      }
    }
    
    return total
  }
}
