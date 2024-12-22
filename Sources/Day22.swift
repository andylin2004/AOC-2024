import Algorithms
import Collections

struct Day22: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var numbers: [Int] {
    data.split(separator: "\n").compactMap { line in
      Int(line)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async -> Any {
    var total = 0
    
    await withTaskGroup(of: Int.self) { group in
      for number in numbers {
        group.addTask {
          var finalNumber = number
          for _ in 0..<2000 {
            var mulResult = finalNumber * 64
            finalNumber.mix(given: mulResult)
            finalNumber.prune()
            let divResult = (Double(finalNumber) / 32.0).rounded(.down)
            finalNumber.mix(given: Int(divResult))
            finalNumber.prune()
            mulResult = finalNumber * 2048
            finalNumber.mix(given: mulResult)
            finalNumber.prune()
          }
          
          return finalNumber
        }
      }
      
      for await result in group {
        total += result
      }
    }
    
    return total
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() async -> Any {
    var groupOf4sFromAllNumbers = [[[Int]: Int]]()
    
    await withTaskGroup(of: [[Int]: Int].self) { group in
      for number in numbers {
        group.addTask {
          var finalNumber = number
          var last4Diff: Deque<Int> = Deque()
          var groupOf4s = [[Int]: Int]()
          for _ in 0..<2000 {
            let prevResult = finalNumber
            
            var mulResult = finalNumber * 64
            finalNumber.mix(given: mulResult)
            finalNumber.prune()
            let divResult = (Double(finalNumber) / 32.0).rounded(.down)
            finalNumber.mix(given: Int(divResult))
            finalNumber.prune()
            mulResult = finalNumber * 2048
            finalNumber.mix(given: mulResult)
            finalNumber.prune()
            
            last4Diff.append(finalNumber % 10 - prevResult % 10)
            if last4Diff.count > 4 {
              last4Diff.removeFirst()
            }
            if last4Diff.count == 4 && groupOf4s[Array(last4Diff)] == nil {
              groupOf4s[Array(last4Diff)] = finalNumber % 10
            }
          }
          
          return groupOf4s
        }
        
        for await result in group {
          groupOf4sFromAllNumbers.append(result)
        }
      }
    }
    
    var uniqueChangeSequences = Set<[Int]>()
    
    for groupOf4s in groupOf4sFromAllNumbers {
      for key in groupOf4s.keys {
        uniqueChangeSequences.insert(key)
      }
    }
    
    var toReturn = 0
    
    await withTaskGroup(of: Int.self) { group in
      let uniqueChangeSequences = uniqueChangeSequences
      let groupOf4sFromAllNumbers = groupOf4sFromAllNumbers
      
      for changeSequence in uniqueChangeSequences {
        group.addTask {
          var total = 0
          for groupOf4s in groupOf4sFromAllNumbers {
            if let add = groupOf4s[changeSequence] {
              total += add
            }
          }
          return total
        }
      }
      
      for await result in group {
        toReturn = max(result, toReturn)
      }
    }
    
    return toReturn
  }
}

extension Int {
  mutating func mix(given: Int) {
    self = given ^ self
  }
  
  mutating func prune() {
    self %= 16777216
  }
}
