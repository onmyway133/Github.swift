//
//  Client+Key.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Construction

public extension Client {

  // Fetches the public keys for the current `user`.
  //
  // Returns a signal which sends zero or more OCTPublicKey objects. Unverified
  // keys will only be included if the client is `authenticated`. If no `user` is
  // set, the signal will error immediately.
  public func fetchPublicKeys() -> Observable<[PublicKey]> {
    if !isAuthenticated {
      return Observable<[PublicKey]>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "/keys"
    }

    return enqueueUser(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  // Adds a new public key to the current user's profile.
  //
  // Returns a signal which sends the new OCTPublicKey. If the client is not
  // `authenticated`, the signal will error immediately.
  public func postPublicKey(key: String, title: String) -> Observable<PublicKey> {
    if !isAuthenticated {
      return Observable<PublicKey>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor: RequestDescriptor = construct {
      $0.method = .POST
      $0.path = "user/keys"
      $0.parameters = [
        "key": key,
        "title": title
      ]
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  } 
}
