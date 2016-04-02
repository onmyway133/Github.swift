//
//  Client+Error.swift
//  GithubSwift
//
//  Created by Khoa Pham on 27/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public enum ErrorCode: Int {
  case NotFound = 404
  case AuthenticationFailed = 666
  case ServiceRequestFailed = 667
  case ConnectionFailed = 668
  case JSONParsingFailed = 669
  case BadRequest = 670
  case TwoFactorAuthenticationOneTimePasswordRequired = 671
  case UnsupportedServer = 672
  case OpeningBrowserFailed = 673
  case RequestForbidden = 674
  case TokenAuthenticationUnsupported = 675
  case UnsupportedServerScheme = 676
  case SecureConnectionFailed = 677
}

public enum ErrorKey: String {
  case RequestURLKey
  case HTTPStatusCodeKey
  case OneTimePasswordMediumKey
  case OAuthScopesStringKey
  case RequestStateRedirectedKey
  case DescriptionKey
  case MessagesKey
}

public struct Error {
  public static func authenticationRequiredError() -> NSError {
    let userInfo = [
      NSLocalizedDescriptionKey: "Sign In Required".localized,
      NSLocalizedFailureReasonErrorKey: "You must sign in to access user information.".localized
    ]
    
    return NSError(domain: Client.Constant.errorDomain, code: ErrorCode.AuthenticationFailed.rawValue, userInfo: userInfo)
  }
}
