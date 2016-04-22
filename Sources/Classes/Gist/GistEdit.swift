//
//  GistEdit.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Changes to a gist, or a new gist.
public class GistEdit: Mappable {

  // If not nil, the new description to set for the gist.
  public var gistDescription: String = ""

  // Files to modify, represented as OCTGistFileEdits keyed by filename.
  public var filesToModify: [String: GistFileEdit] = [:]

  // Files to add, represented as OCTGistFileEdits.
  //
  // Each edit must have a `filename` and `content`.
  public var filesToAdd: [GistFileEdit] = []

  // The names of files to delete.
  public var filenamesToDelete: [String] = []

  // A combination of the information in `filesToModify`, `filesToAdd`, and
  // `filenamesToDelete`, used for easy JSON serialization.
  //
  // This dictionary contains OCTGistFileEdits keyed by filename. Deleted
  // filenames will have an NSNull value.
  public var fileChanges: [String: GistFileEdit?] {
    var files: [String: GistFileEdit?] = [:]

    files.update(filesToModify)
    filesToAdd.forEach {
      files[$0.filename] = $0
    }
    filenamesToDelete.forEach {
      files[$0] = nil as GistFileEdit?
    }

    return files
  }

  // Whether this gist should be public.
  public var isPublicGist: Bool = true

  public required init(_ map: JSONDictionary) {
    self.gistDescription <- map.property("description")
    self.isPublicGist <- map.property("public")
  }

  public init() {}
}

extension GistEdit: JSONEncodable {
  public func toJSON() -> JSONDictionary {
    var filesJSON: JSONDictionary = [:]

    fileChanges.forEach { key, fileEdit in
      if let fileEdit = fileEdit {
        filesJSON[key] = [
          "filename": fileEdit.filename,
          "content": fileEdit.content
        ]
      } else {
        filesJSON[key] = ""
      }
    }

    return [
      "public": isPublicGist,
      "description": gistDescription,
      "files": filesJSON
    ]
  }
}
