//
//  GistSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class GistSpec: QuickSpec {
  override func spec() {

    describe("gist") {
      it("should initialize") {

        let gist = Gist(Helper.readJSON("gist") as JSONDictionary)

        expect(gist.objectID).to(equal("1"))
        expect(gist.creationDate).to(equal(Formatter.date(string: "2010-04-14 02:15:15 +0000")))
        expect(gist.HTMLURL).to(equal(NSURL(string: "https://gist.github.com/1")))
        expect((gist.files.count)).to(equal(1))

        let file = gist.files["ring.erl"]!

        expect(file).notTo(beNil())
        expect(file.fileName).to(equal("ring.erl"))
        expect(file.rawURL).to(equal(NSURL(string: "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl")))
        expect((file.size)).to(equal(932))
      }
    }
  }
}
