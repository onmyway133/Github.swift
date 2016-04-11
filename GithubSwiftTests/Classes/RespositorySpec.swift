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
      
      let json = [
        "url": "https://api.github.com/repos/octocat/Hello-World",
        "html_url": "https://github.com/octocat/Hello-World",
        "clone_url": "https://github.com/octocat/Hello-World.git",
        "git_url": "git://github.com/octocat/Hello-World.git",
        "ssh_url": "gitgithub.com:octocat/Hello-World.git",
        "svn_url": "https://svn.github.com/octocat/Hello-World",
        "mirror_url": "git://git.example.com/octocat/Hello-World",
        "id": 1296269,
        "owner": [
          "login": "octocat",
          
          // Omitted because the JSON parsing does not preserve these keys.
          /*
           "id": 1,
           "avatar_url": "https://github.com/images/error/octocat_happy.gif",
           "gravatar_id": "somehexcode",
           "url": "https://api.github.com/users/octocat"
           */
        ],
        "name": "Hello-World",
        "full_name": "octocat/Hello-World",
        "description": "This your first repo!",
        "homepage": "https://github.com",
        "language": nil,
        "private": false,
        "fork": false,
        "watchers": 1403,
        "watchers_count": 1403,
        "forks": 1091,
        "forks_count": 1091,
        "stargazers_count": 1403,
        "open_issues": 129,
        "open_issues_count": 129,
        "subscribers_count": 1832,
        "size": 108,
        "master_branch": "master",
        "pushed_at": "2011-01-26T19:06:43Z",
        "created_at": "2011-01-26T19:01:12Z",
        "updated_at": "2011-01-26T19:14:43Z",
        "default_branch": "master",
        "source": [
          "html_url": "https://github.com/octocat/Hello-World",
          "clone_url": "https://github.com/octocat/Hello-World.git",
          "git_url": "git://github.com/octocat/Hello-World.git",
          "ssh_url": "gitgithub.com:octocat/Hello-World.git",
          "id": 1296268,
          "owner": [
            "login": "octocat",
          ],
          "name": "Hello-World",
          "description": "This your first repo!",
          "language": nil,
          "private": false,
          "fork": false,
          "pushed_at": "2011-01-26T19:06:43Z",
          "default_branch": "master",
        ],
        "parent": [
          "html_url": "https://github.com/octocat/Hello-World",
          "clone_url": "https://github.com/octocat/Hello-World.git",
          "git_url": "git://github.com/octocat/Hello-World.git",
          "ssh_url": "gitgithub.com:octocat/Hello-World.git",
          "id": 1296267,
          "owner": [
            "login": "octocat",
          ],
          "name": "Hello-World",
          "description": "This your first repo!",
          "language": nil,
          "private": false,
          "fork": false,
          "pushed_at": "2011-01-26T19:06:43Z",
          "default_branch": "master",
        ]
      ]
      
      let respository = Parser.one([json]) as Repository
      
        it("should initialize") {
          expect(repository.objectID).to(equal("1296269"))
          expect(repository.name).to(equal("Hello-World"))
          expect(repository.repoDescription).to(equal("This your first repo!"))
          expect(repository.isPrivate).to(beFalsy())
          expect(repository.isFork).to(beFalsy())
          expect(repository.ownerLogin).to(equal("octocat"))
          expect(repository.datePushed).to(equal(Formatter.date(string: "2011-01-26 19:06:43 +0000"))
          expect(repository.HTTPSURL).to(equal(NSURL(string: "https://github.com/octocat/Hello-World.git")))
          expect(repository.htmlURL).to(equal(NSURL(string: "https://github.com/octocat/Hello-World")))
          expect(repository.SSHURL).to(equal("gitgithub.com:octocat/Hello-World.git"))
          expect(repository.defaultBranch).to(equal("master"))
          expect((repository.watchersCount)).to(equal(1403))
          expect((repository.forksCount)).to(equal(1091))
          expect((repository.stargazersCount)).to(equal(1403))
          expect((repository.openIssuesCount)).to(equal(129))
          expect((repository.subscribersCount)).to(equal(1832))
          
          expect(repository.forkSource).notTo(beNil())
          expect(repository.forkSource.objectID).to(equal("1296268"))
          
          expect(repository.forkParent).notTo(beNil())
          expect(repository.forkParent.objectID).to(equal("1296267"))
        }
        
        it("should set its nested OCTObjects' servers") {
          let url = NSURL(string: "https://myserver.com")
          repository.baseURL = url
          expect(repository.forkParent.baseURL).to(equal(url))
          expect(repository.forkSource.baseURL).to(equal(url))
        }
    }
  }
}
