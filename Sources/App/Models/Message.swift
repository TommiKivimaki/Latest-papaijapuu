//
//  LatestMessage.swift
//  App
//
//  Created by Tommi Kivimäki on 08/12/2018.
//

import Vapor
import FluentPostgreSQL

final class Message: Codable {
  var id: Int?
  var message: String
  
  init(message: String) {
    self.message = message
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
extension Message: Migration {}
extension Message: Parameter {}

