//
//  Client+NotificationSpec.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import GithubSwift
import Quick
import Nimble
import Mockingjay
import RxSwift
import Sugar

class ClientNotificationSpec: QuickSpec {
  
  override func spec() {
    
    describe("authenticated") {
      var client: Client!
      var user: User!
      
      beforeEach {
        user = User(rawLogin: "octokit-testing-user", server: Server.dotComServer)
        client = Client(authenticatedUser: user, token: "")
      }
      
      it("should fetch notifications") {
        self.stub(uri("/notifications"), builder: jsonData(Helper.read("notifications")))

        let observable = client.fetchNotifications(etag: nil, includeRead: false, updatedSince: nil)
        
        self.async { expectation in
          let _ = observable.subscribeNext { notifications in
            
            let notification = notifications[0]
            
            expect(notification.objectID).to(equal("1"))
            expect(notification.title).to(equal("Greetings"))
            expect(notification.threadURL).to(equal(NSURL(string: "https://api.github.com/notifications/threads/1")))
            expect(notification.subjectURL).to(equal(NSURL(string: "https://api.github.com/repos/pengwynn/octokit/issues/123")))
            expect(notification.latestCommentURL).to(equal(NSURL(string: "https://api.github.com/repos/pengwynn/octokit/issues/comments/123")))
            expect((notification.type)).to(equal((NotificationType.Issue)))
            expect(notification.lastUpdatedDate).to(equal(Formatter.date(string: "2012-09-25T07:54:41-07:00")))
            
            expect(notification.repository).notTo(beNil())
            expect(notification.repository?.name ?? "").to(equal("Hello-World"))
            
            expectation.fulfill()
          }
        }
      }
      
      it("should return nothing if notifications are unmodified") {
        self.stub(uri("/notifications"), builder: http(304))
        
        let result = client.fetchNotifications(etag: nil, includeRead: false, updatedSince: nil).subscribeSync()
      
        guard result.next == nil else {
          fail()
          return
        }
      }
    }
  }
}
