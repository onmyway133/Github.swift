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
  
  static func authorizationHeader(username: String, password: String) -> (key: String, value: String)? {
    guard let data = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
    
    let base64 = data.base64EncodedStringWithOptions([])
    return (key: "Authorization", value: "Basic \(base64)")
  }
  
  /// Retrieves the valid perPage according to the original perPage.
  ///
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns the valid perPage.
  static func perPage(perPage: Int) -> Int {
    if perPage == 0 || perPage > 100 {
      return 30
    }
    
    return perPage
  }
  
  /// Retrieves the corresponding page according to the offset and the valid perPage.
  ///
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns the corresponding page.
  static func page(offset offset: Int, perPage: Int) -> Int {
    return offset / perPage + 1
  }

  /// Retrieves the corresponding pageOffset according to the offset and the valid perPage.
  ///
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns the corresponding pageOffset
  static func pageOffset(offset offset: Int, perPage: Int) -> Int {
    return offset % perPage
  }
}
