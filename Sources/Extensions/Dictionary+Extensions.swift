//
//  Dictionary+Extensions.swift
//  GithubSwift
//
//  Created by Khoa Pham on 03/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public extension Dictionary {
  mutating func update(other: Dictionary) {
    for (key, value) in other {
      self.updateValue(value, forKey: key)
    }
  }
}

public protocol OptionalType {
  associatedtype Wrapped
  var asOptional : Wrapped? { get }
}

extension Optional : OptionalType {
  public var asOptional : Wrapped? {
    return self
  }
}

public extension Dictionary where Value: OptionalType {
  func dropNils() -> Dictionary<String, AnyObject> {

    var result: [String: AnyObject] = [:]

    forEach {
      if let unwrapped = $1.asOptional as? AnyObject, key = $0 as? String {
        result[key] = unwrapped
      }
    }

    return result
  }
}
