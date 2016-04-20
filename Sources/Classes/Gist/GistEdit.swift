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
  public private(set) var gistDescription: String = ""

  // Files to modify, represented as OCTGistFileEdits keyed by filename.
  public private(set) var filesToModify: [GistFileEdit] = []

  // Files to add, represented as OCTGistFileEdits.
  //
  // Each edit must have a `filename` and `content`.
  public private(set) var filesToAdd: [GistFileEdit] = []

  // The names of files to delete.
  public private(set) var filenamesToDelete: [String] = []

  // A combination of the information in `filesToModify`, `filesToAdd`, and
  // `filenamesToDelete`, used for easy JSON serialization.
  //
  // This dictionary contains OCTGistFileEdits keyed by filename. Deleted
  // filenames will have an NSNull value.
  public private(set) var fileChanges: [GistFileEdit] = []

  // Whether this gist should be public.
  public private(set) var isPublicGist: Bool = true

  public required init(_ map: JSONDictionary) {
    self.gistDescription <- map.property("description")
    self.isPublicGist <- map.property("public")
  }
}
