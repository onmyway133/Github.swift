//
//  Response.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar

// Represents a parsed response from the GitHub API, along with any useful
// headers.
public class Response {
  
  // The parsed MTLModel object corresponding to the API response.
  public let jsonArray: JSONArray
  
  // The etag uniquely identifying this response data.
  public var etag: String {
    return urlResponse.allHeaderFields["ETag"] as? String ?? ""
  }
 
  // The HTTP status code returned in the response.
  public var statusCode: Int {
    return urlResponse.statusCode
  }
  
  // // Set to any X-Poll-Interval header returned by the server, or nil if no such
  // header was returned.
  //
  // This is used with the events and notifications APIs to support server-driven
  // polling rates.
  public var pollInterval: Int? {
    let intervalString = urlResponse.allHeaderFields["X-Poll-Interval"] as? String
    return Int(intervalString ?? "")
  }
  
  // Set to the X-RateLimit-Limit header sent by the server, indicating how many
  // unconditional requests the user is allowed to make per hour.
  public var maximumRequestsPerHour: Int {
    return urlResponse.allHeaderFields["X-RateLimit-Limit"] as? Int ?? 0
  }
 
  // Set to the X-RateLimit-Remaining header sent by the server, indicating how
  // many remaining unconditional requests the user can make this hour (in server
  // time).
  public var remainingRequests: Int {
    return urlResponse.allHeaderFields["X-RateLimit-Remaining"] as? Int ?? 0
  }
  
  private let urlResponse: NSHTTPURLResponse
  
  // Initializes the receiver with the headers from the given response, and the
  // given parsed model object(s).
  public init(urlResponse: NSHTTPURLResponse, jsonArray: JSONArray) {
    self.urlResponse = urlResponse
    self.jsonArray = jsonArray
  }
}
