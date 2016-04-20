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

  // If not nil, the new filename to set for the file.
  public private(set) var filename: String = ""

  // If not nil, the new content to set for the file.
  public private(set) var content: String = ""

  public required init(_ map: JSONDictionary) {
    self.filename <- map.property("filename")
    self.content <- map.property("content")
  }
}
