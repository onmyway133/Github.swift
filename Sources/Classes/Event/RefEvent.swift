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
// OCTRefKindUnknown    - An unknown type of reference. Ref events will never
//                        be initialized with this value -- they will simply
//                        fail to be created.
// OCTRefKindBranch     - A branch in a repository.
// OCTRefKindTag        - A tag in a repository.
// OCTRefKindRepository - A repository.
public enum RefKind: String {
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
public enum RefEventKind: String {
  case Unknown
  case Created = "CreateEvent"
  case Deleted = "DeleteEvent"
}

// A git reference (branch or tag) was created or deleted.
public class RefEvent: Event {

  // The kind of reference that was created or deleted.
  public private(set) var refKind: RefKind = .Unknown

  // The type of event that occurred with the reference.
  public private(set) var eventKind: RefEventKind = .Unknown

  // The short name of this reference (e.g., "master").
  public private (set) var refName: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.refName <- map.path("payload")?.property("ref")
    self.refKind <- map.path("payload")?.`enum`("ref_type")
    self.eventKind <- map.`enum`("type")
  }
}
