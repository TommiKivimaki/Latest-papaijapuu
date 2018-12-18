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

/// Authentication
extension User: BasicAuthenticatable {
  static var usernameKey: WritableKeyPath<User, String> {
    return \User.username
  }
  static var passwordKey: WritableKeyPath<User, String> {
    return \User.password
  }
}
extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}
extension User: TokenAuthenticatable {
  typealias TokenType = Token
}


// Permanent admin user
struct AdminUser: Migration {
  typealias Database = PostgreSQLDatabase
  
  static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
    guard let latestSecret = Environment.get("LATESTSECRET") else { fatalError("User credentials missing") }
    let password = try? BCrypt.hash(latestSecret)
    guard let hashedPassword = password else { fatalError("Failed to create Admin user") }
    let user = User(name: "Admin", username: "admin", password: hashedPassword)
    return user.save(on: conn).transform(to: ())
  }
  
  static func revert(on conn: PostgreSQLConnection) -> Future<Void> {
    return .done(on: conn)
  }

  
  
}
