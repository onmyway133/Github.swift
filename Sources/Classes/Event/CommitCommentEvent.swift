//
//  CommitCommentEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A user commented on a commit.
public class CommitCommentEvent: Event {

  // The comment that was posted.
  public private(set) var comment: CommitComment?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.comment <- map.path("payload")?.relation("comment")
  }
}
