//
//  Client+Activity.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {

  // Check if the user starred the `repository`.
  //
  // repository - The repository used to check the starred status. Cannot be nil.
  //
  // Returns a signal, which will send a NSNumber valued @YES or @NO.
  // If the client is not `authenticated`, the signal will error immediately.
  public func hasUserStarred(repository: Repository) -> Observable<Bool> {
    if !isAuthenticated {
      return Observable<(Bool)>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .PUT
      $0.path = "user/starred/\(repository.ownerLogin)/\(repository.name)"
    }

    return enqueue(requestDescriptor).map {
      return $0.statusCode == 204
    }
  }

  // Star the given `repository`
  //
  // repository - The repository to star. Cannot be nil.
  //
  // Returns a signal, which will send completed on success. If the client
  // is not `authenticated`, the signal will error immediately.
  public func star(repository: Repository) -> Observable<()> {
    if !isAuthenticated {
      return Observable<()>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .PUT
      $0.path = "user/starred/\(repository.ownerLogin)/\(repository.name)"
    }

    return enqueue(requestDescriptor).map { _ in
      return ()
    }
  }

  // Unstar the given `repository`
  //
  // repository - The repository to unstar. Cannot be nil.
  //
  // Returns a signal, which will send completed on success. If the client
  // is not `authenticated`, the signal will error immediately.
  public func unstar(repository: Repository) -> Observable<()> {
    if !isAuthenticated {
      return Observable<()>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .DELETE
      $0.path = "user/starred/\(repository.ownerLogin)/\(repository.name)"
    }

    return enqueue(requestDescriptor).map { _ in
      return ()
    }
  }
}
