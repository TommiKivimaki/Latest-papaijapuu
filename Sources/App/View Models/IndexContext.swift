//
//  IndexContext.swift
//  App
//
//  Created by Tommi Kivimäki on 09/12/2018.
//

import Foundation

struct IndexContext: Encodable {
  let title = "Latest"
  let messages: [Message]?
}
