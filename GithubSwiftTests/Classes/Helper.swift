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
import Sugar

class DummySpec: QuickSpec {}

struct Helper {
  static func read(fileName: String) -> NSData {
    let path = NSBundle(forClass: DummySpec().dynamicType).pathForResource(fileName, ofType: "json")!
    return NSData(contentsOfFile: path)!
  }
}

public extension XCTestCase {
  public func async(file: String = #file, line: UInt = #line, action: (XCTestExpectation) -> Void) {
    let expectation = self.expectationWithDescription("")
    
    action(expectation)
    
    self.waitForExpectationsWithTimeout(1) { error in
      if error != nil {
        self.recordFailureWithDescription("fail", inFile: file, atLine: line, expected: true)
      }
    }
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

extension ObservableType {
  func subscribeSync() -> Event<E>? {
    var event: Event<E>?
    var done = false
    
    let _ = self.subscribe { e in
      event = e
      
      switch e {
      case .Error, .Completed:
        done = true
      default:
        break
      }
    }
    
    delay(1) {
      done = true
    }
    
    repeat {
      NSRunLoop.mainRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 0.1))
    } while (!done)
    
    return event
  }
}
