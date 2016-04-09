//
//  ServerSpec.swift
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

class ServerSpec: QuickSpec {
  override func spec() {
    
    describe("+HTTPSEnterpriseServerWithServer") {
      it("should convert a http URL to a HTTPS URL") {
        let httpServer = Server(baseURL: NSURL(string: "http://github.enterprise")!)
        expect(httpServer.baseURL?.scheme).to(equal("http"))
        
        let httpsServer = Server.HTTPSEnterpriseServer(httpServer)
        expect(httpsServer.baseURL?.scheme).to(equal("https"))
        expect(httpsServer.baseURL?.host).to(equal(httpServer.baseURL?.host))
        expect(httpsServer.baseURL?.path).to(equal("/"))
      }
    }
    
    describe("server") {
      
      it("should have a dotComServer") {
        let dotComServer = Server.dotComServer
        
        expect(dotComServer).notTo(beNil())
        expect(dotComServer.baseURL).to(beNil())
        expect(dotComServer.baseWebURL).to(equal(NSURL(string: Server.dotcomBaseWebURL)))
        expect(dotComServer.APIEndpoint).to(equal(NSURL(string: Server.dotComAPIEndpoint)))
        expect((dotComServer.isEnterprise)).to(beFalsy())
      }
      
      it("should be only one dotComServer") {
        let dotComServer = Server([:])
        
        expect(dotComServer).to(equal(Server.dotComServer))
      }
      
      it("can be an enterprise instance") {
        let enterpriseServer = Server(baseURL: NSURL(string: "https://localhost/")!)
        
        expect(enterpriseServer).notTo(beNil())
        expect((enterpriseServer.isEnterprise)).to(beTruthy())
        expect(enterpriseServer.baseURL).to(equal(NSURL(string: "https://localhost/")!))
        expect(enterpriseServer.baseWebURL).to(equal(enterpriseServer.baseURL))
        expect(enterpriseServer.APIEndpoint).to(equal(NSURL(string: "https://localhost/api/v3/")))
      }
      
      it("should use baseURL for equality") {
        let dotComServer = Server.dotComServer
        
        let enterpriseServer = Server(baseURL: NSURL(string:"https://localhost/")!)
        let secondEnterpriseServer = Server(baseURL: NSURL(string:"https://localhost/")!)
        let thirdEnterpriseServer = Server(baseURL: NSURL(string:"https://192.168.0.1")!)
        
        expect(dotComServer).notTo(equal(enterpriseServer))
        expect(dotComServer).notTo(equal(secondEnterpriseServer))
        expect(dotComServer).notTo(equal(thirdEnterpriseServer))
        
        expect(enterpriseServer).to(equal(secondEnterpriseServer))
        expect(enterpriseServer).notTo(equal(thirdEnterpriseServer))
        
        expect(secondEnterpriseServer).notTo(equal(thirdEnterpriseServer))
      }
    }
  }
}
