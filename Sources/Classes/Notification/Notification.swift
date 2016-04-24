//
//  Notification.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A notification of some type of activity.
public class Notification: Object {

  // The type of the notification.
  //
  // OCTNotificationTypeUnknown     - An unknown type of notification.
  // OCTNotificationTypeIssue       - A new issue, or a new comment on one.
  // OCTNotificationTypePullRequest - A new pull request, or a new comment on one.
  // OCTNotificationTypeCommit      - A new comment on a commit.
  public enum Kind: String {
    case Unknown = ""
    case Issue = "Issue"
    case PullRequest = "PullRequest"
    case Commit = "Commit"
  }
  
  // The title of the notification.
  public private(set) var title: String = ""
  
  // The API URL to the notification's thread.
  public private(set) var threadURL: NSURL?
  
  // The API URL to the subject that the notification was generated for (e.g., the
  // issue or pull request).
  public private(set) var subjectURL: NSURL?
  
  // The API URL to the latest comment in the thread.
  //
  // If the notification does not represent a comment, this will be the same as
  // the subjectURL.
  public private(set) var latestCommentURL: NSURL?
  
  // The notification type.
  public private(set) var kind: Kind = .Unknown
  
  // The repository to which the notification belongs.
  public private(set) var repository: Repository?
  
  // The date on which the notification was last updated.
  public private(set) var lastUpdatedDate: NSDate?
  
  // Whether this notification has yet to be read.
  public private(set) var isUnread: Bool = false
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    let subject = map.dictionary("subject")
    
    self.title <- subject?.property("title")
    self.threadURL <- map.transform("url", transformer: NSURL.init(string: ))
    self.subjectURL <- subject?.transform("url", transformer: NSURL.init(string: ))
    self.latestCommentURL <- subject?.transform("latest_comment_url", transformer: NSURL.init(string: ))
    self.kind = subject?.`enum`("type") ?? .Unknown
    self.repository = map.relation("repository")
    self.lastUpdatedDate = map.transform("updated_at", transformer: Transformer.stringToDate)
  }
}
