import Algorithms
import Collections

struct Day19: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var dataSplit: [Substring] {
    data.split(separator: "\n\n")
  }
  
  var availablePatterns: Set<String> {
    Set(dataSplit[0].split(separator: ", ").compactMap({String($0)}))
  }
  
  var arrangements: [String] {
    dataSplit[1].split(separator: "\n").compactMap({String($0)})
  }
  
  var possibleLengthOfPattern: Set<Int> {
    Set(availablePatterns.compactMap { pattern in
      pattern.count
    })
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() async -> Any {
    var total = 0
    
    await withTaskGroup(of: Bool.self) { group in
      for arrangement in arrangements {
        group.addTask {
          checkIfPossible(arrangement: arrangement)
        }
      }
      
      for await result in group {
        total += result ? 1 : 0
      }
    }
    
    func checkIfPossible(arrangement: String) -> Bool {
      var possibleResults: Set<String> = [arrangement]
      var alreadyChecked = Set<String>()
      
      while !possibleResults.isEmpty {
        var newPossibleResults = Set<String>()
        
        for possibleResult in possibleResults {
          alreadyChecked.insert(possibleResult)
          for length in possibleLengthOfPattern {
            let testStr = String(possibleResult.prefix(length))
            if testStr.count == length && availablePatterns.contains(testStr) {
              let remaining = String(possibleResult.dropFirst(length))
              if remaining.isEmpty {
                return true
              } else {
                newPossibleResults.insert(remaining)
              }
            }
          }
        }
        
        if possibleResults == newPossibleResults {
          return false
        } else {
          possibleResults = newPossibleResults.subtracting(alreadyChecked)
        }
      }
      
      return false
    }
    
    return total
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() async -> Any {
    var total = 0
    
    await withTaskGroup(of: Int.self) { group in
      for arrangement in arrangements {
        group.addTask {
          checkPermutationCount(arrangement: arrangement)
        }
      }
      
      for await result in group {
        total += result
      }
    }
    
    func checkPermutationCount(arrangement: String) -> Int {
      var possibleResults = [arrangement: 1]
      
      var total = 0
      
      print(arrangement)
      
      while !possibleResults.isEmpty {
        var newPossibleResults = [String : Int]()
        
        for possibleResult in possibleResults.keys {
          for length in possibleLengthOfPattern {
            let testStr = String(possibleResult.prefix(length))
            if testStr.count == length && availablePatterns.contains(testStr) {
              let remaining = String(possibleResult.dropFirst(length))
              if remaining.isEmpty {
                total += possibleResults[possibleResult]!
              } else {
                if let _ = newPossibleResults[remaining] {
                  newPossibleResults[remaining]! += possibleResults[possibleResult]!
                } else {
                  newPossibleResults[remaining] = possibleResults[possibleResult]
                }
              }
            }
          }
        }
        
        possibleResults = newPossibleResults
      }
      
      return total
    }
    
    return total
  }
}
