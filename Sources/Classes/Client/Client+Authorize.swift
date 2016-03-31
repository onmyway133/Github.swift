//
//  Client+Authorize.swift
//  GithubSwift
//
//  Created by Khoa Pham on 27/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public extension Client {
  
  // The scopes for authorization. These can be bitwise OR'd together to request
  // multiple scopes.
  //
  // static let PublicReadOnly   - Public, read-only access.
  // static let UserEmail        - Read-only access to the user's
  //                                                email.
  // static let UserFollow       - Follow/unfollow access.
  // static let User             - Read/write access to profile
  //                                                info. This includes static let UserEmail and
  //                                                static let UserFollow
  // static let RepositoryStatus - Read/write access to public
  //                                                and private repository
  //                                                commit statuses. This allows
  //                                                access to commit statuses
  //                                                without access to the
  //                                                repository's code.
  // static let PublicRepository - Read/write access to public
  //                                                repositories and orgs. This
  //                                                includes static let RepositoryStatus.
  // static let Repository       - Read/write access to public
  //                                                and private repositories and
  //                                                orgs. This includes static let RepositoryStatus.
  // static let RepositoryDelete - Delete access to adminable
  //                                                repositories.
  // static let Notifications    - Read access to the user's
  //                                                notifications.
  // static let Gist             - Write access to the user's
  //                                                gists.
  // static let PublicKeyRead    - Read-only access to the user's public SSH keys.
  // static let PublicKeyWrite   - Read/write access to the user's public SSH keys. This
  //                                                includes static let PublicKeyRead.
  // static let PublicKeyAdmin   - Full administrative access to the user's public SSH keys,
  //                                                including permission to delete them. This includes
  //                                                static let PublicKeyWrite.
  public struct AuthoriztionScopes: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
    
    static let PublicReadOnly = AuthoriztionScopes(rawValue: 1 << 0)
    
    static let UserEmail = AuthoriztionScopes(rawValue: 1 << 1)
    static let UserFollow = AuthoriztionScopes(rawValue: 1 << 2)
    static let User = AuthoriztionScopes(rawValue: 1 << 3)
    
    static let RepositoryStatus = AuthoriztionScopes(rawValue: 1 << 4)
    static let PublicRepository = AuthoriztionScopes(rawValue: 1 << 5)
    static let Repository = AuthoriztionScopes(rawValue: 1 << 6)
    static let RepositoryDelete = AuthoriztionScopes(rawValue: 1 << 7)
    
    static let Notifications = AuthoriztionScopes(rawValue: 1 << 8)
    
    static let Gist = AuthoriztionScopes(rawValue: 1 << 9)
    
    static let PublicKeyRead = AuthoriztionScopes(rawValue: 1 << 10)
    static let PublicKeyWrite = AuthoriztionScopes(rawValue: 1 << 11)
    static let PublicKeyAdmin = AuthoriztionScopes(rawValue: 1 << 12)
  }
}