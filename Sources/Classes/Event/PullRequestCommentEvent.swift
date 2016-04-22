//
//  PullRequestCommentEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A user commented on a pull request.
public class PullRequestCommentEvent: Event {

  // The comment that was posted.
  public private(set) var comment: PullRequestComment?

  // The pull request upon which the comment was posted.
  //
  // This is not set by the events API. It must be fetched and explicitly set in
  // order to be used.
  public private(set) var pullRequest: PullRequest?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.comment <- map.path("payload")?.relation("comment")
    self.pullRequest <- map.path("payload")?.relation("pull_request")
  }
}
