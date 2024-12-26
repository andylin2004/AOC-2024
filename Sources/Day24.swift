import Algorithms
import Collections

struct Day24: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var dataComponents: [String] {
    data.split(separator: "\n\n").compactMap({String($0)})
  }
  
  var context: Context = .release
  
  var defaults = [String: Int]()
  var wires = [String: Wire]()
  var relationships = Set<Relationship>()

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var knownValues = defaults
    
    var relationshipsToCheck = relationships
    while !relationshipsToCheck.isEmpty {
      var futureRelationshipsToCheck = Set<Relationship>()
      for relationship in relationshipsToCheck {
        switch relationship.operation {
        case .AND:
          if knownValues[relationship.lhs] == 1 && knownValues[relationship.rhs] == 1 {
            knownValues[relationship.dest] = 1
          } else if knownValues[relationship.lhs] == 0 || knownValues[relationship.rhs] == 0 {
            knownValues[relationship.dest] = 0
          } else {
            futureRelationshipsToCheck.insert(relationship)
          }
        case .OR:
          if knownValues[relationship.lhs] == 1 || knownValues[relationship.rhs] == 1 {
            knownValues[relationship.dest] = 1
          } else if knownValues[relationship.lhs] == 0 && knownValues[relationship.rhs] == 0 {
            knownValues[relationship.dest] = 0
          } else {
            futureRelationshipsToCheck.insert(relationship)
          }
        case .XOR:
          if let lhs = knownValues[relationship.lhs], let rhs = knownValues[relationship.rhs] {
            if lhs != rhs {
              knownValues[relationship.dest] = 1
            } else {
              knownValues[relationship.dest] = 0
            }
          } else {
            futureRelationshipsToCheck.insert(relationship)
          }
        }
      }
      
      relationshipsToCheck = futureRelationshipsToCheck
    }
    
    return Int(knownValues.keys.filter { key in
      key.first == "z"
    }.sorted().reversed().compactMap { key in
      knownValues[key]?.description
    }.joined(), radix: 2)!
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var flagged = Set<String>()
    
    switch context {
    case .testing:
      for relationship in relationships {
        let lhsSuffix = relationship.lhs.suffix(2)
        let rhsSuffix = relationship.rhs.suffix(2)
        let destSuffix = relationship.dest.suffix(2)
        
        if lhsSuffix != rhsSuffix && lhsSuffix == destSuffix {
          flagged.insert(relationship.rhs)
        } else if lhsSuffix == rhsSuffix && lhsSuffix != destSuffix {
          flagged.insert(relationship.dest)
        } else if lhsSuffix != rhsSuffix && rhsSuffix == destSuffix {
          flagged.insert(relationship.lhs)
        }
      }
    case .release:
      let highRange = (wires.keys.filter { key in
        key.first == "x"
      }).count
      
      for level in 0..<highRange {
        let xWire = wires["x\(String(format: "%02d", level))"]!
        
        var abXORWire: Wire?
        var abANDWire: Wire?
        
        for relationship in xWire.fromRelationships {
          switch relationship.operation {
          case .AND:
            if relationship.dest.first != "z" {
              if level != 0 {
                abANDWire = wires[relationship.dest]
              }
            } else {
              flagged.insert(relationship.dest)
            }
          case .OR:
            break
          case .XOR:
            if level == 0 && relationship.dest != "z00" {
              flagged.insert(relationship.dest)
            } else {
              abXORWire = wires[relationship.dest]
            }
          }
        }
        
        if level != 0 {
          if let relationships = abXORWire?.fromRelationships {
            for relationship in relationships {
              switch relationship.operation {
              case .AND:
                if relationship.dest == "z\(String(format: "%02d", level))" {
                  flagged.insert(relationship.dest)
                }
              case .OR:
                flagged.insert(abXORWire!.name)
              case .XOR:
                if relationship.dest != "z\(String(format: "%02d", level))" {
                  flagged.insert(relationship.dest)
                  flagged.insert("z\(String(format: "%02d", level))")
                }
              }
            }
          }
          
          if let relationships = abANDWire?.fromRelationships {
            for relationship in relationships {
              if relationship.operation == .OR {
                if relationship.dest.first == "z" && level != highRange - 1 {
                  flagged.insert(relationship.dest)
                }
              } else {
                flagged.insert(abANDWire!.name)
              }
            }
          }
        }
      }
    }
    
    let result = flagged.sorted().joined(separator: ",")
    
    return result
  }
  
  struct Relationship: Hashable {
    let lhs: String
    let rhs: String
    let operation: Operation
    let dest: String
  }
  
  enum Operation: String {
    case AND = "AND"
    case OR = "OR"
    case XOR = "XOR"
  }
  
  struct Wire {
    let name: String
    var destRelationships = [Relationship]()
    var fromRelationships = [Relationship]()
  }
  
  init(data: String) {
    self.data = data
    
    dataComponents[0].split(separator: "\n").forEach { line in
      let line = line.split(separator: ": ")
      defaults[String(line[0])] = Int(line[1])
    }
    
    dataComponents[1].split(separator: "\n").forEach { line in
      let line = line.split(separator: " ").compactMap({String($0)})
      let lhs = line[0]
      let operation = Operation(rawValue: line[1])!
      let rhs = line[2]
      let dest = line[4]
      
      if wires[lhs] == nil {
        wires[lhs] = Wire(name: lhs)
      }
      if wires[rhs] == nil {
        wires[rhs] = Wire(name: rhs)
      }
      if wires[dest] == nil {
        wires[dest] = Wire(name: dest)
      }
      
      let relationship = Relationship(lhs: lhs, rhs: rhs, operation: operation, dest: dest)
      wires[lhs]?.fromRelationships.append(relationship)
      wires[rhs]?.fromRelationships.append(relationship)
      wires[dest]?.destRelationships.append(relationship)
      
      relationships.insert(relationship)
    }
  }
  
  init(data: String, context: Context) {
    self.init(data: data)
    self.context = context
  }
  
  enum Context {
    case testing
    case release
  }
  
  enum Location {
    case abXOR
    case abAND
    case abXORCarryXOR
    case abXORCarryAND
  }
}
