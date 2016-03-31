//
//  Client+Request.swift
//  GithubSwift
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Sugar

public extension Client {
  func URLString(path: String) -> NSURL {
    return baseURL.URLByAppendingPathComponent(path)
  }
  
  // Creates a mutable URL request, which when sent will conditionally fetch the
  // latest data from the server. If the latest data matches `etag`, nothing is
  // downloaded and the call does not count toward the API rate limit.
  //
  // method          - The HTTP method to use in the request
  //                   (e.g., "GET" or "POST").
  // path            - The path to request, relative to the base API endpoint.
  //                   This path should _not_ begin with a forward slash.
  // parameters      - HTTP parameters to encode and send with the request.
  // notMatchingEtag - An ETag to compare the server data against, previously
  //                   retrieved from an instance of OCTResponse. If the content
  //                   has not changed since, no new data will be fetched when
  //                   this request is sent. This argument may be nil to always
  //                   fetch the latest data.
  //
  // Returns an NSMutableURLRequest that you can enqueue using
  // -enqueueRequest:resultClass:.
  public func makeRequest(requestDescriptor: RequestDescriptor) -> Request {
    
    // Parameter
    var parameters = requestDescriptor.parameters
    
    if requestDescriptor.method == .GET && !parameters.keys.contains("per_page") {
      parameters["per_page"] = 100
    }
    
    let mutableURLRequest = NSMutableURLRequest(URL: requestDescriptor.URLString(baseURL))
    
    // Header
    if let etag = requestDescriptor.etag {
      mutableURLRequest.setValue(etag, forHTTPHeaderField: "If-None-Match")
      
      // If an etag is specified, we want 304 responses to be treated as 304s,
      // not served from NSURLCache with a status of 200.
      mutableURLRequest.cachePolicy = .ReloadIgnoringLocalCacheData
      
    }
    
    // Request
    let encodedURLRequest = ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
    return manager.request(encodedURLRequest)
  }
  
  // Enqueues a request to be sent to the server.
  //
  // This will automatically fetch all pages of the given endpoint. Each object
  // from each page will be sent independently on the returned signal, so
  // subscribers don't have to know or care about this pagination behavior.
  //
  // request       - The previously constructed URL request for the endpoint.
  // resultClass   - A subclass of OCTObject that the response data should be
  //                 returned as, and will be accessible from the parsedResult
  //                 property on each OCTResponse. If this is nil, NSDictionary
  //                 will be used for each object in the JSON received.
  //
  // Returns a signal which will send an instance of `OCTResponse` for each parsed
  // JSON object, then complete. If an error occurs at any point, the returned
  // signal will send it immediately, then terminate.
  public func enqueue(requestDescriptor: RequestDescriptor) -> Observable<Response> {
    let request = self.makeRequest(requestDescriptor)
    
    return Observable.create({ (observer) -> Disposable in
      request.responseJSON { response in
        
        if NSProcessInfo.processInfo().environment[Client.Constant.responseLoggingEnvironmentKey] != nil {
          print("\(request.request?.URL)")
        }
        
        if let statusCode = response.response?.statusCode where statusCode == Client.Constant.notModifiedStatusCode {
          // No change in the data.
          observer.onCompleted()
          return
        }
        
        if let json = response.result.value as? JSONDictionary,
          urlResponse = response.response {
          observer.onNext(Response(urlResponse: urlResponse, json: json))
          observer.onCompleted()
        } else if let error = response.result.error {
          observer.onError(error)
        }
      }
      
      return AnonymousDisposable {
        request.cancel()
      }
    }).debug("-enqueueRequest: \(request) fetchAllPages: \(requestDescriptor.fetchAllPages)")
  }
  
  func nextPageURL(response: NSHTTPURLResponse) -> NSURL? {
    guard let linksString = response.allHeaderFields["Link"] as? String where linksString.isEmpty else { return nil }
    guard let regex = try? NSRegularExpression(pattern: "rel=\\\"?([^\\\"]+)\\\"?", options: .CaseInsensitive) else { return nil }
   
    let set = NSMutableCharacterSet(charactersInString: "<>")
    set.formUnionWithCharacterSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    for link in linksString.split(",") {
      guard let semicolonRange = link.rangeOfString(";") else { continue }
  
      let URLString = link.substringToIndex(semicolonRange.startIndex).stringByTrimmingCharactersInSet(set)
      
      guard !URLString.isEmpty else { continue }
      
      guard let result = regex.firstMatchInString(link, options: .Anchored, range: NSMakeRange(0, link.length)) else { continue }
      
      guard let range = link.rangeFromNSRange(result.rangeAtIndex(1)) else { continue }
      
      let type = link.substringWithRange(range)
      
      if type == "next" {
        return NSURL(string: URLString)
      }

    }
    
    return nil
  }
}

extension String {
  func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
    let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
    let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
    if let from = String.Index(from16, within: self),
      let to = String.Index(to16, within: self) {
      return from ..< to
    }
    return nil
  }
}
