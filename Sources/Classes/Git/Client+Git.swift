//
//  Client+Git.swift
//  GithubSwift
//
//  Created by Khoa Pham on 23/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Tailor

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

  // Creates a new tree.
  //
  // treeEntries - The `OCTTreeEntry` objects that should comprise the new tree.
  //               This array must not be nil.
  // repository  - The repository in which to create the tree. Cannot be nil.
  // baseTreeSHA - The SHA of the tree upon which to base this new tree. This may
  //               be nil to create an orphaned tree.
  //
  // Returns a signal which will send the created OCTTree and complete, or error.
  public func createTree(entries: [TreeEntry], repository: Repository,
                         basedOnTreeWithSHA sha: String? = nil) -> Observable<Tree> {
    let requestDescriptor = RequestDescriptor().then {
      $0.method = .POST
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/trees"
      $0.parameters = ([
        "tree": entries.map { $0.toJSON() },
        "base_tree": sha
      ] as [String: AnyObject?]).dropNils()
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches the blob identified by the given SHA.
  //
  // blobSHA    - The SHA of the blob to fetch. This must not be nil.
  // repository - The repository from which the blob should be fetched. Cannot be
  //              nil.
  //
  // Returns a signal which will send an NSData then complete, or error.
  public func fetchBlob(blobSHA: String, repository: Repository) ->Observable<Blob> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/blobs/\(blobSHA)"
      $0.headers["Accept"] = "application/vnd.github.\(Constant.apiVersion).raw"
      $0.fetchAllPages = false
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Creates a blob using the given text content.
  //
  // string     - The text for the new blob. This must not be nil.
  // repository - The repository in which to create the blob. This must not be
  //              nil.
  // encoding   - The encoding of the text. utf-8 or base64, must not be nil.
  //
  // Returns a signal which will send an NSString of the new blob's SHA then
  // complete, or error.
  public func createBlob(string: String, repository: Repository, encoding: ContentEncoding = .UTF8) -> Observable<String> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/blobs"
      $0.parameters = [
        "content": string,
        "encoding": encoding.rawValue
      ]
    }

    return enqueue(requestDescriptor).map {
      return $0.jsonArray.first?.property("sha") ?? ""
    }
  }

  // Fetches the commit identified by the given SHA.
  //
  // commitSHA  - The SHA of the commit to fetch. This must not be nil.
  // repository - The repository from which the commit should be fetched. Cannot be
  //              nil.
  //
  // Returns a signal which will send an `OCTCommit` then complete, or error.
  public func fetchCommit(commitSHA: String, repository: Repository) -> Observable<Commit> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/commits/\(commitSHA)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Creates a commit.
  //
  // message    - The message of the new commit. This must not be nil.
  // repository - The repository in which to create the commit. This must not be
  //              nil.
  // treeSHA    - The SHA of the tree for the new commit. This must not be nil.
  // parentSHAs - An array of `NSString`s representing the SHAs of parent commits
  //              for the new commit. This can be empty to create a root commit,
  //              or have more than one object to create a merge commit. This
  //              array must not be nil.
  //
  // Returns a signal which will send the created `OCTCommit` then complete, or
  // error.
  public func createCommit(message: String, repository: Repository,
                           pointingToTreeWithSHA treeSHA: String,
                                                 parentCommitSHAs SHAs: [String]) -> Observable<Commit> {
    let requestDescriptor = RequestDescriptor().then {
      $0.method = .POST
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/commits"
      $0.parameters = [
        "message": message,
        "tree": treeSHA,
        "parents": SHAs
      ]
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches all references in the given repository.
  //
  // repository - The repository in which to fetch the references. This must not be nil.
  //
  // Returns a signal which sends zero or more OCTRef objects then complete, or error.
  public func fetchReferences(repository: Repository) -> Observable<[Ref]> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/refs"
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  // Fetches a git reference given its fully-qualified name.
  //
  // refName    - The fully-qualified name of the ref to fetch (e.g.,
  //              `heads/master`). This must not be nil.
  // repository - The repository in which to fetch the ref. This must not be nil.
  //
  // Returns a signal which will send an OCTRef then complete, or error.
  public func fetchReference(name: String, repository: Repository) -> Observable<Ref> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/refs/\(name)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Attempts to update a reference to point at a new SHA.
  //
  // refName    - The fully-qualified name of the ref to update (e.g.,
  //              `heads/master`). This must not be nil.
  // repository - The repository in which to update the ref. This must not be nil.
  // newSHA     - The new SHA for the ref. This must not be nil.
  // force      - Whether to force the ref to update, even if it cannot be
  //              fast-forwarded.
  //
  // Returns a signal which will send the updated OCTRef then complete, or error.
  public func updateReference(name: String, repository: Repository,
                              toSHA SHA: String, force: Bool = false) -> Observable<Ref> {
    let requestDescriptor = RequestDescriptor().then {
      $0.method = .PATCH
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/git/refs/\(name)"
      $0.parameters = [
        "sha": SHA,
        "force": force
      ]
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }

  }
}
