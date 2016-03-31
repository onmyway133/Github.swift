//
//  ClientSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 29/03/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

@testable import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift

class ClientSpec: QuickSpec {
  
  override func spec() {
    
    describe("without a user") {
      var client: Client!
      
      beforeEach {
        client = Client(server: Server.dotComServer)
        expect(client).notTo(beNil())
        expect(client.user).to(beNil())
        expect(client.isAuthenticated).to(beFalsy())

      }
      
      it("should create a GET request with default parameters") {
        let requestObject = RequestObject().then {
          $0.path = "rate_limit"
        }
        
        let request = client.makeRequest(requestObject)

        expect(request).notTo(beNil())
        expect(request.request?.URL).to(equal(NSURL(string: "https://api.github.com/rate_limit?per_page=100")!))
      }
    }
    
    describe("+fetchMetadataForServer:") {
      it("should successfully fetch metadata") {
        self.stub(uri("/meta"), builder: jsonData(Helper.read("meta")))
        
//        self.async { expectation in
//          let observable = Client.fetchMetadata(Server.dotComServer)
//          let _ = observable.subscribeNext { meta in
//            expect(meta).notTo(beNil())
//            expect(meta.supportsPasswordAuthentication).to(beTruthy())
//            expect(true).to(beTrue())
//            expectation.fulfill()
//          }
//        }
      }
      
      it("should fail if /meta doesn't exist") {
        self.stub(uri("/meta"), builder: http(404, headers: nil, data: Helper.read("meta")))
        
        let observable = Client.fetchMetadata(Server.dotComServer)
        let _ = observable.subscribeError { error in
          
        }
      }
    }
  }
}