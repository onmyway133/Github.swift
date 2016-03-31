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
  public var fetchAllPages: Bool = false
  
  public func URLString(baseURL: NSURL) -> NSURL {
    let escapedPath = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    return baseURL.URLByAppendingPathComponent(escapedPath ?? "")
  }
  
  public init() {}
}

extension RequestDescriptor: Then {}
