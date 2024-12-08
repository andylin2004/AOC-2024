import Algorithms
import Collections

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var lineSplits: [[Substring]] {
    data.split(separator: "\n").compactMap {
      $0.split(separator: ": ")
    }
  }
  
  var answerComposerPairs = [UInt: [[Int]]]()

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var total: UInt = 0
    for pair in answerComposerPairs {
      for values in pair.value {
        if solvable(numbers: values, answer: pair.key) {
          total += UInt(pair.key)
        }
      }
    }
    
    return total
    
    func solvable(numbers: [Int], answer: UInt, indx: Int = 0, currentTotal: Int? = nil) -> Bool {
      if let currentTotal {
        if indx < numbers.count {
          let next = numbers[indx]
          return solvable(numbers: numbers, answer: answer, indx: indx + 1, currentTotal: currentTotal * next) || solvable(numbers: numbers, answer: answer, indx: indx + 1, currentTotal: currentTotal + next)
        } else {
          return currentTotal == answer
        }
      } else {
        return solvable(numbers: numbers, answer: answer, indx: 1, currentTotal: numbers.first)
      }
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var total: UInt = 0
    for pair in answerComposerPairs {
      for values in pair.value {
        if solvable(numbers: values, answer: pair.key) {
          total += UInt(pair.key)
        }
      }
    }
    
    return total
    
    func solvable(numbers: [Int], answer: UInt, indx: Int = 0, currentTotal: Int? = nil) -> Bool {
      if let currentTotal {
        if currentTotal > answer {
          return false
        }
        if indx < numbers.count {
          let next = numbers[indx]
          return solvable(numbers: numbers, answer: answer, indx: indx + 1, currentTotal: currentTotal * next) || solvable(numbers: numbers, answer: answer, indx: indx + 1, currentTotal: currentTotal + next) || solvable(numbers: numbers, answer: answer, indx: indx + 1, currentTotal: Int(String(currentTotal) + String(next)))
        } else {
          return currentTotal == answer
        }
      } else {
        return solvable(numbers: numbers, answer: answer, indx: 1, currentTotal: numbers.first)
      }
    }
  }
  
  init(data: String) {
    self.data = data
    
    for line in lineSplits {
      let key = UInt(line[0])!
      let values = line[1].split(separator: " ").compactMap({Int($0)})
      if answerComposerPairs[key] == nil {
        answerComposerPairs[key] = []
      }
      answerComposerPairs[key]?.append(values)
    }
  }
  
  enum Operation {
    case add
    case multiply
  }
}
