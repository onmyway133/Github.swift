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
  public static func all<T: Mappable>(response: Response) -> [T] {
    if let hierarchyType = T.self as? HierarchyType {
      return response.jsonArray.flatMap { hierarchyType.dynamicType.cluster($0) as? T }
    } else {
      return response.jsonArray.map { T($0) }
    }
  }
 
  public static func one<T: Mappable>(response: Response) -> T {
    let all: [T] = Parser.all(response)
    assert(!all.isEmpty)
    return all.first!
  }
}
