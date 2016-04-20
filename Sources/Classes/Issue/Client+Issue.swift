//
//  Client+Issue.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {

  public enum ClientIssueState: String {
    case Open = "open"
    case Closed = "closed"
    case All = "all"
  }

  /// Creates an issue.
  ///
  /// title      - The title of the issue. This must not be nil.
  /// body       - The contents of the issue. This can be nil.
  /// assignee   - Login for the user that this issue should be assigned to. NOTE:
  ///              Only users with push access can set the assignee for new issues.
  //               The assignee is silently dropped otherwise. This can be nil.
  /// milestone  - Milestone to associate this issue with. NOTE: Only users with
  ///              push access can set the milestone for new issues. The milestone
  ///              is silently dropped otherwise. This can be nil.
  /// labels     - Labels to associate with this issue. NOTE: Only users with push
  ///              access can set labels for new issues. Labels are silently dropped
  ///              otherwise. This can be nil.
  /// repository - The repository in which to create the issue. This must not be nil.
  ///
  /// Returns a signal which will send the created `OCTIssue` then complete, or error.
  public func createIssue(title: String, body: String? = nil,
                          assignee: String? = nil, milestone: Int? = nil,
                          labels: [String]? = nil, repository: Repository) -> Observable<Issue> {

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .POST
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/issues"
      $0.parameters = ([
        "title": title,
        "body": body,
        "milestone": milestone,
        "assignee": assignee,
        "labels": labels
      ] as [String: AnyObject?]).dropNils()
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  /// Fetch the issues with the given state from the repository.
  ///
  /// repository - The repository whose issues should be fetched. Cannot be nil.
  /// state      - The state of issues to return.
  /// etag       - An Etag from a previous request, used to avoid downloading
  //               unnecessary data. May be nil.
  /// since      - Only issues updated or created after this date will be fetched.
  ///              May be nil.
  ///
  /// Returns a signal which will send each `OCTResponse`-wrapped `OCTIssue`s and
  /// complete or error.
  public func fetchIssues(repository: Repository, state: ClientIssueState = .All,
                          etag: String? = nil, since: NSDate? = nil) -> Observable<[Issue]> {

    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/issues"
      $0.parameters = ([
        "state": state.rawValue,
        "since": since.map { Formatter.string(date: $0) },
        ] as [String: AnyObject?]).dropNils()
      $0.etag = etag
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }
}
