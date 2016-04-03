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
      
      let user = User(rawLogin: "octokit-testing-user", server: Server.dotComServer)

      beforeEach {
        Client.Config.clientID = clientID
        Client.Config.clientSecret = clientSecret
      }
      
      it("should send the appropriate error when requesting authorization with 2FA on") {
        func matcher(request: NSURLRequest) -> Bool {          
          guard let path = request.URL?.path
            where path == "/authorizations/clients/\(clientID)" && request.HTTPMethod == "PUT" else { return false }

          return true
        }
        
        self.stub(matcher, builder: jsonData(Helper.read("authorizations"), status: 401, headers: ["X-GitHub-OTP": "required; sms"]))
      
        let observable = Client.signIn(user: user, password: "", scopes: .Repository)
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case let .Error(error):
              let error = error as NSError
              expect(error.domain).to(equal(Client.Constant.errorDomain))
              expect(error.code).to(equal(ErrorCode.TwoFactorAuthenticationOneTimePasswordRequired.rawValue))
              
              if let message = error.userInfo[ErrorKey.OneTimePasswordMediumKey.rawValue] as? String {
                expect(message).to(equal(OneTimePasswordMedium.SMS.rawValue))
              }
              
              expectation.fulfill()
            default:
              fail()
            }
          }
        }
      }
      
      
    }
  }
}

