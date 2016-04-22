//
//  PullRequestComment.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A single comment on a pull request.
public class PullRequestComment: IssueComment {

  // The API URL for the pull request upon which this comment appears.
  public private(set) var pullRequestAPIURL: NSURL?

  // The HEAD SHA of the pull request when the comment was originally made.
  public private(set) var originalCommitSHA: String = ""

  // This is the line index into the pull request's diff when the
  // comment was originally made.
  public private(set) var originalPosition: Int = 0

  // The hunk in the diff that this comment originally refered to.
  public private(set) var diffHunk: String = ""

  // FIXME: PullRequestComment has some common properties as ReviewComment, so composition ;)
  public private(set) var reviewComment: ReviewComment?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.pullRequestAPIURL <- map.dictionary("_links")?.dictionary("pull_request")?.transform("href", transformer: NSURL.init(string: ))
    self.originalCommitSHA <- map.property("original_commit_id")
    self.originalPosition <- map.property("original_position")
    self.diffHunk <- map.property("diff_hunk")

    self.reviewComment = ReviewComment(map)
  }
}
