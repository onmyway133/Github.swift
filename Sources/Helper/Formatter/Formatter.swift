//
//  Formatter.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import ISO8601
import Sugar

public struct Formatter {
  
  private static let basicFormatter = NSDateFormatter().then {
    $0.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    $0.timeZone = NSTimeZone(abbreviation: "UTC")
  }
  
  public static func date(string string: String) -> NSDate? {
    return NSDate(ISO8601String: string)
  }
  
  
  
  public static func string(date date: NSDate) -> String {
    return basicFormatter.stringFromDate(date)
  }
}
