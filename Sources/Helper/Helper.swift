//
//  Helper.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public struct Helper {
  static func nextPageURL(response: NSHTTPURLResponse) -> NSURL? {
    guard let linksString = response.allHeaderFields["Link"] as? String where !linksString.isEmpty else { return nil }
    
    let set = NSMutableCharacterSet(charactersInString: "<>")
    set.formUnionWithCharacterSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    for link in linksString.split(",") {
      guard let semicolonRange = link.rangeOfString(";") else { return nil }
      
      let URLString = link.substringToIndex(semicolonRange.startIndex).stringByTrimmingCharactersInSet(set)
      
      guard !link.isEmpty && link.contains("next") else { return nil }
      
      return NSURL(string: URLString)
    }
    
    return nil
  }
}
