//
//  MessagesContext.swift
//  App
//
//  Created by Tommi Kivimäki on 10/12/2018.
//

import Foundation

struct MessagesContext: Encodable {
  let title = "Latest Messages to edit"
  let messages: [Message]?
}
