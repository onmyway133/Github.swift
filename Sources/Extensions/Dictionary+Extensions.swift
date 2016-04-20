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

  func `enum`<T: RawRepresentable>(name: String) -> T? {
    guard let key = name as? Key,
      value = self[key] as? T.RawValue else { return nil }

    return T(rawValue: value)
  }
}
