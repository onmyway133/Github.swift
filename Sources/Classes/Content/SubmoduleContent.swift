//
//  SubmoduleContent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 11/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar
import Tailor

// A submodule in a git repository.
public class SubmoduleContent: Content {
  
  // The git URL of the submodule.
  public private(set) var submoduleGitURL: NSURL?
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    submoduleGitURL <- map.transform("submodule_git_url", transformer: Transformer.stringToURL)
  }
}
