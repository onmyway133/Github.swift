//
//  GitCommitSpec.swift
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

class GitCommitSpec: QuickSpec {
  override func spec() {

    describe("github.com git commit") {
      it("parsing a small commit") {
        let commit = GitCommit(Helper.readJSON("git_commit") as JSONDictionary)

        expect(commit.commitURL).to(equal(NSURL(string: "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e")))
        expect(commit.message).to(equal("Fix all the bugs"))
        expect(commit.SHA).to(equal("6dcb09b5b57875f334f61aebed695e2e4193db5e"))
        expect(commit.committer!.login).to(equal("octocat"))
        expect(commit.author!.login).to(equal("octocat"))
        expect(commit.commitDate).to(equal(NSDate(timeIntervalSince1970: 0)))
        expect((commit.countOfChanges)).to(equal(0))
        expect((commit.countOfAdditions)).to(equal(0))
        expect((commit.countOfDeletions)).to(equal(0))
        expect(commit.files).to(beEmpty())
      }

      it("parsing a full commit") {
        let commit = GitCommit(Helper.readJSON("git_commit_full") as JSONDictionary)

        expect(commit.commitURL).to(equal(NSURL(string: "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e")))
        expect(commit.message).to(equal("Fix all the bugs"))
        expect(commit.SHA).to(equal("6dcb09b5b57875f334f61aebed695e2e4193db5e"))
        expect(commit.committer!.login).to(equal("octocat"))
        expect(commit.author!.login).to(equal("octocat"))
        expect(commit.commitDate).to(equal(NSDate(timeIntervalSince1970: 0)))
        expect((commit.countOfChanges)).to(equal(108))
        expect((commit.countOfAdditions)).to(equal(104))
        expect((commit.countOfDeletions)).to(equal(4))
        expect((commit.files.count)).to(equal(1))
      }
    }
  }
}
