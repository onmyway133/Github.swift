//
//  Client+SignInSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 03/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class ClientSignInSpec: QuickSpec {
  override func spec() {
    describe("sign in") {
      let dotComLoginURL = NSURL(string: "https://github.com/login/oauth/authorize")
      
      let clientID = "deadbeef"
      let clientSecret = "itsasekret"

      beforeEach {
        Client.Config.clientID = clientID
        Client.Config.clientSecret = clientSecret
      }
      
      it("should send the appropriate error when requesting authorization with 2FA on") {
        
      }
    }
  }
}

