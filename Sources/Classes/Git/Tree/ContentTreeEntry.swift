//
//  ContentTreeEntry.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A tree entry which has URL-addressable content.
public class ContentTreeEntry: TreeEntry {

  // The URL for the content of the entry.
  public private(set) var URL: NSURL?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.URL <- map.transform("url", transformer: NSURL.init(string: ))
  }
}
