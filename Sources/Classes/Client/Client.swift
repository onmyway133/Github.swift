//
//  Client.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Alamofire

// Represents a single GitHub session.
//
// Most of the methods on this class return a RACSignal representing a request
// made to the API. The returned signal will deliver its results on a background
// RACScheduler.
//
// To avoid hitting the network for a result that won't be used, **no request
// will be sent until the returned signal is subscribed to.** To cancel an
// in-flight request, simply dispose of all subscriptions.
//
// For more information about the behavior of requests, see
// -enqueueRequestWithMethod:path:parameters:resultClass: and
// -enqueueConditionalRequestWithMethod:path:parameters:notMatchingEtag:resultClass:,
// upon which all the other request methods are built.
public class Client {
  
  // The active user for this session.
  //
  // This may be set regardless of whether the session is authenticated or
  // unauthenticated, and will control which username is used for endpoints
  // that require one. For example, this user's login will be used with
  // -fetchUserEventsNotMatchingEtag:.
  public private(set) var user: User?
  
  // The OAuth access token that the client was initialized with.
  //
  // You should protect this token like a password. **Never** save it to disk in
  // plaintext — use the keychain instead.
  //
  // This will be `nil` when the client is created using
  // +unauthenticatedClientWithUser:.
  public internal(set) var token: String?
  
  // Whether this client supports authenticated endpoints.
  //
  // Note that this property does not specify whether the client has successfully
  // authenticated with the server — only whether it will attempt to.
  //
  // This will be NO when `token` is `nil`.
  public var isAuthenticated: Bool {
    return token != nil
  }
  
  // MARK: - Network
  lazy var manager: Manager =  {
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    var headers = Manager.defaultHTTPHeaders
    
    // User Agent
    headers["User-Agent"] = Client.Config.userAgent
    
    // Content Type
    let baseContentType = "application/vnd.github.%@+json"
    let stableContentType =  String(format: baseContentType, Client.Constant.apiVersion)
    let previewContentType = String(format: baseContentType, Client.Constant.miragePreviewAPIVersion)
    let moondragonPreviewContentType = String(format: baseContentType, Client.Constant.moondragonPreviewAPIVersion)
    
    headers["Accept"] = [stableContentType, previewContentType, moondragonPreviewContentType].joinWithSeparator(",")
    
    // Headers
    configuration.HTTPAdditionalHeaders = headers
  
    return Manager(configuration: configuration)
    
  }()
  
  let baseURL: NSURL
  
  
  // Initializes the receiver to make requests to the given GitHub server.
  //
  // When using this initializer, the `user` property will not be set.
  // +authenticatedClientWithUser:token: or +unauthenticatedClientWithUser:
  // should typically be used instead.
  //
  // server - The GitHub server to connect to. This argument must not be nil.
  //
  // This is the designated initializer for this class.
  public init(server: Server) {
    baseURL = server.APIEndpoint
  }
  
  // Creates a client which can access any endpoints that don't require
  // authentication.
  //
  // user - The active user. The `user` property of the returned client will be
  //        set to this object. This must not be nil.
  //
  // Returns a new client.
  public convenience init(unauthenticatedUser: User) {
    self.init(server: unauthenticatedUser.server)
    self.user = unauthenticatedUser
  }
  
  // Creates a client which will authenticate as the given user, using the given
  // OAuth token.
  //
  // This method does not actually perform a login or make a request to the
  // server. It only saves authentication information for future requests.
  //
  // user  - The user to authenticate as. The `user` property of the returned
  //         client will be set to this object. This must not be nil.
  // token - An OAuth token for the given user. This must not be nil.
  //
  // Returns a new client.
  public convenience init(authenticatedUser: User, token: String) {
    self.init(server: authenticatedUser.server)
    self.token = token
    self.user = authenticatedUser
  }
}

