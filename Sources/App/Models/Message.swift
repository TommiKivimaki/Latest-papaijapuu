//
//  LatestMessage.swift
//  App
//
//  Created by Tommi Kivimäki on 08/12/2018.
//

import Vapor
import FluentPostgreSQL
import Foundation

final class Message: Codable {
  var id: Int?
  var message: String
  var timestamp: Date?
  
  init(message: String, timestamp: Date? = nil) {
    self.message = message
    self.timestamp = timestamp
  }
}

extension Message: Equatable {
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.message == rhs.message
  }
}
extension Message: PostgreSQLModel {}
extension Message: Content {}
// Conform to Fluent's Model
extension Message: Migration {
  
  static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in  // Creates User table
      // Manually add only original fields. If e.g. for testing db is reverted it's important that only the original fields
      // are added in the initial migration.
      builder.field(for: \.id, isIdentifier: true)
      builder.field(for: \.message)
    }
  }
  
  static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
    return Database.delete(Message.self, on: connection)
  }
}
extension Message: Parameter {}

