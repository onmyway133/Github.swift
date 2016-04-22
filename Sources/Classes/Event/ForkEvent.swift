//
//  ForkEvent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 22/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A user forked a repository.
public class ForkEvent: Event {

  // The name of the repository created by forking (e.g., `user/Mac`)
  public private(set) var forkedRepositoryName: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.forkedRepositoryName <- map.path("payload.forkee")?.property("full_name")
  }
}
