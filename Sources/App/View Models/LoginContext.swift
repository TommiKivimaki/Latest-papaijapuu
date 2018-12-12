//
//  LoginContext.swift
//  App
//
//  Created by Tommi Kivimäki on 09/12/2018.
//

struct LoginContext: Encodable {
  let title = "Log In"
  let loginError: Bool
  
  init(loginError: Bool = false) {
    self.loginError = loginError
  }
}
