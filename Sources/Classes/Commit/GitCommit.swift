//
//  GitCommit.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A git commit.
public class GitCommit: Object {

  public required init(_ map: JSONDictionary) {
    super.init(map)
  }
}
