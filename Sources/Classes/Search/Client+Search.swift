//
//  Client+Search.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {

  ///  Search repositories.
  ///
  ///  query     - The search keywords, as well as any qualifiers. This must not be nil.
  ///  orderBy   - The sort field. One of stars, forks, or updated. Default: results
  ///              are sorted by best match. This can be nil.
  ///  ascending - The sort order, ascending or not.
  ///
  ///  Returns a signal which will send the search result `OCTRepositoriesSearchResult`.
  public func searchRepositories(query: String, orderBy: String? = nil,
                                 ascending: Bool = true) -> Observable<RepositorySearchResult> {

    let requestDescriptor = RequestDescriptor().then {
      $0.path = "/search/repositories"
      $0.parameters = [
        "q": query,
        "order": ascending ? "asc" : "desc"
      ]

      if let orderBy = orderBy {
        $0.parameters["sort"] = orderBy
      }

      $0.headers["Accept"] = "application/vnd.github.v3.text-match+json"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }
}
