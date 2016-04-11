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
  
  static func readJSON(fileName: String) -> [String: AnyObject] {
    let data = Helper.read(fileName)
    if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments),
      jsonDictionary = json as? [String: AnyObject] {
      return jsonDictionary
    } else {
      return [:]
    }
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
  func subscribeSync() -> (next: E?, error: NSError?, completed: Bool) {
    var next: E?
    var error: NSError?
    var completed: Bool = false
    var done = false
    
    let _ = self.subscribe { event in
      
      switch event {
      case let .Next(value):
        next = value
      case let .Error(e):
        error = e as NSError
        done = true
      case .Completed:
        completed = true
        done = true
      }
    }
    
    delay(1) {
      done = true
    }
    
    repeat {
      NSRunLoop.mainRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 0.1))
    } while (!done)
    
    return (next: next, error: error, completed: completed)
  }
}

