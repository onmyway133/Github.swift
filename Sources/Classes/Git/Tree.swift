//
//  Tree.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A git tree.
public class Tree: Object {

  // The SHA of the tree.
  public private(set) var SHA: String = ""

  // The URL for the tree.
  public private(set) var URL: NSURL?

  // The `OCTTreeEntry` objects.
  public private(set) var entries: [TreeEntry] = []

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.SHA <- map.property("sha")
    self.URL <- map.transform("url", transformer: NSURL.init(string: ))
    self.entries <- map.relations("tree")
  }
}
