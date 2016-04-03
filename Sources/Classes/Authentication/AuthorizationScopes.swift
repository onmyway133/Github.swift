//
//  Client+Authorize.swift
//  GithubSwift
//
//  Created by Khoa Pham on 27/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

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
public struct AuthorizationScopes: OptionSetType {
  public let rawValue: UInt
  
  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }
  
  public static let PublicReadOnly = AuthorizationScopes(rawValue: 1 << 0)
  
  public static let UserEmail = AuthorizationScopes(rawValue: 1 << 1)
  public static let UserFollow = AuthorizationScopes(rawValue: 1 << 2)
  public static let User = AuthorizationScopes(rawValue: 1 << 3)
  
  public static let RepositoryStatus = AuthorizationScopes(rawValue: 1 << 4)
  public static let PublicRepository = AuthorizationScopes(rawValue: 1 << 5)
  public static let Repository = AuthorizationScopes(rawValue: 1 << 6)
  public static let RepositoryDelete = AuthorizationScopes(rawValue: 1 << 7)
  
  public static let Notifications = AuthorizationScopes(rawValue: 1 << 8)
  
  public static let Gist = AuthorizationScopes(rawValue: 1 << 9)
  
  public static let PublicKeyRead = AuthorizationScopes(rawValue: 1 << 10)
  public static let PublicKeyWrite = AuthorizationScopes(rawValue: 1 << 11)
  public static let PublicKeyAdmin = AuthorizationScopes(rawValue: 1 << 12)
}

extension AuthorizationScopes: Hashable {
  public var hashValue: Int {
    return Int(self.rawValue)
  }
}

public extension AuthorizationScopes {
  public var mapping: [AuthorizationScopes: String] {
    return [
      .PublicReadOnly: "",
      .UserEmail: "user:email",
      .UserFollow: "user:follow",
      .User: "user",
      .RepositoryStatus: "repo:status",
      .PublicRepository: "public_repo",
      .Repository: "repo",
      .RepositoryDelete: "delete_repo",
      .Notifications: "notifications",
      .Gist: "gist",
      .PublicKeyRead: "read:public_key",
      .PublicKeyWrite: "write:public_key",
      .PublicKeyAdmin: "admin:public_key"
    ]
  }
  
  public var value: String {
    return mapping[self] ?? ""
  }
  
  public var values: [String] {
    return elements().map { $0.value }
  }
}
