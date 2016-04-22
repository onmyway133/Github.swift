//
//  RefEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Represents the type of a git reference.
//
// OCTRefTypeUnknown    - An unknown type of reference. Ref events will never
//                        be initialized with this value -- they will simply
//                        fail to be created.
// OCTRefTypeBranch     - A branch in a repository.
// OCTRefTypeTag        - A tag in a repository.
// OCTRefTypeRepository - A repository.
public enum RefType: String {
  case Unknown
  case Branch = "branch"
  case Tag = "tag"
  case Repository = "repository"
}

// The type of event that occurred around a reference.
//
// OCTRefEventUnknown - An unknown event occurred. Ref events will never be
//                      initialized with this value -- they will simply
//                      fail to be created.
// OCTRefEventCreated - The reference was created on the server.
// OCTRefEventDeleted - The reference was deleted on the server.
public enum RefEventType: String {
  case Unknown
  case Created = "CreateEvent"
  case Deleted = "DeleteEvent"
}

// A git reference (branch or tag) was created or deleted.
public class RefEvent: Event {

  // The kind of reference that was created or deleted.
  public private(set) var refType: RefType = .Unknown

  // The type of event that occurred with the reference.
  public private(set) var eventType: RefEventType = .Unknown

  // The short name of this reference (e.g., "master").
  public private (set) var refName: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.refName <- map.path("payload")?.property("ref")
    self.refType <- map.path("payload")?.`enum`("ref_type")
    self.eventType <- map.`enum`("type")
  }
}
