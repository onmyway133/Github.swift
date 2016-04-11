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
}
