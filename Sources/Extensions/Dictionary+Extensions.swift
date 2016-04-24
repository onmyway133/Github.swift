//
//  Dictionary+Extensions.swift
//  GithubSwift
//
//  Created by Khoa Pham on 03/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

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

public extension Dictionary {
  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object, considering hierarchy, otherwise it returns nil
   */
  func relationHierarchically<T where T: Mappable, T: HierarchyType>(name: String) -> T? {
    guard let value = self[name as! Key],
      dictionary = value as? JSONDictionary
      else { return nil }

    return T.cluster(dictionary) as? T
  }

  /**
   - Parameter name: The name of the property that you want to map
   - Returns: A mappable object array, considering hierarchy, otherwise it returns nil
   */
  func relationsHierarchically<T where T: Mappable, T: HierarchyType>(name: String) -> [T]? {
    guard let key = name as? Key,
      value = self[key],
      array = value as? JSONArray
      else { return nil }

    return array.flatMap { T.cluster($0) as? T }
  }
}
