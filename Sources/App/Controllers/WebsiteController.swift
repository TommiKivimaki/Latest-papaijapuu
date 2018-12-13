//
//  WebsiteController.swift
//  App
//
//  Created by Tommi Kivimäki on 09/12/2018.
//

import Vapor
import Leaf
import Fluent
import Authentication

struct WebsiteController: RouteCollection {
  
  func boot(router: Router) throws {
    router.get(use: indexHandler)
    
    // Routes behind authSessionMiddleware() get the User
    let authSessionRoutes = router.grouped(User.authSessionsMiddleware())
    authSessionRoutes.get("login", use: loginHandler)
    authSessionRoutes.post(LoginPostData.self, at: "login", use: loginPostHandler)
    authSessionRoutes.post("logout", use: logoutHandler)
    
    // Protect routes. Can be accessed only if logged in
    let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<User>(path: "/login"))
    protectedRoutes.get("messages", "create", use: createMessageHandler)
    protectedRoutes.post(CreateMessageData.self, at: "messages", "create", use: createMessagePostHandler)  // Automatically decodes content
    protectedRoutes.get("messages", use: allMessageHandler)
    protectedRoutes.get("messages", Message.parameter, use: singleMessageHandler)
    protectedRoutes.post("messages", Message.parameter, "delete", use: deleteMessageHandler)
    protectedRoutes.get("messages", Message.parameter, "edit", use: editMessageHandler)
    protectedRoutes.post("messages", Message.parameter, "edit", use: editMessagePostHandler) // Needs to manually decode content
    
//    router.get(use: indexHandler)
//    router.get("messages", "create", use: createMessageHandler)
//    router.post(CreateMessageData.self, at: "messages", "create", use: createMessagePostHandler)  // Automatically decodes content
//    router.get("messages", use: allMessageHandler)
//    router.get("messages", Message.parameter, use: singleMessageHandler)
//    router.post("messages", Message.parameter, "delete", use: deleteMessageHandler)
//    router.get("messages", Message.parameter, "edit", use: editMessageHandler)
//    router.post("messages", Message.parameter, "edit", use: editMessagePostHandler) // Needs to manually decode content
//    router.get("login", use: loginHandler)
//    router.post(LoginPostData.self, at: "login", use: loginPostHandler)
  }
  
  /// Index page. This will be embedded to a client site
  func indexHandler(_ req: Request) throws -> Future<View> {
    return Message.query(on: req).all().flatMap(to: View.self) { messages in
      let messageData = messages.isEmpty ? nil : messages
      let context = IndexContext(messages: messageData)
      return try req.view().render("index", context)
    }
  }
  
  /// Page to create messages
  func createMessageHandler(_ req: Request) throws -> Future<View> {
    let userLoggedIn = try req.isAuthenticated(User.self)
    let context = CreateMessageContext(userLoggedIn: userLoggedIn)
    return try req.view().render("createMessage", context)
  }
  
  /// Handles the POST data from a page used to create messages
  func createMessagePostHandler(_ req: Request, data: CreateMessageData) throws -> Future<Response> {
    let message = Message(message: data.message)
    let redirect = req.redirect(to: "/messages")
    return message.save(on: req).transform(to: redirect)
  }
  
  /// Messages page shows messages with links to edit individual messages
  func allMessageHandler(_ req: Request) throws -> Future<View> {
    let userLoggedIn = try req.isAuthenticated(User.self)
    return Message.query(on: req).all().flatMap(to: View.self) { messages in
      let messageData = messages.isEmpty ? nil : messages
      let context = MessagesContext(messages: messageData, userLoggedIn: userLoggedIn)
      return try req.view().render("messages", context)
    }
  }
  
  /// Page to show a single message
  func singleMessageHandler(_ req: Request) throws -> Future<View> {
    let userLoggedIn = try req.isAuthenticated(User.self)
    return try req.parameters.next(Message.self).flatMap(to: View.self) { message in
      let context = MessageContext(title: "Edit message", message: message, userLoggedIn: userLoggedIn)
      return try req.view().render("message", context)
    }
  }
  
  /// Receives POST message and deletes a message
  func deleteMessageHandler(_ req: Request) throws -> Future<Response> {
    return try req.parameters.next(Message.self).delete(on: req)
      .transform(to: req.redirect(to: "/messages"))
  }

  /// Shows "Edit message" page using the createComment.leaf
  func editMessageHandler(_ req: Request) throws -> Future<View> {
    let userLoggedIn = try req.isAuthenticated(User.self)
    return try req.parameters.next(Message.self).flatMap(to: View.self) { message in
      let context = EditMessageContext(message: message, userLoggedIn: userLoggedIn)
      return try req.view().render("createMessage", context)
    }
  }
  
  /// Receives POST messages from "Edit message" page
  func editMessagePostHandler(_ req: Request) throws -> Future<Response> {
    return try flatMap(to: Response.self,
                       req.parameters.next(Message.self),
                       req.content.decode(CreateMessageData.self)) { originalMessage, data in
                        originalMessage.message = data.message
                        return originalMessage.save(on: req).transform(to: req.redirect(to: "/messages"))
    }
  }
  
  /// Show Log In page
  func loginHandler(_ req: Request) throws -> Future<View> {
    let context: LoginContext
    
    if req.query[Bool.self, at: "error"] != nil {
      context = LoginContext(loginError: true)
    } else {
      context = LoginContext(loginError: false)
    }
    
    return try req.view().render("login", context)
  }
  
  /// Process the login data from Log In page
  func loginPostHandler(_ req: Request, userData: LoginPostData) throws -> Future<Response> {
    // Check the user against database and verify the BCrypt hash
    return User.authenticate(username: userData.username, password: userData.password, using: BCryptDigest(), on: req)
      .map(to: Response.self) { user in
        guard let user = user else { return req.redirect(to: "/login?error") }
        try req.authenticateSession(user)
        return req.redirect(to: "/messages")
    }
  }
  
  /// Takes care of the logout POST request
  func logoutHandler(_ req: Request) throws -> Response {
    try req.unauthenticateSession(User.self)
    return req.redirect(to: "/")
  }
  
}


// Decode createMessagePostHandler request body to this
struct CreateMessageData: Content {
  let message: String
  let csrfToken: String?
}

// Data decoded from the login form
struct LoginPostData: Content {
  let username: String
  let password: String
}

