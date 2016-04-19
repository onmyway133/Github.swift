//
//  UserSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 19/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class UserSpec: QuickSpec {
  override func spec() {

    describe("github.com user") {
      it("should initialize from an external representation") {
        let user = User(Helper.readJSON("standard_user"))

        expect(user.server).to(equal(Server.dotComServer))
        expect(user.login).to(equal("octocat"))
        expect(user.name).to(equal("Mona Lisa Octocat"))
        expect(user.objectID).to(equal("1"))
        expect(user.avatarURL).to(equal(NSURL(string: "https://github.com/images/error/octocat_happy.gif")))
        expect(user.company).to(equal("GitHub"))
        expect(user.blog).to(equal("https://github.com/blog"))
        expect(user.email).to(equal("octocatgithub.com"))
        expect((user.publicRepoCount)).to(equal(2))
      }

      it("should initialize with a name and email") {
        let user = User(name: "foobar", email: "foobar.com")
        expect(user).notTo(beNil())

        expect(user.server).to(equal(Server.dotComServer))
        expect(user.name).to(equal("foobar"))
        expect(user.email).to(equal("foobar.com"))
      }

      it("should initialize with a login and server") {
        let user = User(rawLogin: "foo", server: Server.dotComServer)
        expect(user).notTo(beNil())

        expect(user.server).to(equal(Server.dotComServer))
        expect(user.rawLogin).to(equal("foo"))
      }

      it("should allow differing rawLogin and login properties") {
        let user = User(rawLogin: "octocatgithub.com", server: Server.dotComServer)

        expect(user).notTo(beNil())

        expect(user.server).to(equal(Server.dotComServer))
        expect(user.rawLogin).to(equal("octocatgithub.com"))
      }
    }

    describe("enterprise user") {
      let baseURL = NSURL(string: "https://10.168.0.109")!

      it("should initialize from an external representation") {
        let enterpriseServer = Server(baseURL: baseURL)
        let user = User(Helper.readJSON("enterprise_user"))

        // This is usually set by OCTClient, but we'll do it ourselves here to simulate
        // what OCTClient does.
        user.server = enterpriseServer

        expect(user.server).to(equal(enterpriseServer))

        expect(user.login).to(equal("jspahrsummers"))
        expect(user.objectID).to(equal("2"))
        expect(user.avatarURL).to(equal(NSURL(string: "https://secure.gravatar.com/avatar/cac992bb300ed4f3ed5c2a6049e552f9?d=http://10.168.1.109%2Fimages%2Fgravatars%2Fgravatar-user-420.png")))
        expect((user.publicRepoCount)).to(equal(0))
      }

      it("should initialize with a login and server") {
        let baseURL2 = NSURL(string: "https://10.168.1.109")!

        let server = Server(baseURL: baseURL2)
        let user = User(rawLogin: "foo", server: server)

        expect(user).notTo(beNil())
        expect(user.server).to(equal(server))
        expect(user.rawLogin).to(equal("foo"))
      }
    }
  }
}
