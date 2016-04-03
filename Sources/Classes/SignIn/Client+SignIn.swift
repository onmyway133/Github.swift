//
//  Client+SignIn.swift
//  GithubSwift
//
//  Created by Khoa Pham on 03/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {
  
  // Attempts to authenticate as the given user.
  //
  // Authentication is done using a native OAuth flow. This allows apps to avoid
  // presenting a webpage, while minimizing the amount of time the client app
  // needs the user's password.
  //
  // If `user` has two-factor authentication turned on and `oneTimePassword` is
  // not provided, the authorization will be rejected with an error whose `code` is
  // `OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired`. The behavior
  // then depends on the `OCTClientOneTimePasswordMedium` that the user has set:
  //
  //  * If the user has chosen SMS as their authentication method, they will be
  //    sent a one-time password _each time_ this method is invoked.
  //  * If the user has chosen to use an app for authentication, they must open
  //    their chosen app and use the one-time password it presents.
  //
  // You can then invoke this method again to request authorization using the
  // one-time password entered by the user.
  //
  // **NOTE:** You must invoke +setClientID:clientSecret: before using this
  // method.
  //
  // user            - The user to authenticate as. The `user` property of the
  //                   returned client will be set to this object. This must not be nil.
  // password        - The user's password. Cannot be nil.
  // oneTimePassword - The one-time password to approve the authorization request.
  //                   This may be nil if you have no one-time password to
  //                   provide, which will usually be the case unless you've
  //                   already requested authorization, `user` has two-factor
  //                   authentication on, and the user has entered their one-time
  //                   password.
  // scopes          - The scopes to request access to. These values can be
  //                   bitwise OR'd together to request multiple scopes.
  // note            - A human-readable string to remind the user what this OAuth
  //                   token is used for. May be nil.
  // noteURL         - A URL to remind the user what the OAuth token is used for.
  //                   May be nil.
  // fingerprint     - A unique string to distinguish one authorization from
  //                   others created for the same client ID and user. May be nil.
  //
  // Returns a signal which will send an OCTClient then complete on success, or
  // else error. If the server is too old to support this request, an error will
  // be sent with code `OCTClientErrorUnsupportedServer`.
  public static func signIn(user user: User, password: String,
                                 oneTimePassword: String?, scopes: AuthorizationScopes,
                                 note: String? = nil, noteURL: NSURL? = nil,
                                 fingerprint: String? = nil) -> Observable<Client> {
    
    let clientID = Client.Config.clientID
    let clientSecret = Client.Config.clientSecret
    
    assert(!clientID.isEmpty)
    assert(!clientSecret.isEmpty)
    assert(!password.isEmpty)
    
    // Request Descriptor
    let path = "authorizations/clients/\(clientID)"
    let params = [
      "scopes": scopes.values.joinWithSeparator(","),
      "client_secret": clientSecret,
      "note": note ?? "",
      "note_url": noteURL?.absoluteString ?? "",
      "fingerprint": fingerprint ?? ""
    ]
    
    let requestDescriptor = RequestDescriptor().then {
      $0.method = .PUT
      $0.path = path
      $0.parameters = params
      $0.headers = [
        "Accept": "application/vnd.github.\(Client.Constant.miragePreviewAPIVersion)+json"
      ]
      
      if let (key, value) = Helper.authorizationHeader(user.rawLogin, password: password) {
        $0.headers[key] = value
      }
    }

    // Authorize
    func authorize(user: User) -> Observable<(Client, Authorization)> {
      return Observable<(Client, Authorization)>.deferred {
        let client = Client(unauthenticatedUser: user)
        
        let observable = client.enqueue(requestDescriptor).map {
          return Parser.one($0.jsonArray) as Authorization
        }
      
        return Observable.combineLatest(Observable<Client>.just(client), observable) {
          return ($0, $1)
        }
      }
    }
    
    return
      authorize(user)
      .flatMap { (client: Client, authorization: Authorization) in
      
        // To increase security, tokens are no longer returned when the authorization
        // already exists. If that happens, we need to delete the existing
        // authorization for this app and create a new one, so we end up with a token
        // of our own.
        //
        // The `fingerprint` field provided will be used to ensure uniqueness and
        // avoid deleting unrelated tokens.
        if authorization.token.isEmpty {
          var requestDescriptor = requestDescriptor
          requestDescriptor.then {
            $0.path = "authorizations/\(authorization.objectID)"
            $0.method = .DELETE
            
            if let oneTimePassword = oneTimePassword {
              $0.headers[Client.Constant.oneTimePasswordHeaderField] = oneTimePassword
            }
          }
          
          return client.enqueue(requestDescriptor).flatMap { _ in
            return authorize(user)
          }
        } else {
          return Observable<(Client, Authorization)>.just((client, authorization))
        }
      }
      .catchError { error in
        let error = error as NSError
        
        return Observable<(Client, Authorization)>.error(error)
      }
      .map { (client: Client, authorization: Authorization) in
        client.token = authorization.token
        
        return client
      }
      .debug("+signInAsUser: \(user) password:oneTimePassword:scopes:")
  }
}
