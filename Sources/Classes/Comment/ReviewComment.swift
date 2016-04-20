//
//  ReviewComment.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A review comment is a comment that occurs on a portion of a
// unified diff, such as a commit or a pull request. If the comment
// refers to the entire entity, the path and position properties
// will be nil.
public class ReviewComment: Comment {

  // The relative path of the file being commented on. This
  // will be nil if the comment refers to the entire entity,
  // not a specific path in the diff.
  public private(set) var path: String = ""

  // The current HEAD SHA of the code being commented on.
  public private(set) var commitSHA: String = ""

  // The line index of the code being commented on. This
  // will be nil if the comment refers to the entire review
  // entity (commit/pull request).
  public private(set) var position: Int = 0

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.path <- map.property("path")
    self.commitSHA <- map.property("commit_id")
    self.position <- map.property("position")
  }
}
