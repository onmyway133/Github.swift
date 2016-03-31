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
    
    describe("+fetchMetadataForServer:") {
      it("should successfully fetch metadata") {
        self.stub(uri("/meta"), builder: jsonData(Helper.read("meta")))
        
        let observable = Client.fetchMetadata(Server.dotComServer)
        let _ = observable.subscribeNext { meta in
          expect(meta).notTo(beNil())
          expect(meta.supportsPasswordAuthentication).to(beTruthy())
        }
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