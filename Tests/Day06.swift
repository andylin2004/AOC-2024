import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day06Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """
  
  let testData2 = """
    .#..
    #..#
    #...
    #...
    #...
    #...
    .^..
    ..#.
    """
  
  let testData3 = """
    .##........
    #.........#
    #..........
    #.....#....
    #....#.....
    #...#......
    ..^........
    .........#.
    """
  
  let testData4 = """
    ...........
    .#.........
    .........#.
    ..#........
    .......#...
    ....#......
    ...#...#...
    ......#....
    ...........
    ........#..
    .^.........
    """
  
  let testData5 = """
    ##..
    ...#
    ....
    ^.#.
    """

  @Test func testPart1() async throws {
    let challenge = Day06(data: testData)
    #expect(String(describing: challenge.part1()) == "41")
  }

  @Test func testPart2() async throws {
    var challenge = Day06(data: testData)
    #expect(String(describing: challenge.part2()) == "6")
//    challenge = Day06(data: testData2)
//    #expect(String(describing: challenge.part2()) == "6")
//    challenge = Day06(data: testData3)
//    #expect(String(describing: challenge.part2()) == "7")
//    challenge = Day06(data: testData4)
//    #expect(String(describing: challenge.part2()) == "5")
    print()
    challenge = Day06(data: testData5)
    #expect(String(describing: challenge.part2()) == "0")
  }
}
