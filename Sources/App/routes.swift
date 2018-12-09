import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
//    router.get { req in
//        return "It works!"
//    }
  
  /// MessageController for the API
  let messageController = MessagesController()
  try router.register(collection: messageController)
  
  /// Controller for the web site
  let websiteController = WebsiteController()
  try router.register(collection: websiteController)


}
