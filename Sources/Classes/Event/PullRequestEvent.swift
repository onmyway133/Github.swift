//
//  PullRequestEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A pull request was opened or closed or somethin'.
public class PullRequestEvent: Event {

  // The pull request being modified.
  public private(set) var pullRequest: PullRequest?

  // The action that took place upon the pull request.
  public private(set) var action: IssueAction = .Unknown

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.pullRequest <- map.path("payload")?.relation("pull_request")
    self.action <- map.path("payload")?.`enum`("action")
  }
}
