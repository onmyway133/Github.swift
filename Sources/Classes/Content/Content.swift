//
//  Content.swift
//  GithubSwift
//
//  Created by Khoa Pham on 11/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Sugar
import Tailor

// A class cluster for content in a repository, hereforth just “item”. Such as
// files, directories, symlinks and submodules.
public class Content: Object {
  
  // The size of the content, in bytes.
  public private(set) var size: Int = 0
  
  // The name of the item.
  public private(set) var name: String = ""
  
  // The relative path from the repository root to the item.
  public private(set) var path: String = ""
  
  // The sha reference of the item.
  public private(set) var SHA: String = ""
  
  // The type of content which the receiver represents.
  public private(set) var type: String = ""
  
  public required init(_ map: JSONDictionary) {
    super.init(map)
    
    size <- map.property("size")
    name <- map.property("name")
    path <- map.property("path")
    SHA <- map.property("sha")
    type <- map.property("type")
  }
  
  public static func make(map: JSONDictionary) -> Content {
    let mapping: [String: Content.Type] = [
      "file": FileContent.self,
      "dir": DirectoryContent.self,
      "symlink": SymlinkContent.self,
      "submodule": SubmoduleContent.self,
    ]
    
    if let type = map["type"] as? String,
      contentClass = mapping[type] {
      return contentClass.init(map)
    } else {
      fatalError()
    }
  }
}
