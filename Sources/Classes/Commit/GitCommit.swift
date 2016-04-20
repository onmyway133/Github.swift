//
//  GitCommit.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A git commit.
public class GitCommit: Object {

  // The commit URL for this commit.
  public private(set) var commitURL: NSURL?

  // The commit message for this commit.
  public private(set) var message: String = ""

  // The SHA for this commit.
  public private(set) var SHA: String = ""

  // The committer of this commit.
  public private(set) var committer: User?

  // The author of this commit.
  public private(set) var author: User?

  // The date the author signed the commit.
  public private(set) var commitDate: NSDate?

  // The number of changes made in the commit.
  // This property is only set when fetching a full commit.
  public private(set) var  countOfChanges: Int = 0

  // The number of additions made in the commit.
  // This property is only set when fetching a full commit.
  public private(set) var countOfAdditions: Int = 0

  // The number of deletions made in the commit.
  // This property is only set when fetching a full commit.
  public private(set) var countOfDeletions: Int = 0

  // The OCTGitCommitFile objects changed in the commit.
  // This property is only set when fetching a full commit.
  public private(set) var files: [GitCommitFile] = []

  // The authors git user.name property. This is only useful if the
  // author does not have a GitHub login. Otherwise, author should
  // be used.
  public private(set) var authorName: String = ""

  // The committer's git user.name property. This is only useful if the
  // committer does not have a GitHub login. Otherwise, committer should
  // be used.
  public private(set) var committerName: String = ""

  public required init(_ map: JSONDictionary) {
    super.init(map)

    let commit = map.dictionary("commit")
    let author = commit?.dictionary("author")
    let stats = map.dictionary("stats")

    self.commitURL <- map.transform("url", transformer: Transformer.stringToURL)
    self.message <- commit?.property("message")
    self.SHA <- map.property("sha")
    self.committer <- map.relation("commiter")
    self.author <- map.relation("author")
    self.commitDate <- author?.transform("date", transformer: Transformer.stringToDate)
    self.countOfAdditions <- stats?.property("additions")
    self.countOfDeletions <- stats?.property("deletions")
    self.countOfChanges <- stats?.property("total")
    self.files <- map.relations("files")
    self.authorName <- author?.property("name")
    self.committerName <- commit?.dictionary("committer")?.property("name")
  }
}
