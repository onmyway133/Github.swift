//
//  TestURLOpener.swift
//  GithubSwift
//
//  Created by Khoa Pham on 09/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import RxSwift

class TestURLOpener: URLOpenerType {
  
  // Changes the behavior of +openURL: so that it always or never succeeds.
  var shouldSucceedOpeningURL = false
  
  // Sends all URLs passed to +openURL:.
  var openedURLsVariable: Variable<NSURL?> = Variable(NSURL(string: ""))
  
  func openURL(url: NSURL) -> Bool {
    openedURLsVariable.value = url
    return shouldSucceedOpeningURL
  }
}
