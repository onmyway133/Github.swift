//
//  HierarchyType.swift
//  GithubSwift
//
//  Created by Khoa Pham on 24/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar

public protocol HierarchyType {
  // FIXME: Prefer to use Self
  static func cluster(map: JSONDictionary) -> AnyObject
}
