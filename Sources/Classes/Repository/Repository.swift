//
//  Repository.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A GitHub repository.
public class Repository: Object {
  
  // The name of this repository, as used in GitHub URLs.
  //
  // This is the second half of a unique GitHub repository name, which follows the
  // form `ownerLogin/name`.
  public private(set) var name: String = ""
  
  // The login of the account which owns this repository.
  //
  // This is the first half of a unique GitHub repository name, which follows the
  // form `ownerLogin/name`.
  public private(set) var ownerLogin: String = ""
  
  // The URL for any avatar image.
  public private(set) var ownerAvatarURL: NSURL?
  
  // The description of this repository.
  public private(set) var repoDescription: String = ""
  
  // The language of this repository.
  public private(set) var language: String = ""
  
  // Whether this repository is private to the owner.
  public private(set) var isPrivate: Bool = false
  
  // Whether this repository is a fork of another repository.
  public private(set) var isFork: Bool = false
  
  // The date of the last push to this repository.
  public private(set) var datePushed: NSDate?
  
  // The created date of this repository.
  public private(set) var dateCreated: NSDate?
  
  // The last updated date of this repository.
  public private(set) var dateUpdated: NSDate?
  
  // The number of watchers for this repository.
  public private(set) var watchersCount: Int = 0
  
  // The number of forks for this repository.
  public private(set) var forksCount: Int = 0
  
  // The number of stargazers for this repository.
  public private(set) var stargazersCount: Int = 0
  
  // The number of open issues for this repository.
  public private(set) var openIssuesCount: Int = 0
  
  // The number of subscribers for this repository.
  public private(set) var subscribersCount: Int = 0
  
  // The URL for pushing and pulling this repository over HTTPS.
  public private(set) var HTTPSURL: NSURL?
  
  // The URL for pushing and pulling this repository over SSH, formatted as
  // a string because SSH URLs are not correctly interpreted by NSURL.
  public private(set) var SSHURLString: String = ""
  
  // The URL for pulling this repository over the `git://` protocol.
  public private(set) var gitURL: NSURL?
  
  // The URL for visiting this repository on the web.
  public private(set) var htmlURL: NSURL?
  
  // The default branch's name. For empty repositories, this will be nil.
  public private(set) var defaultBranch: String = ""
  
  // The URL for the issues page in a repository.
  //
  // An issue number may be appended (as a path component) to this path to create
  // an individual issue's HTML URL.
  public private(set) var issuesHTMLURL: NSURL?
  
  // Text match metadata, uses to highlight the search results.
  public private(set) var textMatches: [String] = []
  
  /// The parent of the fork, or nil if the repository isn't a fork. This is the
  /// repository from which the receiver was forked.
  ///
  /// Note that this is only populated on calls to
  /// -[OCTClient fetchRepositoryWithName:owner:].
  public private(set) var forkParent: Repository?
  
  /// The source of the fork, or nil if the repository isn't a fork. This is the
  /// ultimate source for the network, which may be different from the
  /// `forkParent`.
  ///
  /// Note that this is only populated on calls to
  /// -[OCTClient fetchRepositoryWithName:owner:].
  public private(set) var forkSource: Repository?
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    self.name <- map.property("name")
    self.ownerLogin <- map.dictionary("owner")?.property("login")
    self.ownerAvatarURL <- map.dictionary("owner")?.transform("avatar_url", transformer: Transformer.stringToURL)
    self.repoDescription <- map.property("description")
    self.language <- map.property("language")
    self.isPrivate <- map.property("private")
    self.isFork <- map.property("fork")
    self.datePushed <- map.transform("pushed_at", transformer: Transformer.stringToDate)
    self.dateCreated <- map.transform("created_at", transformer: Transformer.stringToDate)
    self.dateUpdated <- map.transform("updated_at", transformer: Transformer.stringToDate)
    self.watchersCount <- map.property("watchers_count")
    self.forksCount <- map.property("forks_count")
    self.stargazersCount <- map.property("stargazers_count")
    self.openIssuesCount <- map.property("open_issues_count")
    self.subscribersCount <- map.property("subscribers_count")
    self.HTTPSURL <- map.transform("clone_url", transformer: Transformer.stringToURL)
    self.SSHURLString <- map.property("ssh_url")
    self.gitURL <- map.transform("git_url", transformer: Transformer.stringToURL)
    self.htmlURL <- map.transform("html_url", transformer: Transformer.stringToURL)
    self.defaultBranch <- map.property("default_branch")
    self.textMatches <- map.property("text_matches")
    self.forkParent <- map.relation("parent")
    self.forkSource <- map.relation("source")
  }
  
  public override var baseURL: NSURL? {
    didSet {
      forkParent?.baseURL = baseURL
      forkSource?.baseURL = baseURL
    }
  }
}
