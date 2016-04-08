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
      let dotComLoginURL = NSURL(string: "https://github.com/login/oauth/authorize")!
      
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
     
      it("should request authorization") {
        self.stub(uri("/authorizations/clients/\(clientID)"), builder: jsonData(Helper.read("authorizations"), status: 201))

        let observable = Client.signIn(user: user, password: "", scopes: .Repository)
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case let .Next(client):
              expect(client).notTo(beNil())
              expect(client.user).to(equal(user))
              expect(client.token).to(equal("abc123"))
              expect((client.isAuthenticated)).to(beTrue())
              
              expectation.fulfill()
            case .Completed:
              break
            default:
              fail()
            }
          }
        }
      }
     
      it("requests authorization through redirects") {
        let baseURL = NSURL(string: "http://enterprise.github.com")!
        let path = "api/v3/authorizations/clients/\(clientID)"
        
        let httpURL = baseURL.URLByAppendingPathComponent(path)
        let httpsURL = NSURLComponents().then {
          $0.scheme = "https"
          $0.host = httpURL.host
          $0.path = httpURL.path
        }.URL!
        
        self.stub(uri(httpsURL.absoluteString), builder: jsonData(Helper.read("authorizations"), status: 201))
        self.stubRedirect(httpURL, statusCode: 301, redirectURL: httpsURL)
        
        let enterpriseServer = Server(baseURL: baseURL)
        let enterpriseUser = User(rawLogin: user.rawLogin, server: enterpriseServer)
        
        let observable = Client.signIn(user: enterpriseUser, password: "", scopes: .Repository)
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case let .Next(client):
              expect(client).notTo(beNil())
              expect((client.isAuthenticated)).to(beTrue())
              
              expectation.fulfill()
            case .Completed:
              break
            default:
              fail()
            }
          }
        }
      }
     
      it("should detect old server versions") {
        self.stub(uri("/authorizations/clients/\(clientID)"), builder: http(404))
  
        let observable = Client.signIn(user: user, password: "", scopes: .Repository)
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case let .Error(error):
              let error = error as NSError
              expect(error.domain).to(equal(Client.Constant.errorDomain))
              expect(error.code).to(equal(ErrorCode.UnsupportedServer.rawValue))
              
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
      
      it("should delete an existing authorization") {
        var deleted = false
        
        func matcher(request: NSURLRequest) -> Bool {
          guard let path = request.URL?.path
            where path == "/authorizations/1" && request.HTTPMethod == "DELETE" else { return false }
         
          deleted = true
          return true
        }
        
        self.stub(uri("/authorizations/clients/\(clientID)"), builder: jsonData(Helper.read("authorizations_existing"), status: 200))
        self.stub(matcher, builder: jsonData(NSData(), status: 204))
       
        let observable = Client.signIn(user: user, password: "", scopes: .Repository)
        self.async { expectation in
          let _ = observable.subscribe { a in
            expect(deleted).to(beTrue())
            expectation.fulfill()
          }
        }
      }
      
      describe("+authorizeWithServerUsingWebBrowser:scopes:") {
        let testURLOpener = TestURLOpener()
        var openedURL: NSURL?
        var disposable: Disposable!
        
        beforeEach {
          testURLOpener.shouldSucceedOpeningURL = true
          Client.urlOpener = testURLOpener
          disposable = testURLOpener.openedURLsVariable.asObservable().subscribeNext { url in
            if !(url?.absoluteString.isEmpty ?? false) {
              openedURL = url
            }
          }
        }
        
        afterEach {
          Client.urlOpener = URLOpener()
          disposable!.dispose()
        }
        
        it("should open the login URL") {
          let _ = Client.authorizeUsingWebBrowser(Server.dotComServer, scopes: .Repository).subscribe { _ in }
          
          self.async { expectation in
            expect(openedURL).toNot(beNil())
            expect(openedURL?.scheme).to(equal(dotComLoginURL.scheme))
            expect(openedURL?.host).to(equal(dotComLoginURL.host))
            expect(openedURL?.path).to(equal(dotComLoginURL.path))
            
            expectation.fulfill()
          }
        }
        
        it("should only complete after a matching URL is passed to +completeSignInWithCallbackURL:") {
          var code = ""
          
          let _ = Client.authorizeUsingWebBrowser(Server.dotComServer, scopes: .Repository)
            .subscribeNext {
              code = $0
            }
          
          self.async { expectation in
            guard let openedURL = openedURL else { return }
            
            expect(openedURL).toNot(beNil());
            
            let queryArguments = openedURL.queryArguments
            expect(queryArguments["client_id"]).to(equal(clientID))
            expect(queryArguments["scope"]).notTo(beNil())
            
            let state = queryArguments["state"]
            expect(state).notTo(beNil())
            
            let differentURL = NSURL(string: "?state=foobar&code=12345", relativeToURL: dotComLoginURL)!
            Client.completeSignIn(callbackURL: differentURL)
            
            expect(code.isEmpty).to(beTrue())
            
            let matchingURL = NSURL(string: "?state=\(state!)&code=12345", relativeToURL: dotComLoginURL)!
            Client.completeSignIn(callbackURL: matchingURL)
            
            expect(code).to(equal("12345"));
          }
        }
      }
    }
  }
}

