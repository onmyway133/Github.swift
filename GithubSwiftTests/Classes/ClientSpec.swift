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
      
      // A random ETag for testing.
      let etag = "644b5b0155e6404a9cc4bd9d8b1ae730"
      
      beforeEach {
        client = Client(server: Server.dotComServer)
      }
      
      it("should create a client") {
        expect(client).notTo(beNil())
        expect(client.user).to(beNil())
        expect(client.isAuthenticated).to(beFalsy())

      }
      
      it("should create a GET request with default parameters") {
        let requestDescriptor = RequestDescriptor().then {
          $0.path = "rate_limit"
        }
        
        let request = client.makeRequest(requestDescriptor)

        expect(request).notTo(beNil())
        expect(request.request?.URL).to(equal(NSURL(string: "https://api.github.com/rate_limit?per_page=100")!))
      }
      
      it("should create a POST request with default parameters") {
        let requestDescriptor = RequestDescriptor().then {
          $0.method = .POST
          $0.path = "diver/dave"
        }
        
        let request = client.makeRequest(requestDescriptor)
        
        expect(request).notTo(beNil())
        expect(request.request?.URL).to(equal(NSURL(string: "https://api.github.com/diver/dave")!))
      }
      
      it("should create a request using etags") {
        let etag = "\"deadbeef\""
        
        let requestDescriptor = RequestDescriptor().then {
          $0.path = "diver/dan"
          $0.etag = etag
        }

        let request = client.makeRequest(requestDescriptor)
      
        expect(request).notTo(beNil())
        expect(request.request?.URL).to(equal(NSURL(string: "https://api.github.com/diver/dan?per_page=100")!))
        expect(request.request?.allHTTPHeaderFields?["If-None-Match"] ?? "").to(equal(etag))
      }
      
      it("should GET a JSON dictionary") {
        self.stub(uri("/rate_limit"), builder: jsonData(Helper.read("rate_limit")))

        let requestDescriptor = RequestDescriptor().then {
          $0.path = "rate_limit"
        }
        
        let observable = client.enqueue(requestDescriptor)
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case .Error(_):
              fail()
            case let .Next(response):
              let expected = [
                "rate": [
                  "remaining": 4999,
                  "limit": 5000
                ]
              ]
              
              expect(NSDictionary(dictionary: response.json)).to(equal(NSDictionary(dictionary: expected)))
              expectation.fulfill()
            default:
              break;
            }
          }
        }
      }
      
      it("should conditionally GET a modified JSON dictionary") {
        self.stub(uri("/rate_limit"), builder: jsonData(Helper.read("rate_limit"), status: 200, headers: ["Etag": etag]))
        
        let requestDescriptor = RequestDescriptor().then {
          $0.path = "rate_limit"
        }
        
        let observable = client.enqueue(requestDescriptor)
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case .Error(_):
              fail()
            case let .Next(response):
              let expected = [
                "rate": [
                  "remaining": 4999,
                  "limit": 5000
                ]
              ]
              
              expect(response.etag).to(equal(etag))
              expect(NSDictionary(dictionary: response.json)).to(equal(NSDictionary(dictionary: expected)))
              expectation.fulfill()
            default:
              break
            }
          }
        }
      }
      
      it("should conditionally GET an unmodified endpoint") {
        self.stub(uri("/rate_limit"), builder: jsonData(Helper.read("rate_limit"), status: 304))

        let requestDescriptor = RequestDescriptor().then {
          $0.path = "rate_limit"
          $0.etag = etag
        }
        
        let observable = client.enqueue(requestDescriptor)
       
        var succeeded = false
        
        self.async { expectation in
          let _ = observable.subscribe { event in
            switch(event) {
            case .Error(_):
              fail()
            case .Next:
              fail()
            case .Completed:
              succeeded = true
              
              expect(succeeded).to(beTrue())
              expectation.fulfill()
            }
          }
        }
      }
      
      it("should GET a paginated endpoint") {
        let link1 = "<https://api.github.com/items2>; rel=\"next\", <https://api.github.com/items3>; rel=\"last\""
        let link2 = "<https://api.github.com/items3>; rel=\"next\", <https://api.github.com/items3>; rel=\"last\""
        
        self.stub(uri("/items1"), builder: jsonData(Helper.read("page1"), status: 200, headers: ["Link": link1]))
        self.stub(uri("/items2"), builder: jsonData(Helper.read("page2"), status: 200, headers: ["Link": link2]))
        self.stub(uri("/items3"), builder: jsonData(Helper.read("page3")))
        
        let requestDescriptor = RequestDescriptor().then {
          $0.path = "items1"
        }
        
        let observable = client.enqueue(requestDescriptor)
        
        self.async { expectation in
          var items: [Int] = []
          
          let _ = observable.subscribeNext { response in
            
//            expect(response.json).to(beAKindOf(JSONDictionary))
//            expect(response.json["items"]).toNot(beNil())
            
            expectation.fulfill()
          }
        }
      }
    }
  }
}
