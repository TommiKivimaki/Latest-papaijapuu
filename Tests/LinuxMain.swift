import XCTest
@testable import AppTests

XCTMain([
  testCase(MessageTests.allTests),
  testCase(UserTests.allTests)
  ])
