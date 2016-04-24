//
//  GitCommitFile.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A file of a commit
public class GitCommitFile: Object {

  // The fileName in the repository.
  public private(set) var fileName: String = ""

  // The number of additions made in the commit.
  public private(set) var countOfAdditions: Int = 0

  // The number of deletions made in the commit.
  public private(set) var countOfDeletions: Int = 0

  // The number of changes made in the commit.
  public private(set) var countOfChanges: Int = 0

  // The status of the commit, e.g. 'added' or 'modified'.
  public private(set) var status: String = ""

  // The GitHub URL for the whole file.
  public private(set) var rawURL: NSURL?

  // The GitHub blob URL.
  public private(set) var blobURL: NSURL?

  // The patch on this file in a commit.
  public private(set) var patch: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.fileName <- map.property("fileName")
    self.countOfAdditions <- map.property("additions")
    self.countOfDeletions <- map.property("deletions")
    self.countOfChanges <- map.property("changes")
    self.status <- map.property("status")
    self.rawURL <- map.transform("raw_url", transformer: NSURL.init(string: ))
    self.blobURL <- map.transform("blob_url", transformer: NSURL.init(string: ))
    self.patch <- map.property("patch")
  }
}
