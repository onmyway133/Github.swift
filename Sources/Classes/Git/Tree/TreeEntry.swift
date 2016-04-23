//
//  TreeEntry.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// The types of tree entries.
//   OCTTreeEntryTypeBlob   - A blob of data.
//   OCTTreeEntryTypeTree   - A tree of entries.
//   OCTTreeEntryTypeCommit - A commit.
public enum TreeEntryType: String {
  case Blob = "blob"
  case Tree = "tree"
  case Commit = "commit"
}

// The file mode of the entry.
//   OCTTreeEntryModeFile         - File (blob) mode.
//   OCTTreeEntryModeExecutable   - Executable (blob) mode.
//   OCTTreeEntryModeSubdirectory - Subdirectory (tree) mode.
//   OCTTreeEntryModeSubmodule    - Submodule (commit) mode.
//   OCTTreeEntryModeSymlink      - Blob which specifies the path of a symlink.
public enum TreeEntryMode: String {
  case File = "100644"
  case Executable = "100755"
  case Subdirectory = "040000"
  case Submodule = "160000"
  case Symlink = "120000"
}

// A class cluster for git tree entries.
public class TreeEntry: Object {

  // The SHA of the entry.
  public private(set) var SHA: String = ""

  // The repository-relative path.
  public private(set) var path: String = ""

  // The type of the entry.
  public private(set) var type: TreeEntryType = .Commit

  // The mode of the entry.
  public private(set) var mode: TreeEntryMode = .File

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.SHA <- map.property("sha")
    self.path <- map.property("path")
    self.type <- map.property("type")
    self.type <- map.`enum`("type")
    self.mode <- map.`enum`("mode")
  }

  public static func make(map: JSONDictionary) -> TreeEntry {
    let mapping: [TreeEntryType: TreeEntry.Type] = [
      .Commit: CommitTreeEntry.self,
      .Tree: ContentTreeEntry.self,
      .Blob: BlobTreeEntry.self,
      ]

    if let type = map["type"] as? TreeEntryType,
      entryself = mapping[type] {
      return entryself.init(map)
    } else {
      fatalError()
    }
  }
}

extension TreeEntry: JSONEncodable {
  public func toJSON() -> JSONDictionary {
    // FIXME
    return [:]
  }
}
