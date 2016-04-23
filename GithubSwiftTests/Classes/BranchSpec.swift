//
//  BranchSpec.swift
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

class BranchSpec: QuickSpec {
  override func spec() {

    describe("branch") {
      it("should initialize") {
        let branch = Branch(Helper.readJSON("branch"))

        expect(branch.name).to(equal("master"))
        expect(branch.lastCommitSHA).to(equal("6dcb09b5b57875f334f61aebed695e2e4193db5e"))
        expect(branch.lastCommitURL).to(equal(NSURL(string: "https://api.github.com/repos/octocat/Hello-World/commits/c5b97d5ae6c19d5c5df71a34c7fbeeda2479ccbc")))
      }
    }
  }
}
