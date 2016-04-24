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
        let ref = Ref(Helper.readJSON("ref") as JSONDictionary)


      }
    }
  }
}
