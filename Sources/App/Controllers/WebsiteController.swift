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
    router.get("messages", use: allMessageHandler)
    router.get("messages", Message.parameter, use: singleMessageHandler)
    router.post("messages", Message.parameter, "delete", use: deleteMessageHandler)
    router.get("messages", Message.parameter, "edit", use: editMessageHandler)
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
    let context = CreateMessageContext()
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
    return Message.query(on: req).all().flatMap(to: View.self) { messages in
      let messageData = messages.isEmpty ? nil : messages
      let context = MessagesContext(messages: messageData)
      return try req.view().render("messages", context)
    }
  }
  
  /// Page to show a single message
  func singleMessageHandler(_ req: Request) throws -> Future<View> {
    return try req.parameters.next(Message.self).flatMap(to: View.self) { message in
      let context = MessageContext(title: "Edit message", message: message)
      return try req.view().render("message", context)
    }
  }
  
  /// Receives POST message and deletes a message
  func deleteMessageHandler(_ req: Request) throws -> Future<Response> {
    return try req.parameters.next(Message.self).delete(on: req)
      .transform(to: req.redirect(to: "/messages"))
  }

  /// Shows Edit message page using the createComment.leaf
  func editMessageHandler(_ req: Request) throws -> Future<View> {
    return try req.parameters.next(Message.self).flatMap(to: View.self) { message in
      let context = EditMessageContext(message: message)
      return try req.view().render("createMessage", context)
    }
  }
  
}


// Decode createMessagePostHandler request body to this
struct CreateMessageData: Content {
  let message: String
  let csrfToken: String?
}

