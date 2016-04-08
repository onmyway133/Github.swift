//
//  NSURL+Extensions.swift
//  GithubSwift
//
//  Created by Khoa Pham on 08/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public extension NSURL {
  
  // Parses the URL's query string into a set of key-value pairs.
  //
  // Returns a (possibly empty) dictionary of the URL's query arguments. Keys
  // without a value will be associated with `NSNull` in the dictionary. If there
  // are multiple keys with the same name, it's unspecified which one's value will
  // be used.
  public var queryArguments: [String: String] {
    let separatorSet = NSCharacterSet(charactersInString: "&;")
    let queryComponents = query?.componentsSeparatedByCharactersInSet(separatorSet) ?? []
    
    var queryArguments: [String: String] = [:]
    queryComponents
      .filter({!$0.isEmpty})
      .forEach { component in
      
        let parts = component.componentsSeparatedByString("=")
        let key = parts.first?.stringByRemovingPercentEncoding ?? ""
        if parts.count > 1 {
          let value = parts.last?.stringByRemovingPercentEncoding ?? ""
          queryArguments[key] = value
        }
    }
    
    return queryArguments
  }
}
