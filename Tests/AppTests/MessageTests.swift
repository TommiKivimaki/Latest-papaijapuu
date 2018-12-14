@testable import App
import Vapor
import XCTest
import FluentPostgreSQL

final class MessageTests: XCTestCase {
  
  let messagesURI = "/api/v1/messages/"
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
  
  func testCreateAMessage() throws {
    let message = Message(message: "Test comment")
    
    let receivedMessage = try app.getResponse(to: messagesURI, method: .POST, headers: ["Content-Type": "application/json"], data: message, decodeTo: Message.self, loggedInRequest: true, loggedInUser: nil)
   
    XCTAssertEqual(message, receivedMessage)
  }
  
  func testGetAllMessages() throws {
    let message1 = Message(message: "Test message One")
    let message2 = Message(message: "Test message Two")
    
    _ = try app.sendRequest(to: messagesURI, method: .POST, headers: ["Content-Type": "application/json"], body: message1, loggedInRequest: true, loggedInUser: nil)
    _ = try app.sendRequest(to: messagesURI, method: .POST, headers: ["Content-Type": "application/json"], body: message2, loggedInRequest: true, loggedInUser: nil)
    
    let receivedMessages = try app.getResponse(to: messagesURI, method: .GET, headers: ["Content-Type": "application/json"], decodeTo: [Message].self, loggedInRequest: true, loggedInUser: nil)

    XCTAssertEqual(receivedMessages.count, 2)
    XCTAssertEqual(receivedMessages[0], message1)
    XCTAssertEqual(receivedMessages[1], message2)
  }
  
  
  static let allTests = [
  ("testCreateAMessage", testCreateAMessage),
  ("testGetAllMessages", testGetAllMessages)
  ]
}
