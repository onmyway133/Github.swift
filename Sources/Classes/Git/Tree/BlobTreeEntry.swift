//
//  BlobTreeEntry.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A blob tree entry.
public class BlobTreeEntry: ContentTreeEntry {

  // The size of the blob in bytes.
  public private(set) var size: Int = 0

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.size <- map.property("size")
  }
}
