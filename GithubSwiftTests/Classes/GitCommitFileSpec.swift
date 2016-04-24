//
//  GitCommitFileSpec.swift
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

class GitCommitFileSpec: QuickSpec {
  override func spec() {

    describe("git commit file") {
      it("should initialize") {
        let file = GitCommitFile(Helper.readJSON("git_commit_file") as JSONDictionary)

        expect(file.fileName).to(equal("file1.txt"))
        expect((file.countOfAdditions)).to(equal(10))
        expect((file.countOfDeletions)).to(equal(2))
        expect((file.countOfChanges)).to(equal(12))
        expect(file.status).to(equal("modified"))
        expect(file.rawURL).to(equal(NSURL(string: "https://github.com/octocat/Hello-World/raw/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt")))
        expect(file.blobURL).to(equal(NSURL(string: "https://github.com/octocat/Hello-World/blob/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt")))
        expect(file.patch).to(equal(" -29,7 +29,7 ....."))
      }
    }
  }
}
