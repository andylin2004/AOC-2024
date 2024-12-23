import Algorithms

struct Day23: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var links: [(String, String)] {
    data.split(separator: "\n").compactMap { line in
      let components = line.split(separator: "-").compactMap({String($0)})
      return (components[0], components[1])
    }
  }
  
  var computers = [String: Computer]()

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let tComputers = computers.filter { kvPair in
      kvPair.key.hasPrefix("t")
    }
    
    var trios = Set<Set<Computer>>()
    
    for tComputer in tComputers {
      for connection in tComputer.value.connections.combinations(ofCount: 2) {
        if connection[0].connections.contains(tComputer.value) && connection[1].connections.contains(tComputer.value) && connection[0].connections.contains(connection[1]) && connection[1].connections.contains(connection[0]) {
          trios.insert(Set([tComputer.value, connection[0], connection[1]]))
        }
      }
    }
    
    return trios.count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let allComputers = Set(computers.values)
    
    var candidates = [Set<Computer>: Candidate]()
    
    for computer in computers {
      for connection in computer.value.connections.combinations(ofCount: 2) {
        if connection[0].connections.contains(computer.value) && connection[1].connections.contains(computer.value) && connection[0].connections.contains(connection[1]) && connection[1].connections.contains(connection[0]) {
          let set = Set([computer.value, connection[0], connection[1]])
          candidates[set] = (Candidate(computers: set, bannedComputers: []))
        }
      }
    }
    
    while !candidates.isEmpty {
      var newCandidates = [Set<Computer>: Candidate]()
      
      for candidate in candidates {
        let otherPotentialComputer = allComputers.subtracting(candidate.value.computers).subtracting(candidate.value.bannedComputers)
        var bannedComputers = candidate.value.bannedComputers
        
        for computer in otherPotentialComputer {
          if Set(candidate.value.computers.compactMap({$0.connections.contains(computer)})).contains(false) && !computer.connections.isSuperset(of: candidate.value.computers) {
            bannedComputers.insert(computer)
          } else {
            let newSet = candidate.value.computers.union([computer])
            let newCandidate = Candidate(computers: newSet, bannedComputers: bannedComputers)
            if let existing = newCandidates[newSet] {
              if bannedComputers.count > existing.bannedComputers.count {
                newCandidates[newSet] = newCandidate
              }
            } else {
              newCandidates[newSet] = newCandidate
            }
          }
        }
      }
      
      if !newCandidates.isEmpty {
        candidates = newCandidates
      } else {
        break
      }
    }
    
    let uniqueSets = Set(candidates.keys)
    
    return uniqueSets.first!.compactMap({$0.name}).sorted().joined(separator: ",")
  }
  
  class Computer: @unchecked Sendable, Hashable {
    static func == (lhs: Day23.Computer, rhs: Day23.Computer) -> Bool {
      return lhs.name == rhs.name && lhs.connections == rhs.connections
    }
    
    let name: String
    var connections = Set<Computer>()
    
    init(name: String) {
      self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(name)
    }
    
    var description: String {
      name
    }
  }
  
  struct Candidate: Hashable {
    let computers: Set<Computer>
    let bannedComputers: Set<Computer>
  }
  
  init(data: String) {
    self.data = data
    
    for link in links {
      let computerA = {
        if let computer = computers[link.0] {
          return computer
        } else {
          computers[link.0] = Computer(name: link.0)
          return computers[link.0]!
        }
      }()
      let computerB = {
        if let computer = computers[link.1] {
          return computer
        } else {
          computers[link.1] = Computer(name: link.1)
          return computers[link.1]!
        }
      }()
      
      computerA.connections.insert(computerB)
      computerB.connections.insert(computerA)
    }
  }
}
