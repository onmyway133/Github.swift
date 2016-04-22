//
//  MemberEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// The type of action performed.
//
// OCTMemberActionUnknown      - An unknown action occurred. Member events will
//                               never be initialized with this value -- they
//                               will simply fail to be created.
// OCTMemberActionAdded        - The user was added as a collaborator to the repository.

public enum MemberAction: String {
  case Unknown
  case Added = "added"
}

// A user was added as a collaborator to a repository.
public class MemberEvent: Event {

  // The login of the user that was added to the repository.
  public private(set) var memberLogin: String = ""

  // The action that took place.
  public private(set) var action: MemberAction = .Unknown

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.memberLogin <- map.path("payload.member")?.property("login")
    self.action <- map.path("payload")?.`enum`("action")
  }
}
