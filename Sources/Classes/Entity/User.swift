//
//  User.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A GitHub user.
//
// Users are equal if they come from the same server and have matching object
// IDs, *or* if they were both created with +userWithRawLogin:server: and their
// `rawLogin` and `server` properties are equal.
public class User: Entity {
  
  // The username or email entered by the user.
  //
  // In most cases, this will be the same as the `login`. However, single sign-on
  // systems like LDAP and CAS may have different username requirements than
  // GitHub, meaning that the `login` may not work directly for authentication,
  // or the `rawLogin` may not work directly with the API.
  public internal(set) var rawLogin: String = ""
  
  // Returns a user that has the given name and email address.
  public convenience init(name: String, email: String) {
    let map = [
      "name": name,
      "email": email
    ]
    
    self.init(map)
  }

  // Returns a user with the given username and OCTServer instance.
  public convenience init(rawLogin: String, server: Server) {
    self.init([:])
    
    self.rawLogin = rawLogin
    self.server = server
  }
  
  // MARK: - Hash
  public override var hashValue: Int {
    if objectID.isEmpty {
      return rawLogin.hashValue
    } else {
      return super.hashValue
    }
  }
}
