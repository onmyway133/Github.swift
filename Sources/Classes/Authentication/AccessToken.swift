//
//  AccessToken.swift
//  GithubSwift
//
//  Created by Khoa Pham on 03/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// An OAuth access token returned from the web flow.
public class AccessToken: Object {

// The access token itself. You should treat this as you would the user's
// password.
//
// This property will not be serialized to JSON. If you need to persist it, save
// it to the Keychain.
  public private(set) var token: String = ""
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    self.token <- map.property("token")
  }
}
