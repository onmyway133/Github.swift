//
//  Client+Error.swift
//  GithubSwift
//
//  Created by Khoa Pham on 27/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar

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
  
  public static func tokenUnsupportedError() -> NSError {
    let userInfo = [
      NSLocalizedDescriptionKey: "Password Required".localized,
      NSLocalizedFailureReasonErrorKey: "You must sign in with a password. Token authentication is not supported.".localized
    ]
    
    return NSError(domain: Client.Constant.errorDomain, code:ErrorCode.TokenAuthenticationUnsupported.rawValue, userInfo: userInfo)
  }
  
  public static func unsupportedVersionError() -> NSError {
    let userInfo = [
      NSLocalizedDescriptionKey: "Unsupported Server".localized,
      NSLocalizedFailureReasonErrorKey: "The request failed because the server is out of date.".localized
    ]
    
    return NSError(domain: Client.Constant.errorDomain, code: ErrorCode.UnsupportedServer.rawValue, userInfo: userInfo)
  }
  
  public static func userRequiredError() -> NSError {
    let userInfo = [
      NSLocalizedDescriptionKey: "Username Required".localized,
      NSLocalizedFailureReasonErrorKey: "No username was provided for getting user information.".localized
    ]
  
    return NSError(domain: Client.Constant.errorDomain, code: ErrorCode.AuthenticationFailed.rawValue, userInfo: userInfo)
  }
  
  public static func openingBrowserError(url: NSURL) -> NSError {
    let userInfo = [
      NSLocalizedDescriptionKey: "Could not open web browser".localized,
      NSLocalizedRecoverySuggestionErrorKey: "Please make sure you have a default web browser set.".localized,
      NSURLErrorKey: url
    ]
    
    return NSError(domain: Client.Constant.errorDomain, code: ErrorCode.OpeningBrowserFailed.rawValue, userInfo: userInfo)
  }
  
  internal static func transform(error: NSError, response: NSHTTPURLResponse?) -> NSError {
    guard let response = response else { return error }
    
    let httpCode = response.statusCode
    var errorCode = ErrorCode.ConnectionFailed.rawValue
    
    var userInfo: JSONDictionary = [:]
   
    userInfo.update(evalutedUserInfo(error, response: response))
    
    switch httpCode {
    case 401:
      let errorTemplate = Error.authenticationRequiredError()
      errorCode = errorTemplate.code
      
      if let info = errorTemplate.userInfo as? JSONDictionary {
        userInfo.update(info)
      }
      
      if let oneTimePassword = response.allHeaderFields[Client.Constant.oneTimePasswordHeaderField] as? String,
        medium = oneTimePasswordMedium(oneTimePassword) {
        
        errorCode = ErrorCode.TwoFactorAuthenticationOneTimePasswordRequired.rawValue
        userInfo[ErrorKey.OneTimePasswordMediumKey.rawValue] = medium.rawValue
      }
    case 400:
      errorCode = ErrorCode.BadRequest.rawValue
    case 403:
      errorCode = ErrorCode.RequestForbidden.rawValue
    case 404:
      errorCode = ErrorCode.NotFound.rawValue
    case 422:
      errorCode = ErrorCode.ServiceRequestFailed.rawValue
    default:
      if error.domain == NSURLErrorDomain {
        switch error.code {
        case NSURLErrorSecureConnectionFailed,
             NSURLErrorServerCertificateHasBadDate,
             NSURLErrorServerCertificateHasUnknownRoot,
             NSURLErrorServerCertificateUntrusted,
             NSURLErrorServerCertificateNotYetValid,
             NSURLErrorClientCertificateRejected,
             NSURLErrorClientCertificateRequired:
          
             errorCode = ErrorCode.SecureConnectionFailed.rawValue
        default:
          break
        }
      }
      
    }
    
//    if (operation.userInfo[OCTClientErrorRequestStateRedirected] != nil) {
//      errorCode = OCTClientErrorUnsupportedServerScheme;
//    }
   
    userInfo[ErrorKey.HTTPStatusCodeKey.rawValue] = httpCode

//    if (operation.request.URL != nil) userInfo[OCTClientErrorRequestURLKey] = operation.request.URL;
//    if (operation.error != nil) userInfo[NSUnderlyingErrorKey] = operation.error;
    
    if let scopes = response.allHeaderFields[Client.Constant.oAuthScopesHeaderField] as? String {
      userInfo[ErrorKey.OAuthScopesStringKey.rawValue] = scopes
    }
    
    return NSError(domain: Client.Constant.errorDomain, code: errorCode, userInfo: userInfo)
  }
  
  private static func evalutedUserInfo(error: NSError, response: NSHTTPURLResponse) -> JSONDictionary {
    // TODO
    return [:]
  }
  
  private static func evaluatedErrorMessage(dict: JSONDictionary) -> String {
    let resource = dict["resource"] as? String ?? ""
    
    if let message = dict["message"] as? String {
      return "• \(resource) \(message).".localized
    } else {
      let field = dict["field"] as? String ?? ""
      let codeType = dict["code"] as? String ?? ""
      
      func format(message: String) -> String {
        return String(format: message, resource, field)
      }
      
      var codeString = format("%@ %@ is missing")
      
      switch codeType {
      case "missing":
        codeString = format("%@ %@ does not exist".localized)
      case "missing_field":
        codeString = format("%@ %@ is missing".localized)
      case "invalid":
        codeString = format("%@ %@ is invalid".localized)
      case "already_exists":
        codeString = format("%@ %@ already exists".localized)
      default:
        break
      }
      
      return "• \(codeString)."
    }
  }
  
  private static func oneTimePasswordMedium(header: String) -> OneTimePasswordMedium? {
    let segments = header.componentsSeparatedByString(";").map {
      return $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    guard segments.count == 2,
      let status = segments.first, medium = segments.last where status.lowercaseString == "required"
      else { return nil }

    return OneTimePasswordMedium(rawValue: medium)
  }
}
