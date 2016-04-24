//
//  GistFile.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A single file within a gist.
public class GistFile: Object {

  // The path to this file within the gist.
  public private(set) var fileName: String = ""

  // A direct URL to the raw file contents.
  public private(set) var rawURL: NSURL?

  // The size of the file, in bytes.
  public private(set) var  size: Int = 0

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.fileName <- map.property("fileName")
    self.rawURL <- map.transform("raw_url", transformer: NSURL.init(string: ))
    self.size <- map.property("size")
  }
}
