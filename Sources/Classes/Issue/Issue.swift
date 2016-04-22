//
//  Issue.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// An issue on a repository.
public class Issue: Object {

  public enum State: String {
    case Open = "open"
    case Closed = "closed"
  }

  // The URL for this issue.
  public private(set) var URL: NSURL?

  // The webpage URL for this issue.
  public private(set) var HTMLURL: NSURL?

  // The title of this issue.
  public private(set) var title: String = ""

  // The pull request that is attached to (i.e., the same as) this issue, or nil
  // if this issue does not have code attached.
  public lazy var pullRequest: PullRequest? = { [unowned self] in
    guard let pullRequestHTMLURL = self.pullRequestHTMLURL else { return nil }

    let json = [
      "id": self.objectID,
      "html_url": pullRequestHTMLURL,
      "title": self.title
    ]

    return PullRequest(json)
  }()

  // The webpage URL for any attached pull request.
  public private(set) var pullRequestHTMLURL: NSURL?

  /// The state of the issue.
  public private(set) var state: State = .Closed

  /// The issue number.
  public private(set) var number: Int = 0

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.URL <- map.transform("url", transformer: NSURL.init(string: ))
    self.HTMLURL <- map.transform("html_url", transformer: NSURL.init(string: ))
    self.title <- map.property("title")
    self.pullRequestHTMLURL <- map.dictionary("pull_request")?.transform("html_url", transformer: NSURL.init(string: ))
    self.state <- map.`enum`("state")
    self.number <- map.property("number")
  }
}
