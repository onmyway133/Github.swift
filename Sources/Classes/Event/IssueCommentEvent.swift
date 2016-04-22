//
//  IssueCommentEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A user commented on an issue.
public class IssueCommentEvent: Event {

  // The comment that was posted.
  public private(set) var comment: IssueComment?

  // The issue upon which the comment was posted.
  public private(set) var issue: Issue?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.comment <- map.path("payload")?.relation("comment")
    self.issue <- map.path("payload")?.relation("issue")
  }
}
