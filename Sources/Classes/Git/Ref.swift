//
//  Ref.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A git reference.
public class Ref: Object {

  // The fully qualified name of this reference.
  public private(set) var name: String = ""

  // The SHA of the git object that this ref points to.
  public private(set) var SHA: String = ""

  // The API URL to the git object that this ref points to.
  public private(set) var objectURL: NSURL?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.name <- map.property("ref")
    self.SHA <- map.path("object")?.property("sha")
    self.objectURL <- map.path("object")?.transform("url", transformer: NSURL.init(string: ))
  }
}
