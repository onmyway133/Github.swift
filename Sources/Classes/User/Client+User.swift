//
//  Client+User.swift
//  GithubSwift
//
//  Created by Khoa Pham on 09/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Sugar

public extension Client {
  // Fetches the full information of the current `user`.
  //
  // Returns a signal which sends a new OCTUser. The user may contain different
  // levels of information depending on whether the client is `authenticated` or
  // not. If no `user` is set, the signal will error immediately.
  public func fetchUserInfo() -> Observable<User> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = ""
    }
    
    return enqueueUser(requestDescriptor).map {
      return Parser.one($0.jsonArray) as User
    }
  }
  
  /// Fetches the full information for the specified `user`.
  ///
  /// user - The specified user. This must not be nil.
  ///
  /// Returns a signal which sends a new OCTUser.
  public func fetchUserInfo(user: User) -> Observable<User> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "/users/\(user.login)"
    }
    
    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray) as User
    }
  }

  /// Fetches the followers for the specified `user`.
  ///
  /// user    - The specified user. This must not be nil.
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns a signal which sends zero or more OCTUser objects.
  public func fetchFollowers(user: User, offset: Int = 0,
                             perPage: Int = Constant.defaultPerPage) -> Observable<[User]> {

    let requestDescriptor = RequestDescriptor().then {
      $0.path = "/users/\(user.login)/followers"
      $0.offset = offset
      $0.perPage = perPage
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  /// Fetches the following for the specified `user`.
  ///
  /// user    - The specified user. This must not be nil.
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns a signal which sends zero or more OCTUser objects.
  public func fetchFollowing(user: User, offset: Int = 0,
                             perPage: Int = Constant.defaultPerPage) -> Observable<[User]> {

    let requestDescriptor = RequestDescriptor().then {
      $0.path = "/users/\(user.login)/following"
      $0.offset = offset
      $0.perPage = perPage
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }
}
