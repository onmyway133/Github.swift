//
//  PullRequest.swift
//  GithubSwift
//
//  Created by Khoa Pham on 19/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A pull request on a repository.
public class PullRequest: Object {

  // The state of the pull request. open or closed.
  //
  // OCTPullRequestStateOpen   - The pull request is open.
  // OCTPullRequestStateClosed - The pull request is closed.
  public enum State: String {
    case Open = "open"
    case Closed = "closed"
  }

  // The api URL for this pull request.
  public private(set) var URL: NSURL?

  // The webpage URL for this pull request.
  public private(set) var HTMLURL: NSURL?

  // The diff URL for this pull request.
  public private(set) var diffURL: NSURL?

  // The patch URL for this pull request.
  public private(set) var patchURL: NSURL?

  // The issue URL for this pull request.
  public private(set) var issueURL: NSURL?

  // The user that opened this pull request.
  public private(set) var user: User?

  // The title of this pull request.
  public private(set) var title: String = ""

  // The body text for this pull request.
  public private(set) var body: String = ""

  // The user this pull request is assigned to.
  public private(set) var assignee: User?

  // The date/time this pull request was created.
  public private(set) var creationDate: NSDate?

  // The date/time this pull request was last updated.
  public private(set) var updatedDate: NSDate?

  // The date/time this pull request was closed. nil if the
  // pull request has not been closed.
  public private(set) var closedDate: NSDate?

  // The date/time this pull request was merged. nil if the
  // pull request has not been merged.
  public private(set) var mergedDate: NSDate?

  // The state of this pull request.
  public private(set) var state: State = .Closed

  // The repository that contains the pull request's changes.
  public private(set) var headRepository: Repository?

  // The repository that the pull request's changes should be pulled into.
  public private(set) var baseRepository: Repository?

  /// The name of the branch which contains the pull request's changes.
  public private(set) var headBranch: String = ""

  /// The name of the branch into which the changes will be merged.
  public private(set) var baseBranch: String = ""

  /// The number of commits included in this pull request.
  public private(set) var commits: Int = 0

  /// The number of additions included in this pull request.
  public private(set) var additions: Int = 0

  /// The number of deletions included in this pull request.
  public private(set) var deletions: Int = 0

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.objectID <- map.property("number")

    self.URL <- map.transform("url", transformer: NSURL.init(string: ))
    self.HTMLURL <- map.transform("html_url", transformer: NSURL.init(string: ))
    self.diffURL <- map.transform("diff_url", transformer: NSURL.init(string: ))
    self.patchURL <- map.transform("patch_url", transformer: NSURL.init(string: ))
    self.issueURL <- map.transform("issue_url", transformer: NSURL.init(string: ))
    self.user <- map.relation("user")
    self.title <- map.property("title")
    self.body <- map.property("body")
    self.assignee <- map.relation("assignee")
    self.creationDate <- map.transform("created_at", transformer: Transformer.stringToDate)
    self.updatedDate <- map.transform("updated_at", transformer: Transformer.stringToDate)
    self.closedDate <- map.transform("closed_at", transformer: Transformer.stringToDate)
    self.mergedDate <- map.transform("merged_at", transformer: Transformer.stringToDate)

    self.state <- map.`enum`("state")

    let head = map.dictionary("head")
    let base = map.dictionary("base")

    self.headRepository <- head?.property("repo")
    self.headBranch <- head?.property("ref")
    self.baseRepository <- base?.property("repo")
    self.baseBranch <- base?.property("ref")

    self.commits <- map.property("commits")
    self.additions <- map.property("additions")
    self.deletions <- map.property("deletions")
  }

}
