//
//  EditMessageContext.swift
//  App
//
//  Created by Tommi Kivimäki on 10/12/2018.
//

import Foundation

struct EditMessageContext: Encodable {
  let title = "Edit Message"
  let message: Message
  let editing = true // Flag to tell createMessage.leaf that this context is for editing
  let userLoggedIn: Bool
}
