//
//  Client+Error.swift
//  GithubSwift
//
//  Created by Khoa Pham on 27/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

public extension Client {
  public enum ErrorCode: Int {
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
}