import Vapor
import Crypto

struct UsersController: RouteCollection {
  
  func boot(router: Router) throws {
    let usersRoutes = router.grouped("api", "v1", "users")
    
    let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
    let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
    basicAuthGroup.post("login", use: loginHandler)
    
    let tokenAuthMiddleware = User.tokenAuthMiddleware()
    let guardAuthMiddleware = User.guardAuthMiddleware()
    let tokenAuthGroup = usersRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
    tokenAuthGroup.get(use: getAllHandler)
    tokenAuthGroup.get("logout", use: logoutHandler)
  }
  
  func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
    return User.query(on: req).decode(data: User.Public.self).all()
  }
  
  func loginHandler(_ req: Request) throws -> Future<Token> {
    let user = try req.requireAuthenticated(User.self)
    //    let token = try Token.generate(for: user)
    //    return token.save(on: req)
    return try Token
      .query(on: req)
      .filter(\Token.userID, .equal, user.requireID())
      .delete()
      .flatMap(to: Token.self) {
        let token = try Token.generate(for: user)
        return token.save(on: req)
    }
  }
  
  /// Log out user by deleting the bearer token from the table
  func logoutHandler(_ req: Request) throws -> Future<HTTPResponse> {
    let user = try req.requireAuthenticated(User.self)
    return try Token
      .query(on: req)
      .filter(\Token.userID, .equal, user.requireID())
      .delete()
      .transform(to: HTTPResponse(status: .ok))
  }
  
}
