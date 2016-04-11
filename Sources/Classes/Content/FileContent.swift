//
//  FileContent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 11/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar
import Tailor

// A file in a git repository.
public class FileContent: Content {
  
  // The encoding of the file content.
  public private(set) var encoding: String = ""
  
  // The raw, encoded, content of the file.
  //
  // See `encoding` for the encoding used.
  public private(set) var content: String = ""
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    encoding <- map.property("encoding")
    content <- map.property("content")
  }
}
