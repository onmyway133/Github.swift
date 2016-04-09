//
//  AuthorizationSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 09/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class AuthorizationSpec: QuickSpec {
  override func spec() {
    
    describe("authorization") {
      
      let token = "some-token"
      let json = [
        "id": 1,
        "token": token,
      ]
      
      var authorization: Authorization!
      
      beforeEach {
        authorization = Authorization(json as! JSONDictionary)
        expect(authorization).notTo(beNil())
      }
      
      it("should initialize from an external representation") {
        expect(authorization.objectID).to(equal("1"))
        expect(authorization.token).to(equal(token))
      }
      
      it("shouldn't include the token in the serialized representation") {
        
      }
      
    }
  }
}
