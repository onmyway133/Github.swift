//
//  RepositorySearchResult.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import Tailor
import Sugar

// Represents the results of search repositories method.
public class RepositorySearchResult: Object {

  // The total repositories count of the search results.
  public private(set) var totalCount: Int = 0

  // Indicates whether the results incomplete or not.
  public private(set) var isIncompleteResults: Bool = false

  // The repository array of the search results.
  public private(set) var repositories: [Repository] = []

  public required init(_ map: JSONDictionary) {
    super.init(map)

    self.totalCount <- map.property("total_count")
    self.isIncompleteResults <- map.property("incomplete_results")
    self.repositories <- map.relations("items")
  }
}
