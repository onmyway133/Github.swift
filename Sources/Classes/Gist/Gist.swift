//
//  Gist.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// A gist.
public class Gist: Object {

  // The OCTGistFiles in the gist, keyed by fileName.
  public private(set) var files: [String: GistFile] = [:]

  // The date at which the gist was originally created.
  public private(set) var creationDate: NSDate?

  // The webpage URL for this gist.
  public private(set) var HTMLURL: NSURL?

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.creationDate <- map.transform("created_at", transformer: Transformer.stringToDate)
    self.HTMLURL <- map.transform("html_url", transformer: NSURL.init(string: ))
    self.files <- map.directory("files")
  }
}
