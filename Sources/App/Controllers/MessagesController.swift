//
//  LatestMessagesController.swift
//  App
//
//  Created by Tommi Kivimäki on 08/12/2018.
//

import Vapor
import Fluent

struct MessagesController: RouteCollection {
  func boot(router: Router) throws {
    let messagesRoute = router.grouped("api", "v1", "messages")
    messagesRoute.get(use: getAllHandler)
    messagesRoute.post(MessageCreateData.self, use: createHandler)
    
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
