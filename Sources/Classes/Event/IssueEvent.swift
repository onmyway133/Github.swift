//
//  IssueEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// The type of action performed on an issue or pull request.
//
// OCTIssueActionUnknown      - An unknown action occurred. Issue events will
//                              never be initialized with this value -- they
//                              will simply fail to be created.
// OCTIssueActionOpened       - The issue or pull request was opened.
// OCTIssueActionClosed       - The issue or pull request was closed.
// OCTIssueActionReopened     - The issue or pull request was reopened.
// OCTIssueActionSynchronized - Only available on pull request events. This
//                              action occurs when a pull request is forcibly
//                              sync'd with the underlying git state after a
//                              failed hook or a force push.

public enum IssueAction: String {
  case Unknown
  case Opened = "opened"
  case Closed = "closed"
  case Reopened = "reopened"
  case Synchronized = "synchronized"
}

// An issue was opened or closed or somethin'.
public class IssueEvent: Event {

  // The issue being modified.
  public private(set)  var issue: Issue?

  // The action that took place upon the issue.
  public private(set) var action: IssueAction = .Unknown

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.issue <- map.path("payload")?.relation("issue")
    self.action <- map.path("payload")?.`enum`("action")
  }
}
