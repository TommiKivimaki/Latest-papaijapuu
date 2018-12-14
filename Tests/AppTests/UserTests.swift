@testable import App
import Vapor
import XCTest
import FluentPostgreSQL

final class UserTests: XCTestCase {
  
  let usersURI = "/api/v1/users/"
  var app: Application!
  var conn: PostgreSQLConnection!
  
  override func setUp() {
    try! Application.reset()
    app = try! Application.testable()
    conn = try! app.newConnection(to: .psql).wait()
  }
  
  override func tearDown() {
    conn.close()
    try? app.syncShutdownGracefully()
  }
  
  func testGetAllUsers() throws {
    let users = try app.getResponse(to: usersURI, method: .GET, headers: ["Content-Type": "application/json"], decodeTo: [User.Public].self, loggedInRequest: true, loggedInUser: nil)
    
    XCTAssertEqual(users.count, 1)
    XCTAssertEqual(users[0].name, "Admin")
    XCTAssertEqual(users[0].username, "admin")
    XCTAssertNotNil(users[0].id)
  }
  
  
  static let allTests = [
  ("testGetAllUsers", testGetAllUsers)
  ]
}
