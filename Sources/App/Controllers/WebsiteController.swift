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
  }
  
  
  func indexHandler(_ req: Request) throws -> Future<View> {
//    let context = IndexContext()
//    return try req.view().render("index", context)
    return Message.query(on: req).all().flatMap(to: View.self) { messages in
      let messageData = messages.isEmpty ? nil : messages
      let context = IndexContext(messages: messageData)
      return try req.view().render("index", context)
    }
  }
  
  
//  func indexHandler(_ req: Request) throws -> Future<View> {
//    // Check if request contains authenticated user
//    let userLoggedIn = try req.isAuthenticated(User.self)
//    return UserComment.query(on: req)
//      .all()
//      .flatMap(to: View.self) { userComments in
//        let userCommentsData = userComments.isEmpty ? nil : userComments
//        // Check if cookies-accepted exists
//        let showCookieMessage = req.http.cookies["cookies-accepted"] == nil
//        let context = IndexContext(title: "Comment Box", userLoggedIn: userLoggedIn, userComments: userCommentsData, showCookieMessage: showCookieMessage)
//        return try req.view().render("index", context)
//    }
//  }

}
