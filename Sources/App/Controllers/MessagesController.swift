//
//  LatestMessagesController.swift
//  App
//
//  Created by Tommi Kivimäki on 08/12/2018.
//

import Vapor
import Fluent
import Authentication

struct MessagesController: RouteCollection {
  
  func boot(router: Router) throws {
    let messagesRoutes = router.grouped("api", "v1", "messages")
    messagesRoutes.post(MessageCreateData.self, use: createHandler)
    
//    let tokenAuthMiddleware = User.tokenAuthMiddleware()
//    let guardAuthMiddleware = User.guardAuthMiddleware()
//    let tokenAuthGroup = messagesRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
//    tokenAuthGroup.get(use: getAllHandler)

    
    let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
    let guardAuthMiddleware = User.guardAuthMiddleware()
    let protected = messagesRoutes.grouped(basicAuthMiddleware, guardAuthMiddleware)
    protected.get(use: getAllHandler)

    
    #warning("TODO: Protect the API routes")
  }
  
  
  func getAllHandler(_ req: Request) throws -> Future<[Message]> {
    return Message.query(on: req).all()
  }
  
  
  func createHandler(_ req: Request, data: MessageCreateData) throws -> Future<Message> {
    let message = Message(message: data.message)
    return message.save(on: req)
  }
  
  
}


// Model for creating a Message
struct MessageCreateData: Content {
  var message: String
}
