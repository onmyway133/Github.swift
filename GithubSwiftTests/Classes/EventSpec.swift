//
//  EventSpec.swift
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

class EventSpec: QuickSpec {
  override func spec() {

    describe("event") {
      var events: [String: GithubSwift.Event] = [:]

      beforeEach {
        (Helper.readJSON("events") as JSONArray).flatMap({ GithubSwift.Event.cluster($0) as? GithubSwift.Event }).forEach {
          events[$0.objectID] = $0
        }

        print(events)
      }

      it("OCTCommitCommentEvent should have deserialized") {
        let event = events["1605861091"] as! CommitCommentEvent

        expect(event.repositoryName).to(equal("github/twui"))
        expect(event.actorLogin).to(equal("galaxas0"))
        expect(event.organizationLogin).to(equal("github"))
        expect(event.date).to(equal(Formatter.date(string: "2012-10-02 22:03:12 +0000")))
      }

      it("OCTPullRequestCommentEvent should have deserialized") {
        let event = events["1605868324"] as! PullRequestCommentEvent

        expect(event.repositoryName).to(equal("github/ReactiveCocoa"))
        expect(event.actorLogin).to(equal("jspahrsummers"))
        expect(event.organizationLogin).to(equal("github"))

        expect(event.comment!.reviewComment!.position).to(equal(14))
        expect(event.comment!.originalPosition).to(equal(14))
        expect(event.comment!.reviewComment!.commitSHA).to(equal("7e731834f7fa981166cbb509a353dbe02eb5d1ea"))
        expect(event.comment!.originalCommitSHA).to(equal("7e731834f7fa981166cbb509a353dbe02eb5d1ea"))
        expect(event.pullRequest).to(beNil())
      }

      it("OCTIssueCommentEvent should have deserialized") {
        let event = events["1605861266"] as! IssueCommentEvent

        expect(event.repositoryName).to(equal("github/twui"))
        expect(event.actorLogin).to(equal("galaxas0"))
        expect(event.organizationLogin).to(equal("github"))
      }

      it("OCTPushEvent should have deserialized") {
        let event = events["1605847260"] as! PushEvent

        expect(event.repositoryName).to(equal("github/ReactiveCocoa"))
        expect(event.actorLogin).to(equal("joshaber"))
        expect(event.organizationLogin).to(equal("github"))

        expect((event.commitCount)).to(equal(36))
        expect((event.distinctCommitCount)).to(equal(5))
        expect(event.previousHeadSHA).to(equal("623934b71f128f9bcc44482d6dc76b7fd4848d4d"))
        expect(event.currentHeadSHA).to(equal("da01b97c85d2a2d2b8e4021c2e3dff693a8f2c6b"))
        expect(event.branchName).to(equal("new-demo"))
      }

      it("OCTPullRequestEvent should have deserialized") {
        let event = events["1605849683"] as! PullRequestEvent

        expect(event.repositoryName).to(equal("github/ReactiveCocoa"))
        expect(event.actorLogin).to(equal("joshaber"))
        expect(event.organizationLogin).to(equal("github"))

        expect((event.action)).to(equal(IssueAction.Opened))
      }

      it("OCTPullRequestEventAssignee should have deserialized") {
        let event = events["1605825804"] as! PullRequestEvent

        expect(event.pullRequest!.assignee!.objectID).to(equal("432536"))
        expect(event.pullRequest!.assignee!.login).to(equal("jspahrsummers"))
      }

      it("OCTIssueEvent should have deserialized") {
        let event = events["1605857918"] as! IssueEvent

        expect(event.repositoryName).to(equal("github/twui"))
        expect(event.actorLogin).to(equal("jwilling"))
        expect(event.organizationLogin).to(equal("github"))

        expect((event.action)).to(equal(IssueAction.Opened))

      }

      it("OCTRefEvent should have deserialized") {
        let event = events["1605847125"] as! RefEvent

        expect(event.repositoryName).to(equal("github/ReactiveCocoa"))
        expect(event.actorLogin).to(equal("joshaber"))
        expect(event.organizationLogin).to(equal("github"))

        expect((event.refType)).to(equal((RefType.Branch)))
        expect((event.eventType)).to(equal(RefEventType.Created))
        expect(event.refName).to(equal("perform-selector"))
      }

      it("OCTForkEvent should have deserialized") {
        let event = events["2483893273"] as! ForkEvent

        expect(event.repositoryName).to(equal("thoughtbot/Argo"))
        expect(event.actorLogin).to(equal("jspahrsummers"))

        expect(event.forkedRepositoryName).to(equal("jspahrsummers/Argo"))
      }

      it("OCTMemberEvent should have deserialized") {
        let event = events["2472813496"] as! MemberEvent

        expect(event.repositoryName).to(equal("niftyn8/degenerate"))
        expect(event.actorLogin).to(equal("niftyn8"))

        expect(event.memberLogin).to(equal("houndci"))
        expect((event.action)).to(equal((MemberAction.Added)))
      }

      it("OCTPublicEvent should have deserialized") {
        let event = events["2485152382"] as! PublicEvent

        expect(event.repositoryName).to(equal("ethanjdiamond/AmIIn"))
        expect(event.actorLogin).to(equal("ethanjdiamond"))
      }

      it("OCTWatchEvent should have deserialized") {
        let event = events["2484426974"] as! WatchEvent

        expect(event.repositoryName).to(equal("squiidz/bone"))
        expect(event.actorLogin).to(equal("mattmassicotte"))
      }
    }
  }
}
