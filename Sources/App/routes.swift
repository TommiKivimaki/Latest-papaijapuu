import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  
  /// MessageController for the API
  let messageController = MessagesController()
  try router.register(collection: messageController)
  
  /// Controller for the web site
  let websiteController = WebsiteController()
  try router.register(collection: websiteController)
  
  // Controller for the API users
  let usersController = UsersController()
  try router.register(collection: usersController)


}
