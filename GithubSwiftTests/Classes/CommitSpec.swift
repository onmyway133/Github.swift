//
//  CommitSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 24/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class CommitSpec: QuickSpec {
  override func spec() {

    describe("commit") {
      it("should initialize") {
        let commit = Commit(Helper.readJSON("commit") as JSONDictionary)

        expect(commit.SHA).to(equal("7638417db6d59f3c431d3e1f261cc637155684cd"))
        expect(commit.treeURL!.absoluteString).to(equal("https://api.github.com/repos/octocat/Hello-World/git/trees/691272480426f78a0138979dd3ce63b77f706feb"))
        expect(commit.treeSHA).to(equal("691272480426f78a0138979dd3ce63b77f706feb"))
      }
    }
  }
}
