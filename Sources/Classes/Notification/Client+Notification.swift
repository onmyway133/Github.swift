//
//  Client+Notification.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Construction

public extension Client {
  
  // Conditionally fetch unread notifications for the user. If the latest data
  // matches `etag`, the call does not count toward the API rate limit.
  //
  // etag        - An Etag from a previous request, used to avoid downloading
  //               unnecessary data.
  // includeRead - Whether to include notifications that have already been read.
  // since       - If not nil, only notifications updated after this date will be
  //               included.
  //
  // Returns a signal which will zero or more OCTResponses (of OCTNotifications)
  // if new data was downloaded. On success, the signal will send completed
  // regardless of whether there was new data. If the client is not
  // `authenticated`, the signal will error immediately.
  public func fetchNotifications(etag etag: String? = nil, includeRead: Bool = false,
                                      updatedSince: NSDate? = nil) -> Observable<[Notification]> {
    
    guard isAuthenticated else {
      return Observable<[Notification]>.error(Error.authenticationRequiredError())
    }
    
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "notifications"
      $0.etag = etag
      $0.parameters = ([
        "all": includeRead,
        "since": updatedSince.map { Formatter.string(date: $0) }
      ] as [String: AnyObject?]).dropNils()
    }
    
    return self.enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  // Mark a notification thread as having been read.
  //
  // threadURL - The API URL of the thread to mark as read. Cannot be nil.
  //
  // Returns a signal which will send completed on success. If the client is not
  // `authenticated`, the signal will error immediately.
  public func markNotificationThreadAsRead(threadURL: NSURL) -> Observable<()> {
    if !isAuthenticated {
      return Observable<()>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor: RequestDescriptor = construct {
      $0.method = .PATCH
      $0.URL = threadURL
      $0.parameters["read"] = true
    }

    return enqueue(requestDescriptor).map { _ in
      return ()
    }
  }

  // Mutes all further notifications from a thread.
  //
  // threadURL - The API URL of the thread to mute. Cannot be nil.
  //
  // Returns a signal which will send completed on success. If the client is not
  // `authenticated`, the signal will error immediately.
  public func muteNotificationThreadAsRead(threadURL: NSURL) -> Observable<()> {
    if !isAuthenticated {
      return Observable<()>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor: RequestDescriptor = construct {
      $0.method = .PUT
      $0.URL = threadURL.URLByAppendingPathComponent("subscription")
      $0.parameters["ignored"] = true
    }

    return enqueue(requestDescriptor).map { _ in
      return ()
    }
  }
}
