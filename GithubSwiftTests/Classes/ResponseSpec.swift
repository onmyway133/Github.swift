//
//  ResponseSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 11/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class ResponseSpec: QuickSpec {
  override func spec() {
    describe("response") {
      let etag = "644b5b0155e6404a9cc4bd9d8b1ae730"
      
      var headers = [
        "ETag": etag,
        "X-RateLimit-Limit": "5000",
        "X-RateLimit-Remaining": "4900",
      ]
      
      func responseWithHeaders() -> GithubSwift.Response {
        let URLResponse = NSHTTPURLResponse(URL: Server.dotComServer.APIEndpoint, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: headers)
        
        return Response(urlResponse: URLResponse!, jsonArray: [])
      }
      
      it("should have a status code") {
        expect(responseWithHeaders().statusCode).to(equal(200))
      }
      
      it("should have an etag") {
        expect(responseWithHeaders().etag).to(equal(etag));
      }
      
      it("should have rate limit info") {
        let response = responseWithHeaders()
        expect(response.maximumRequestsPerHour).to(equal(5000))
        expect(response.remainingRequests).to(equal(4900))
      }
      
      it("should not have a poll interval by default") {
        expect(responseWithHeaders().pollInterval).to(beNil())
      }
      
      it("should have a poll interval when the header is present") {
        headers["X-Poll-Interval"] = "2.5"
        expect(responseWithHeaders().pollInterval).to(beCloseTo(2.5))
      }
    }
  }
}
