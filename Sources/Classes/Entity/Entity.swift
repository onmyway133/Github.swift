//
//  Entity.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Represents any GitHub object which is capable of owning repositories.
public class Entity: Object {
  
  // The unique name for this entity, used in GitHub URLs.
  public private(set) var login: String = ""
  
  // The full name of this entity.
  //
  // Returns `login` if no name is explicitly set.
  public private(set) var name: String = ""
  
  // The short biography associated with this account.
  public private(set) var bio: String = ""
  
  // The OCTRepository objects associated with this entity.
  //
  // OCTClient endpoints do not actually set this property. It is provided as
  // a convenience for persistence and model merging.
  public var repositories: [Repository] = []
  
  // The email address for this account.
  public private(set) var email: String = ""
  
  // The URL for any avatar image.
  public private(set) var avatarURL: NSURL?
  
  // The web URL for this account.
  public private(set) var htmlURL: NSURL?
  
  // A reference to a blog associated with this account.
  public private(set) var blog: String = ""
  
  // The name of a company associated with this account.
  public private(set) var company: String = ""
  
  // The location associated with this account.
  public private(set) var location: String = ""
  
  // The total number of collaborators that this account has on their private repositories.
  public private(set) var collaborators: Int = 0
  
  // The number of public repositories owned by this account.
  public private(set) var publicRepoCount: Int = 0
  
  // The number of private repositories owned by this account.
  public private(set) var privateRepoCount: Int = 0
  
  // The number of public gists owned by this account.
  public private(set) var publicGistCount: Int = 0
  
  // The number of private gists owned by this account.
  public private(set) var privateGistCount: Int = 0
  
  // The number of followers for this account.
  public private(set) var followers: Int = 0
  
  // The number of following for this account.
  public private(set) var following: Int = 0
  
  // The number of kilobytes occupied by this account's repositories on disk.
  public private(set) var diskUsage: Int = 0
  
  // The plan that this account is on.
  public private(set) var plan: Plan?
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    login <- map.property("login")
    name <- map.property("name")
    bio <- map.property("bio")
    repositories <- map.relations("repositories")
    email <- map.property("email")
    avatarURL <- map.transform("avatar_url", transformer: Transformer.stringToURL)
    htmlURL <- map.transform("html_url", transformer: Transformer.stringToURL)
    blog <- map.property("blog")
    company <- map.property("company")
    location <- map.property("location")
    collaborators <- map.property("collaborators")
    publicRepoCount <- map.property("public_repos")
    privateRepoCount <- map.property("owned_private_repos")
    publicGistCount <- map.property("public_gists")
    privateGistCount <- map.property("private_gists")
    followers <- map.property("followers")
    following <- map.property("following")
    diskUsage <- map.property("disk_usage")
    plan <- map.relation("plan")
    
    if name.isEmpty {
      name = login
    }
  }
}
