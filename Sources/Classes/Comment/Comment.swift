//
//  Comment.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A comment can be added to an issue, pull request, or commit.
public class Comment: Object {

  // The login of the user who created this comment.
  public private(set) var commenterLogin: String = ""

  // The date at which the comment was originally created.
  public private(set) var creationDate: NSDate?

  // The date the comment was last updated. This will be equal to
  // creationDate if the comment has not been updated.
  public private(set) var updatedDate: NSDate?

  // The body of the comment.
  public private(set) var body: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.commenterLogin <- map.dictionary("user")?.property("login")
    self.creationDate <- map.transform("created_at", transformer: Transformer.stringToDate)
    self.updatedDate <- map.transform("updated_at", transformer: Transformer.stringToDate)
    self.body <- map.property("body")
  }
}
