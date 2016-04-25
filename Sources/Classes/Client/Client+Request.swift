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
import Construction

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
    
    if requestDescriptor.method == .GET {
      if requestDescriptor.offset > 0 {
        parameters["page"] = requestDescriptor.page
      }

      parameters["per_page"] = requestDescriptor.perPage
    }
    
    let mutableURLRequest = NSMutableURLRequest(URL: requestDescriptor.URLString(baseURL))
    mutableURLRequest.HTTPMethod = requestDescriptor.method.rawValue
    
    // Header
    var headers = requestDescriptor.headers
    if let token = token, (key, value) = Helper.authorizationHeader(token, password: "x-oauth-basic") {
      headers[key] = value
    }

    mutableURLRequest.allHTTPHeaderFields?.update(headers)

    if let etag = requestDescriptor.etag {
      mutableURLRequest.setValue(etag, forHTTPHeaderField: "If-None-Match")
      
      // If an etag is specified, we want 304 responses to be treated as 304s,
      // not served from NSURLCache with a status of 200.
      mutableURLRequest.cachePolicy = .ReloadIgnoringLocalCacheData
    }
    
    // Request
    var encodedURLRequest: NSMutableURLRequest
    if [.GET, .HEAD, .DELETE].contains(requestDescriptor.method) {
      encodedURLRequest = ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
    } else {
      encodedURLRequest = ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
    }

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
    
    let observable: Observable<Response> = Observable.create({ (observer) -> Disposable in
      request
        .validate(statusCode: 200..<300)
        .response { request, response, data, error in

        if NSProcessInfo.processInfo().environment[Constant.responseLoggingEnvironmentKey] != nil {
          print("\(request?.URL)")
        }
       
        if let statusCode = response?.statusCode where statusCode == Constant.notModifiedStatusCode {
          // No change in the data.
          observer.onCompleted()
          return
        }

        // Response
        guard let response = response else {
          observer.onError(Error.unsupportedVersionError())
          return
        }

        // Error
        if let error = error {
          observer.onError(Error.transform(error, response: response))
          return
        }

        // Data
        guard let data = data where data.length > 0 else {
          observer.onNext(Response(urlResponse: response, jsonArray: []))
          observer.onCompleted()
          return
        }

        // JSON
        guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
          else {
            observer.onError(Error.unsupportedVersionError())
            return
          }
        
        // Next
        var nextPageObservable = Observable<Response>.empty()

        if let nextPageURL = Helper.nextPageURL(response),
          path = nextPageURL.path where requestDescriptor.fetchAllPages {
         
           // If we got this far, the etag is out of date, so don't pass it on.
          
          var nextRequestDescriptor = requestDescriptor
          nextRequestDescriptor.path = path
          
          nextPageObservable = self.enqueue(nextRequestDescriptor)
        }
        
        // JSON
        var jsonArray: JSONArray = []
          
        if let json = json as? JSONArray {
          jsonArray = json
        } else if let json = json as? JSONDictionary {
          jsonArray = [json]
        }
          
        guard !jsonArray.isEmpty else {
          observer.onError(Error.unsupportedVersionError())
          return
        }
          
        Observable.just(Response(urlResponse: response, jsonArray: jsonArray))
          .concat(nextPageObservable)
          .subscribe(observer)
      }
      
      return AnonymousDisposable {
        request.cancel()
      }
    }).debug("-enqueueRequest: \(request) fetchAllPages: \(requestDescriptor.fetchAllPages)")

    return requestDescriptor.pageOffset > 0
    ? observable.skip(requestDescriptor.pageOffset)
    : observable
  }
  
  // Enqueues a request to fetch information about the current user by accessing
  // a path relative to the user object.
  //
  // method       - The HTTP method to use.
  // relativePath - The path to fetch, relative to the user object. For example,
  //                to request `user/orgs` or `users/:user/orgs`, simply pass in
  //                `/orgs`. This may not be nil, and must either start with a '/'
  //                or be an empty string.
  // parameters   - HTTP parameters to encode and send with the request.
  // resultClass  - The class that response data should be returned as.
  //
  // Returns a signal which will send an instance of `resultClass` for each parsed
  // JSON object, then complete. If no `user` is set on the receiver, the signal
  // will error immediately.
  public func enqueueUser(requestDescriptor: RequestDescriptor) -> Observable<Response> {
    var requestDescriptor = requestDescriptor
    
    build(&requestDescriptor) {
      if isAuthenticated {
        $0.path = "user/\($0.path)"
      } else if let user = user {
        $0.path = "users/\(user.rawLogin)/\($0.path)"
      } else {
        assertionFailure()
      }
      
      if let last = $0.path.characters.last where last == "/" {
        $0.path.removeAtIndex($0.path.endIndex.predecessor())
      }
    }
    
    return enqueue(requestDescriptor)
  }
}
