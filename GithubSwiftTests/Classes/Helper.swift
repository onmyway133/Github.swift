//
//  Helper.swift
//  GithubSwift
//
//  Created by Khoa Pham on 29/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Quick
import Mockingjay
import RxSwift

class DummySpec: QuickSpec {}

struct Helper {
  static func read(fileName: String) -> NSData {
    let path = NSBundle(forClass: DummySpec().dynamicType).pathForResource(fileName, ofType: "json")!
    return NSData(contentsOfFile: path)!
  }
}

public extension XCTestCase {
  public func async(action: (XCTestExpectation) -> Void) {
    let expectation = self.expectationWithDescription("")
    
    action(expectation)
    
    self.waitForExpectationsWithTimeout(1, handler: nil)
  }
}

extension XCTest {
  func stubRedirect(url: NSURL, statusCode: Int, redirectURL: NSURL) {
    
    func matcher(request: NSURLRequest) -> Bool {
      guard request.URL?.scheme == url.scheme && request.URL?.path == url.path else { return false }

      return true
    }
    
    self.stub(matcher, builder: http(statusCode, headers: ["Location": redirectURL.absoluteString]))
  }
}
