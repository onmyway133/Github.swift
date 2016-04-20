//
//  RequestDescriptor.swift
//  GithubSwift
//
//  Created by Khoa Pham on 28/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Alamofire
import Sugar

public class RequestDescriptor {
  public var method: Alamofire.Method = .GET
  public var path: String = ""
  public var parameters: [String: AnyObject] = [:]
  public var headers: [String: String] = [:]
  public var etag: String?
  public var fetchAllPages: Bool = true

  // There are cases a provided URL is required
  public var URL: NSURL?

  /// offset  - Allows you to specify an offset at which items will begin being returned.
  public var offset: Int = 0

  /// Retrieves the valid perPage according to the original perPage.
  public var perPage: Int = Constant.defaultPerPage {
    didSet {
      perPage = max(0, perPage)
      perPage = min(perPage, Constant.defaultPerPage)
    }
  }
  
  public func URLString(baseURL: NSURL) -> NSURL {
    if let URL = URL {
      return URL
    }

    let escapedPath = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    return baseURL.URLByAppendingPathComponent(escapedPath ?? "")
  }
  
  public init() {}
}

public extension RequestDescriptor {
  /// Retrieves the corresponding page according to the offset and the valid perPage.
  var page: Int {
    return offset / perPage + 1
  }

  var pageOffset: Int {
    return offset % perPage
  }
}

extension RequestDescriptor: Then {}
