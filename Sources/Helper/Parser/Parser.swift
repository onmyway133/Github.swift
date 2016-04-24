//
//  Parser.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

public struct Parser {
  public static func all<T: Mappable>(jsonArray: JSONArray) -> [T] {
    if let hierarchyType = T.self as? HierarchyType {
      return jsonArray.flatMap { hierarchyType.dynamicType.cluster($0) as? T }
    } else {
      return jsonArray.map { T($0) }
    }
  }
 
  public static func one<T: Mappable>(jsonArray: JSONArray) -> T {
    let all: [T] = Parser.all(jsonArray)
    assert(!all.isEmpty)
    return all.first!
  }
}
