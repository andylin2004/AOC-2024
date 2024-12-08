import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var splitData: [Substring] {
    data.split(separator: "\n\n").compactMap {
      $0
    }
  }
  
  var rules: [(Int, Int)] {
    splitData[0].split(separator: "\n").compactMap { line in
      let splitLine = line.split(separator: "|").compactMap { half in
        Int(half)
      }
      return (splitLine[0], splitLine[1])
    }
  }
  
  var pagesSetProduced: [[Int]] {
    splitData[1].split(separator: "\n").compactMap { line in
      line.split(separator: ",").compactMap { item in
        Int(item)
      }
    }
  }
  
  var kvPairsAfter = [Int: [Int]]()
  var kvPairsBefore = [Int: [Int]]()

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var total = 0
    
    for pagesSetProduce in pagesSetProduced {
      for i in 0..<pagesSetProduce.count {
        if ({
          if i+1 < pagesSetProduce.count {
            return Set(pagesSetProduce[i+1..<pagesSetProduce.count]).isSubset(of: Set(kvPairsAfter[pagesSetProduce[i]] ?? []))
          } else {
            return true
          }
        }() && {
          if 0 <= i - 1 {
            return Set(pagesSetProduce[0...i-1]).isSubset(of: Set(kvPairsBefore[pagesSetProduce[i]] ?? []))
          } else {
            return true
          }
        }()) {
          if i == pagesSetProduce.count - 1 {
            total += pagesSetProduce[pagesSetProduce.count / 2]
          }
        } else {
          break
        }
      }
    }
    
    return total
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var total = 0
    
    for pagesSetProduce in pagesSetProduced {
      for i in 0..<pagesSetProduce.count {
        if ({
          if i+1 < pagesSetProduce.count {
            return Set(pagesSetProduce[i+1..<pagesSetProduce.count]).isSubset(of: Set(kvPairsAfter[pagesSetProduce[i]] ?? []))
          } else {
            return true
          }
        }() && {
          if 0 <= i - 1 {
            return Set(pagesSetProduce[0...i-1]).isSubset(of: Set(kvPairsBefore[pagesSetProduce[i]] ?? []))
          } else {
            return true
          }
        }()) {
        } else {
          var correctedOrder = [Int]()
          var setRemaining = Set(pagesSetProduce)
          
          while correctedOrder.count < pagesSetProduce.count {
            let permutations = setRemaining.combinations(ofCount: setRemaining.count - 1)
            
            for permutation in permutations {
              let leadNumber = Set(setRemaining).symmetricDifference(Set(permutation)).first!
              
              if Set(permutation).isSubset(of: Set(kvPairsAfter[leadNumber] ?? [])) && Set(correctedOrder[0..<(correctedOrder.count-1 > 0 ? correctedOrder.count-1 : 0)]).isSubset(of: Set(kvPairsBefore[leadNumber] ?? [])) {
                correctedOrder.append(leadNumber)
                setRemaining.remove(leadNumber)
                break
              }
            }
          }
          total += correctedOrder[correctedOrder.count / 2]
          break
        }
      }
    }
    
    return total
  }
  
  init(data: String) {
    self.data = data
    
    for rule in rules {
      if let _ = kvPairsAfter[rule.0] {
        kvPairsAfter[rule.0]?.append(rule.1)
      } else {
        kvPairsAfter[rule.0] = [rule.1]
      }
      
      if let _ = kvPairsBefore[rule.1] {
        kvPairsBefore[rule.1]?.append(rule.0)
      } else {
        kvPairsBefore[rule.1] = [rule.0]
      }
    }
  }
}
