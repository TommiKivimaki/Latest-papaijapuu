//
//  CreateMessageContext.swift
//  App
//
//  Created by Tommi Kivimäki on 09/12/2018.
//

import Foundation

struct CreateMessageContext: Encodable {
  let title = "Add a Message"
  let editing = false // Flag to tell createMessage.leaf that this context is NOT for editing
  let userLoggedIn: Bool
}
