//
//  ServerMetadata.swift
//  GithubSwift
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Contains information about a GitHub server (Enterprise or .com).
public class ServerMetadata: Object {
  
  // Whether this server supports password authentication.
  //
  // If this is NO, you must invoke +[OCTClient signInToServerUsingWebBrowser:] to
  // log in to this server.
  private(set) var supportsPasswordAuthentication: Bool = false
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    supportsPasswordAuthentication <- map.property("verifiable_password_authentication")
  }
}