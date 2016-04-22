//
//  Client+Git.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {

  // Fetches the tree for the given reference.
  //
  // reference  - The SHA, branch, reference, or tag to fetch. May be nil, in
  //              which case HEAD is fetched.
  // repository - The repository from which the tree should be fetched. Cannot be
  //              nil.
  // recursive  - Should the tree be fetched recursively?
  //
  // Returns a signal which will send an OCTTree and complete or error.
  public func fetchTree(reference: String = "HEAD", repository: Repository, recursive: Bool = false) -> Observable<Tree> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/trees/\(reference)"
      if recursive {
        $0.parameters["recursive"] = true
      }
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }
}
