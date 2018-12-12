import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

final class User: Codable {
  var id: UUID?
  var name: String
  var username: String
  var password: String
  
  init(name: String, username: String, password: String) {
    self.name = name
    self.username = username
    self.password = password
  }
  
  // Public view of the user without password
  final class Public: Codable {
    var id: UUID?
    var name: String
    var username: String
    
    init(id: UUID?, name: String, username: String) {
      self.id = id
      self.name = name
      self.username = username
    }
  }
}


extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}


// Convert User to User.Public
extension User {
  func convertToPublic() -> User.Public {
    return User.Public(id: id, name: name, username: username)
  }
}

extension Future where T: User {
  func convertToPublic() -> Future<User.Public> {
    return self.map(to: User.Public.self) { user in
      return user.convertToPublic()
    }
  }
}

extension User.Public: Content {}
