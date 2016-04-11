//
//  SymlinkContent.swift
//  GithubSwift
//
//  Created by Khoa Pham on 11/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar
import Tailor

// A symlink in a git repository.
public class SymlinkContent: Content {
  
  // The path to the symlink target.
  public private(set) var target: String = ""
}
