//
//  RefSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class RefSpec: QuickSpec {
  override func spec() {

    describe("ref") {
      it("should initialize") {
        let ref = Ref(Helper.readJSON("ref"))

        expect(ref.name).to(equal("refs/heads/sc/featureA"))
        expect(ref.SHA).to(equal("aa218f56b14c9653891f9e74264a383fa43fefbd"))
        expect(ref.objectURL).to(equal(NSURL(string: "https://api.github.com/repos/octocat/Hello-World/git/commits/aa218f56b14c9653891f9e74264a383fa43fefbd")))
      }
    }
  }
}
