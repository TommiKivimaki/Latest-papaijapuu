//
//  LatestMessage.swift
//  App
//
//  Created by Tommi Kivimäki on 08/12/2018.
//

import Foundation
import Vapor
//import FluentPostgreSQL
import FluentSQLite

final class Message: Codable {
  var id: Int?
  var message: String
  
  init(message: String) {
    self.message = message
  }
}

//extension Message: PostgreSQLModel {}
extension Message: Content {}
// Conform to Fluent's Model
extension Message: SQLiteModel {}
extension Message: Migration {}
extension Message: Parameter {}

