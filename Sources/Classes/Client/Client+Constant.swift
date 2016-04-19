//
//  Client+Constant.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public struct Constant {

  public static let apiVersion = "v3"

  /// See https://developer.github.com/changes/2014-12-08-removing-authorizations-token/
  public static let miragePreviewAPIVersion = "mirage-preview"

  /// See https://developer.github.com/changes/2014-12-08-organization-permissions-api-preview/
  public static let moondragonPreviewAPIVersion = "moondragon"

  public static let notModifiedStatusCode = 304
  public static let oneTimePasswordHeaderField = "X-GitHub-OTP"
  public static let oAuthScopesHeaderField = "X-OAuth-Scopes"

  // An environment variable that, when present, will enable logging of all
  // responses.
  public static let responseLoggingEnvironmentKey = "LOG_API_RESPONSES"

  // An environment variable that, when present, will log the remaining API calls
  // allowed before the rate limit is enforced.
  public static let rateLimitLoggingEnvironmentKey = "LOG_REMAINING_API_CALLS"

  public static let errorDomain = "GithubErrorDomain"

  public static let defaultPerPage = 100
}
