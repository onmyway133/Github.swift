//
//  RequestObject.swift
//  GithubSwift
//
//  Created by Khoa Pham on 28/03/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import Foundation
import Alamofire
import Sugar

public class RequestObject {
  var method: Alamofire.Method = .GET
  var path: String = ""
  var parameters: [String: AnyObject] = [:]
  var headers: [String: String] = [:]
  var etag: String?
  var fetchAllPages: Bool = false
  
  public func URLString(baseURL: NSURL) -> NSURL {
    let escapedPath = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    return baseURL.URLByAppendingPathComponent(escapedPath ?? "")
  }
}

extension RequestObject: Then {}