//
//  ClientSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 29/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class ClientSpec: QuickSpec {
  
  override func spec() {

    describe("without a user") {
      var client: Client!
      
      beforeEach {
        client = Client(server: Server.dotComServer)
      }
      
      it("should create a client") {
        expect(client).notTo(beNil())
        expect(client.user).to(beNil())
        expect(client.isAuthenticated).to(beFalsy())

      }
    }
  }
}
