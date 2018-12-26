import Vapor
import FluentPostgreSQL

struct AddTimestampToMessage: Migration {
  typealias Database = PostgreSQLDatabase
  
  static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
    return Database.update(Message.self, on: conn) { builder in
      builder.field(for: \.timestamp)
    }
  }
  
  static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
    return Database.update(Message.self, on: conn) { builder in
      builder.deleteField(for: \.timestamp)
    }
  }
  
  
  
}
