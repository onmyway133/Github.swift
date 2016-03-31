//
//  Server.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Represents a GitHub server instance
// (ie. github.com or an Enterprise instance)
public class Server: Mappable {
  
  // The full URL String for the github.com API
  static let dotComAPIEndpoint = "https://api.github.com"
  
  // The full URL String for the github.com homepage
  static let dotcomBaseWebURL = "https://api.github.com"
  
  // The path to the API for an Enterprise instance
  // (relative to the baseURL).
  static let enterpriseAPIEndpointPathComponent = "api/v3"
  
  // Enterprise defaults to HTTP, and not all instances have HTTPS set up.
  static let defaultEnterpriseScheme = "http"
  
  // Expose Enterprise HTTPS scheme for clients.
  static let httpsEnterpriseScheme = "https"
 
  // Returns YES if this is an Enterprise instance
  var isEnterprise: Bool {
    return baseURL != nil
  }
  
  // The base URL to the instance associated with this server
  private(set) var baseURL: NSURL?
  
  // The base URL to the API we should use for requests to this server
  // (i.e., Enterprise or github.com).
  //
  // This URL is constructed from the baseURL.
  var APIEndpoint: NSURL {
    if let url = baseURL {
      return url.URLByAppendingPathComponent(Server.enterpriseAPIEndpointPathComponent, isDirectory: true)
    } else if let endpoint = NSProcessInfo.processInfo().environment["API_ENDPOINT"] {
      // This environment variable can be used to debug API requests by
      // redirecting them to a different URL.
      return NSURL(string: endpoint)!
    } else {
      return NSURL(string: Server.dotComAPIEndpoint)!
    }
  }
  
  // The base URL to the website for the instance (the
  // Enterprise landing page or github.com).
  //
  // This URL is constructed from the baseURL.
  var baseWebURL: NSURL {
    return baseURL ?? NSURL(string: Server.dotcomBaseWebURL)!
  }
  
  public required convenience init(_ map: JSONDictionary) {
    self.init()
  }

  // Returns either the Enterprise instance for a given base URL, or +dotComServer
  // if `baseURL` is nil.
  public convenience init(baseURL: NSURL) {
    self.init()
    self.baseURL = baseURL
  }
  
  // Returns the github.com server instance
  static let dotComServer = Server()
    
  public static func HTTPSEnterpriseServer(server: Server) -> Server {
    if let URL = server.baseURL,
      path = URL.path,
      secureURL = NSURL(scheme: Server.httpsEnterpriseScheme, host: URL.host, path: path.isEmpty ? "/" : path) {
      return Server(baseURL: secureURL)
    } else {
      return server
    }
  }
}

extension Server: Hashable, Equatable {
  public var hashValue: Int {
    return baseURL?.hashValue ?? 0
  }
}

public func ==(lhs: Server, rhs: Server) -> Bool {
  return lhs.hashValue == rhs.hashValue
}