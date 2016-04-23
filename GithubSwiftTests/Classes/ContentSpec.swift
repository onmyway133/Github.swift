//
//  ContentSpec.swift
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

class ContentSpec: QuickSpec {
  override func spec() {

    describe("content") {
      var contents: [String: Content] = [:]

      beforeEach {
        (Helper.readJSON("content") as JSONArray).map({ Content($0) }).forEach {
          contents[$0!.name] = $0
        }
      }

      it("DirectoryContent should have deserialized") {
        let content = contents["octokit"]! as! DirectoryContent

        expect(content.name).to(equal("octokit"))
        expect((content.size)).to(equal(0))
        expect(content.path).to(equal("lib/octokit"))
        expect(content.SHA).to(equal("a84d88e7554fc1fa21bcbc4efae3c782a70d2b9d"))
      }

      it("FileContent should have deserialized") {
        let content = contents["README.md"]! as! FileContent

        expect(content.name).to(equal("README.md"))
        expect((content.size)).to(equal(2706))
        expect(content.path).to(equal("README.md"))
        expect(content.SHA).to(equal("2eee5e61e61bec2346fd40d56719c2f28f5e0fc3"))
        expect(content.encoding).to(equal("base64"))
        expect(content.content).to(equal("dGhlIGJhc2U2NCBlbmNvZGVkIGRhdGHigKY="))
      }

      it("SubmobuleContent should have deserialized") {
        let content = contents["qunit"]! as! SubmoduleContent

        expect(content.name).to(equal("qunit"))
        expect((content.size)).to(equal(0))
        expect(content.path).to(equal("test/qunit"))
        expect(content.SHA).to(equal("6ca3721222109997540bd6d9ccd396902e0ad2f9"))
        expect(content.submoduleGitURL).to(equal("gitgithub.com:octokit/octokit.objc.git"))
      }

      it("SymlinkContent should have deserialized") {
        let content = contents["some-symlink"]! as! SymlinkContent

        expect(content.name).to(equal("some-symlink"))
        expect((content.size)).to(equal(23))
        expect(content.path).to(equal("bin/some-symlink"))
        expect(content.SHA).to(equal("452a98979c88e093d682cab404a3ec82babebb48"))
        expect(content.target).to(equal("/path/to/symlink/target"))
      }
    }
  }
}
