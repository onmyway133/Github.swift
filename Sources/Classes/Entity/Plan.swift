//
//  Plan.swift
//  Pods
//
//  Created by Khoa Pham on 25/03/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Represents the billing plan of a GitHub account.
public class Plan: Object {
  
  // The name of this plan.
  public private(set) var name: String = ""
  
  // The number of collaborators allowed by this plan.
  public private(set) var collaborators: Int = 0
  
  // The number of kilobytes of disk space allowed by this plan.
  public private(set) var space: Int = 0
  
  // The number of private repositories allowed by this plan.
  public private(set) var privateRepos: Int = 0
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    name <- map.property("name")
    collaborators <- map.property("collaborators")
    space <- map.property("space")
    privateRepos <- map.property("private_repos")
  }
}
