//
//  Client+Event.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Construction

public extension Client {

  // Conditionally fetches events from the current user's activity stream. If
  // the latest data matches `etag`, the call does not count toward the API rate
  // limit.
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  //
  // Returns a signal which will send zero or more OCTResponses (of OCTEvents) if
  // new data was downloaded. Unrecognized events will be omitted from the result.
  // On success, the signal will send completed regardless of whether there was
  // new data. If no `user` is set, the signal will error immediately.
  public func fetchUserEvents(etag: String? = nil,
                              offset: Int = 0, perPage: Int = Constant.defaultPerPage) -> Observable<[Event]> {
    if !isAuthenticated {
      return Observable<[Event]>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "users/\(user?.login ?? "")/received_events"
      $0.offset = offset
      $0.perPage = perPage
      $0.etag = etag
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  /// Fetches the performed events for the specified `user`.
  ///
  /// user    - The specified user. This must not be nil.
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns a signal which sends zero or more OCTEvent objects.
  public func fetchPerformedEvents(user: User, offset: Int, perPage: Int) -> Observable<[Event]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "users/\(user.login)/received_events"
      $0.offset = offset
      $0.perPage = perPage
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }
}
