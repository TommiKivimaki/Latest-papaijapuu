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
  }
  
  func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
    return User.query(on: req).decode(data: User.Public.self).all()
  }
  
  func loginHandler(_ req: Request) throws -> Future<Token> {
    let user = try req.requireAuthenticated(User.self)
    let token = try Token.generate(for: user)
    return token.save(on: req)
  }
  
}
