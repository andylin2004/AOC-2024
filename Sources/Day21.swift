import Algorithms
import Collections

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
  
  let emptySpaceArrow = (0,0)
  
  let emptySpaceNumPad = (3,0)

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async -> Any {
    var total = 0
    
    await withTaskGroup(of: Int.self) { group in
      for code in codesToEnter {
        group.addTask {
          let numericalPart = Int(code.dropLast())!
          
          var robotNumPadLoc: Character = "A"
          var batchInstructionsToDo = [[Character : Int]]()
          
          for character in code {
            let directionsToNextNum = generateInstructionsToWalkTo(context: .numPad, from: robotNumPadLoc, to: character)
            
            robotNumPadLoc = character
            
            batchInstructionsToDo.append(directionsToNextNum)
            batchInstructionsToDo.append(["A": 1])
          }
          
//          print(batchInstructionsToDo)
          let result = findMostOptimalDirections(steps: batchInstructionsToDo, layers: 2)
          
          let length = result.compactMap({$0.compactMap({$0.values.reduce(0, +)}).reduce(0, +)}).min()!
          print(length, numericalPart)
          print()
          return length * numericalPart
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
    var total = 0
    
    await withTaskGroup(of: Int.self) { group in
      for code in codesToEnter {
        group.addTask {
          let numericalPart = Int(code.dropLast())!
          
          var robotNumPadLoc: Character = "A"
          var batchInstructionsToDo = [[Character : Int]]()
          
          for character in code {
            let directionsToNextNum = generateInstructionsToWalkTo(context: .numPad, from: robotNumPadLoc, to: character)
            
            robotNumPadLoc = character
            
            batchInstructionsToDo.append(directionsToNextNum)
            batchInstructionsToDo.append(["A": 1])
          }
          
//          print(batchInstructionsToDo)
          let result = findMostOptimalDirections(steps: batchInstructionsToDo, layers: 25, consolidateEvery: 2)
          
          let length = result.compactMap({$0.compactMap({$0.values.reduce(0, +)}).reduce(0, +)}).min()!
          print(length, numericalPart)
          print()
          return length * numericalPart
        }
      }
      
      for await result in group {
        total += result
      }
    }

    return total
    
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
  
  func findMostOptimalDirections(steps: [[Character : Int]], layers: Int, consolidateEvery: Int = 2) -> Set<[[Character : Int]]> {
    var layerResult = Set([steps])
    
//    print(layerResult)
    for layerNum in 0..<layers {
      var newLayerResult = Set<[[Character : Int]]>()
      for steps in layerResult {
        var cursorsResults: [([[Character : Int]], Character)] = [([], "A")]
        for step in steps {
          let permutationOfRequiredActions = step.keys.sorted().permutations()
          var thisStepCursorResults = [([[Character : Int]], Character)]()
          
          for cursor in cursorsResults {
            for directions in permutationOfRequiredActions {
              var performedActionStack = cursor.0
              var currentLocation = cursor.1
              var directionStack = Deque(directions)
              var riskOfRobotIssue = true
              
              var alreadyPerformedDirections = Set<Character>()
              
              while let direction = directionStack.popFirst() {
                let curCoord = arrowLocations[currentLocation]
                var potentialTurnPt: (Int, Int) {
                  switch direction {
                  case "<":
                    return (curCoord!.0, curCoord!.1 - step[direction]!)
                  case "^":
                    return (curCoord!.0 - step[direction]!, curCoord!.1)
                  default:
                    return (-1, -1)
                  }
                }
                
                let willStepOnEmptySpace = riskOfRobotIssue && potentialTurnPt == emptySpaceArrow
                
                let directionsToNext = generateInstructionsToWalkTo(context: .arrows, from: currentLocation, to: direction)
                
                if willStepOnEmptySpace {
//                  print("redir layer \(layerNum) \(directions) \(step) \(currentLocation) \(cursorsResults.compactMap(\.0))")
                  
                  let numToMove = step[direction]! - 1
                  
                  if numToMove > 0 {
                    performedActionStack.append(directionsToNext)
                    currentLocation = direction
                    
                    performedActionStack.append(["A": numToMove])
                  }
                  
                  directionStack.append(direction)
                } else if alreadyPerformedDirections.contains(direction) {
                  performedActionStack.append(directionsToNext)
                  currentLocation = direction
                  performedActionStack.append(["A": 1])
                } else {
                  performedActionStack.append(directionsToNext)
                  currentLocation = direction
                  performedActionStack.append(["A": step[direction]!])
                }
                
                alreadyPerformedDirections.insert(direction)
                
                riskOfRobotIssue = false
              }
              
              thisStepCursorResults.append((performedActionStack, currentLocation))
            }
          }
          cursorsResults = thisStepCursorResults
        }
        
//        print(steps, cursorsResults.compactMap({($0.0, $0.0.compactMap({$0.values.reduce(0, +)}).reduce(0, +))}))
        
        newLayerResult.formUnion(cursorsResults.compactMap({$0.0}))
      }
      
      layerResult = newLayerResult
//      print(layerResult.compactMap({($0, $0.compactMap({$0.values.reduce(0, +)}).reduce(0, +))}))
//      print(layerResult.compactMap({($0.compactMap({$0.values.reduce(0, +)}).reduce(0, +), $0.compactMap({$0.compactMap({String(repeating: String($0.key), count: $0.value)}).joined(separator: "")}).joined(separator: ""))}))
      
      if layerNum % consolidateEvery == consolidateEvery - 1 {
        let minLen = layerResult.compactMap({$0.compactMap({$0.values.reduce(0, +)}).reduce(0, +)}).min()
        layerResult = Set(layerResult.filter({$0.compactMap({$0.values.reduce(0, +)}).reduce(0, +) == minLen}))
      }
    }
    
    return layerResult
  }
}
