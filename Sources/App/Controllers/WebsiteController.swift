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
    let context = IndexContext()
    return try req.view().render("index", context)
  }

}
