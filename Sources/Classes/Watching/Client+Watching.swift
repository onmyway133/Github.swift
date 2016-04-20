//
//  Client+Watching.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {

  /// Stops watching the repository.
  ///
  /// repository - The repository in which to stop watching. This must not be nil.
  //
  /// Returns a signal which will send complete, or error.
  public func stopWatching(repository: Repository) -> Observable<()> {
    if !isAuthenticated {
      return Observable<()>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .DELETE
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/subscription"
    }

    return enqueue(requestDescriptor).map { _ in
      return ()
    }
  }
}
