//
//  OptionSetType.swift
//  GithubSwift
//
//  Created by Khoa Pham on 03/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public extension OptionSetType where Element == Self, RawValue : UnsignedIntegerType {
  func elements() -> AnySequence<Self> {
    var rawValue = Self.RawValue(1)
    return AnySequence( {
      return AnyGenerator(body: {
        while rawValue != 0 {
          let candidate = Self(rawValue: rawValue)
          rawValue = rawValue &* 2
          if self.contains(candidate) {
            return candidate
          }
        }
        
        return nil
      })
    })
  }
}
