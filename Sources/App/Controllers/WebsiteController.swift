//
//  WebsiteController.swift
//  App
//
//  Created by Tommi Kivimäki on 09/12/2018.
//

import Vapor
import Leaf

struct WebsiteController: RouteCollection {
  func boot(router: Router) throws {
    router.get(use: indexHandler)
    router.get("messages", "create", use: createMessageHandler)
    router.post(CreateMessageData.self, at: "messages", "create", use: createMessagePostHandler)
  }
  
  
  func indexHandler(_ req: Request) throws -> Future<View> {
    return Message.query(on: req).all().flatMap(to: View.self) { messages in
      let messageData = messages.isEmpty ? nil : messages
      let context = IndexContext(messages: messageData)
      return try req.view().render("index", context)
    }
  }
  
  func createMessageHandler(_ req: Request) throws -> Future<View> {
    return try req.view().render("createComment")
  }
  
  func createMessagePostHandler(_ req: Request, data: CreateMessageData) throws -> Future<Response> {
    let message = Message(message: data.message)
    let redirect = req.redirect(to: "/")
    return message.save(on: req).transform(to: redirect)
  }

}


// Decode createMessagePostHandler request body to this
struct CreateMessageData: Content {
  let message: String
  let csrfToken: String?
}
