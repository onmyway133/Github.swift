//
//  PushEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Some commits got pushed.
public class PushEvent: Event {

  // The number of commits included in this push.
  //
  // Merges count for however many commits were introduced by the other branch.
  public private(set) var commitCount: Int = 0

  // The number of distinct commits included in this push.
  public private(set) var distinctCommitCount: Int = 0

  // The SHA for HEAD prior to this push.
  public private(set) var previousHeadSHA: String = ""

  // The SHA for HEAD after this push.
  public private(set) var currentHeadSHA: String = ""

  // The branch to which the commits were pushed.
  public private(set) var branchName: String = ""

  // The commits were pushed, in which was the NSDictionary object.
  public private(set) var commits: JSONArray = []

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.commitCount <- map.path("payload")?.property("size")
    self.distinctCommitCount <- map.path("payload")?.property("distinct_size")
    self.previousHeadSHA <- map.path("payload")?.property("before")
    self.currentHeadSHA <- map.path("payload")?.property("head")
    self.branchName <- map.path("payload")?.property("ref")
    self.commits <- map.path("payload")?.property("commits")
  }
}

public extension Transformer {
  public static func refToBranchName(ref: String) -> String? {
    let branchRefPrefix = "refs/heads/"
    return ref.hasPrefix(branchRefPrefix) ? nil : ref.substringFromIndex(ref.startIndex.advancedBy(branchRefPrefix.characters.count))
  }
}
