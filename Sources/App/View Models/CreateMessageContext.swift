//
//  CreateMessageContext.swift
//  App
//
//  Created by Tommi Kivimäki on 09/12/2018.
//

import Foundation
import Vapor

final class CreateMessageContext: Encodable {
  let title = "Create Message"
  let editing = false // Flag to tell createMessage.leaf that this context is NOT for editing
}
