//
//  GistFileEdit.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Changes to a single file, or a new file, within a gist.
public class GistFileEdit: Mappable {

  // If not nil, the new fileName to set for the file.
  public var fileName: String = ""

  // If not nil, the new content to set for the file.
  public var content: String = ""

  public required init(_ map: JSONDictionary) {
    self.fileName <- map.property("fileName")
    self.content <- map.property("content")
  }

  public init() {}
}
