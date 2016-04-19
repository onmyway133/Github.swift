//
//  Branch.swift
//  GithubSwift
//
//  Created by Khoa Pham on 19/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A GithHub repository branch.
public class Branch: Object {

  // The name of the branch.
  public private(set) var name: String = ""

  // The SHA of the last commit on this branch.
  public private(set) var lastCommitSHA: String = ""

  // The API URL to the last commit on this branch.
  public private(set) var lastCommitURL: NSURL?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.name <- map.property("name")
    self.lastCommitSHA <- map.dictionary("commit")?.property("sha")
    self.lastCommitURL <- map.dictionary("commit")?.transform("url", transformer: Transformer.stringToURL)
  }
}
