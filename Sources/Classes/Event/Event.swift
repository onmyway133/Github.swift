//
//  Event.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A class cluster for GitHub events.
public class Event: Object {

  // The name of the repository upon which the event occurred (e.g., `github/Mac`).
  public private(set) var repositoryName: String = ""

  // The login of the user who instigated the event.
  public private(set) var actorLogin: String = ""

  // The URL for the avatar of the user who instigated the event.
  public private(set) var actorAvatarURL: NSURL?

  // The organization related to the event.
  public private(set) var organizationLogin: String = ""

  // The date that this event occurred.
  public private(set) var date: NSDate?

  public private(set) var type: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.repositoryName <- map.dictionary("repo")?.property("name")
    self.actorLogin <- map.path("actor")?.property("login")
    self.actorAvatarURL <- map.path("actor")?.transform("avatar_url", transformer: NSURL.init(string: ))
    self.organizationLogin <- map.path("org")?.property("login")
    self.date <- map.transform("created_at", transformer: Transformer.stringToDate)
    self.type <- map.property("type")
  }
}
