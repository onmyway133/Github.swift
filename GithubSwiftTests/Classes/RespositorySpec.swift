//
//  RespositorySpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 11/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class RepositorySpec: QuickSpec {
  override func spec() {
    describe("repository") {
      
      let json = Helper.readJSON("repository1")
      let repository = Parser.one([json]) as Repository
      
      it("should initialize") {
        expect(repository.objectID).to(equal("1296269"))
        expect(repository.name).to(equal("Hello-World"))
        expect(repository.repoDescription).to(equal("This your first repo!"))
        expect(repository.isPrivate).to(beFalsy())
        expect(repository.isFork).to(beFalsy())
        expect(repository.ownerLogin).to(equal("octocat"))
        expect(repository.datePushed).to(equal(Formatter.date(string: "2011-01-26 19:06:43 +0000")))
        expect(repository.HTTPSURL).to(equal(NSURL(string: "https://github.com/octocat/Hello-World.git")))
        expect(repository.HTMLURL).to(equal(NSURL(string: "https://github.com/octocat/Hello-World")))
        expect(repository.SSHURLString).to(equal("gitgithub.com:octocat/Hello-World.git"))
        expect(repository.defaultBranch).to(equal("master"))
        expect(repository.watchersCount).to(equal(1403))
        expect(repository.forksCount).to(equal(1091))
        expect(repository.stargazersCount).to(equal(1403))
        expect(repository.openIssuesCount).to(equal(129))
        expect(repository.subscribersCount).to(equal(1832))
        
        expect(repository.forkSource).notTo(beNil())
        expect(repository.forkSource!.objectID).to(equal("1296268"))
        
        expect(repository.forkParent).notTo(beNil())
        expect(repository.forkParent!.objectID).to(equal("1296267"))
      }
      
      it("should set its nested OCTObjects' servers") {
        let url = NSURL(string: "https://myserver.com")!
        repository.baseURL = url
        expect(repository.forkParent!.baseURL).to(equal(url))
        expect(repository.forkSource!.baseURL).to(equal(url))
      }
    }
  }
}
