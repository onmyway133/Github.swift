//
//  Client+ServerSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 10/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class ClientServerSpec: QuickSpec {
  override func spec() {
    
    describe("+fetchMetadataForServer:") {
      it("should successfully fetch metadata") {
        self.stub(uri("/meta"), builder: jsonData(Helper.read("meta")))

        let event = Client.fetchMetadata(Server.dotComServer).subscribeSync()
        
        if case let .Next(meta)? = event {
          expect(meta).notTo(beNil())
          expect(meta.supportsPasswordAuthentication).to(beTrue())
        } else {
          fail()
        }
      }
      
      it("should fail if /meta doesn't exist") {
        self.stub(uri("/meta"), builder: http(404))
        
        let event = Client.fetchMetadata(Server.dotComServer).subscribeSync()
        
        if case let .Error(error)? = event {
          let error = error as NSError
          expect(error.domain).to(equal(Client.Constant.errorDomain))
          expect(error.code).to(equal(ErrorCode.UnsupportedServer.rawValue))
        } else {
          fail()
        }
      }
      
      it("should successfully fetch metadata through redirects") {
        let baseURL = NSURL(string: "http://enterprise.github.com")!
        let HTTPURL = baseURL.URLByAppendingPathComponent("api/v3/meta")
        let HTTPSURL = NSURL(string: "https://enterprise.github.com/api/v3/meta")!
        
        self.stub(uri(HTTPSURL.absoluteString), builder: jsonData(Helper.read("meta"), status: 200))
        self.stubRedirect(HTTPURL, statusCode: 301, redirectURL: HTTPSURL)
        
        let server = Server(baseURL: baseURL)
      
        let event = Client.fetchMetadata(server).subscribeSync()
        
        if case let .Next(meta)? = event {
          expect(meta).notTo(beNil())
        } else {
          fail()
        }
      }
    }
  }
}
