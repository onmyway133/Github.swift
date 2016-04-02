//
//  Transformer.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public struct Transformer {
  public static func numberToString(number: NSNumber?) -> String {
    return number?.stringValue ?? ""
  }
  
  public static func stringToURL(string: String?) -> NSURL? {
    guard let string = string else { return nil }
    
    return NSURL(string: string)
  }
  
  public static func stringToDate(string: String?) -> NSDate? {
    guard let string = string else { return nil }
    
    return Formatter.date(string: string)
  }
}
