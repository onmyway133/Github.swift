//
//  Commit.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A git commit.
public class Commit: Object {

  // The SHA for this commit.
  public private(set) var SHA: String = ""

  // The API URL to the tree that this commit points to.
  public private(set) var treeURL: NSURL?

  // The SHA of the tree that this commit points to.
  public private(set) var treeSHA: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.SHA <- map.property("sha")
    self.treeSHA <- map.path("tree")?.property("sha")
    self.treeURL <- map.path("tree")?.transform("url", transformer: NSURL.init(string: ))
  }
}
