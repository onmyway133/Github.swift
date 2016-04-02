//
//  Client+Repository.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Sugar

public extension Client {
  
  // Fetches a specific repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTRepository.
  public func fetchRepository(name name: String, owner: String) -> Observable<Repository> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(owner)/\(name)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }
  
  // Fetches the starred repositories of the current `user`.
  //
  // Returns a signal which sends zero or more OCTRepository objects. Private
  // repositories will only be included if the client is `authenticated`. If no
  // `user` is set, the signal will error immediately.
  public func fetchUserStarredRepositories() -> Observable<[Repository]> {
    let requestDecriptor = RequestDescriptor().then {
      $0.path = "starred"
    }
    
    return enqueueUser(requestDecriptor).map {
      return Parser.all($0.jsonArray)
    }
  }
}
