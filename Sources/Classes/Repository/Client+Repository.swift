//
//  Client+Repository.swift
//  GithubSwift
//
//  Created by Khoa Pham on 02/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift
import Sugar

public extension Client {
  
  // Fetches the repositories of the current `user`.
  //
  // Returns a signal which sends zero or more OCTRepository objects. Private
  // repositories will only be included if the client is `authenticated`. If no
  // `user` is set, the signal will error immediately.
  public func fetchUserRepositories() -> Observable<[Repository]> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "/repos"
    }
    
    return enqueueUser(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }
  
  /// Fetches the public repositories for the specified `user`.
  ///
  /// user    - The specified user. This must not be nil.
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns a signal which sends zero or more OCTRepository objects. Private
  /// repositories will not be included.
  public func fetchPublicRepositories(user user: User, offset: Int = 0, perPage: Int = Constant.defaultPerPage) -> Observable<[Repository]> {

    let requestDescriptor = RequestDescriptor().then {
      $0.path = "/users/\(user.login)/repos"
      $0.offset = offset
      $0.perPage = perPage
    }
    
    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  // Fetches the starred repositories of the current `user`.
  //
  // Returns a signal which sends zero or more OCTRepository objects. Private
  // repositories will only be included if the client is `authenticated`. If no
  // `user` is set, the signal will error immediately.
  public func fetchUserStarredRepositories() -> Observable<[Repository]> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "starred"
    }
    
    return enqueueUser(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  /// Fetches the starred repositories for the specified `user`.
  ///
  /// user    - The specified user. This must not be nil.
  /// offset  - Allows you to specify an offset at which items will begin being
  ///           returned.
  /// perPage - The perPage parameter. You can set a custom page size up to 100 and
  ///           the default value 30 will be used if you pass 0 or greater than 100.
  ///
  /// Returns a signal which sends zero or more OCTRepository objects. Private
  /// repositories will not be included.
  public func fetchStarredRepositories(user: User, offset: Int = 0,
                                       perPage: Int = Constant.defaultPerPage) -> Observable<[Repository]> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "/users/\(user.login)/starred"
      $0.offset = offset
      $0.perPage = perPage
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  // Fetches the specified organization's repositories.
  //
  // Returns a signal which sends zero or more OCTRepository objects. Private
  // repositories will only be included if the client is `authenticated` and the
  // `user` has permission to see them.
  public func fetchRepositories(organization: Organization) -> Observable<[Repository]> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "orgs/\(organization.login)/repos"
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  // Creates a repository under the user's account.
  //
  // Returns a signal which sends the new OCTRepository. If the client is not
  // `authenticated`, the signal will error immediately.
  public func createRepository(name: String,
                               organization: Organization? = nil, team: Team? = nil,
                               description: String? = nil, isPrivate: Bool = false) -> Observable<Repository> {
    if !isAuthenticated {
      return Observable<Repository>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .POST

      if let organization = organization {
        $0.path = "orgs/\(organization.login)/repos"
      } else {
        $0.path = "user/repos"
      }

      $0.parameters = [
        "name": name,
        "private": isPrivate
      ]

      if let description = description {
        $0.parameters["description"] = description
      }

      if let team = team {
        $0.parameters["team_id"] = team.objectID
      }
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches the content at `relativePath` at the given `reference` from the
  // `repository`.
  //
  // In case `relativePath` is `nil` the contents of the repository root will be
  // sent.
  //
  // repository   - The repository from which the file should be fetched.
  // relativePath - The relative path (from the repository root) of the file that
  //                should be fetched, may be `nil`.
  // reference    - The name of the commit, branch or tag, may be `nil` in which
  //                case it defaults to the default repo branch.
  //
  // Returns a signal which will send zero or more OCTContents depending on if the
  // relative path resolves at all or, resolves to a file or directory.
  public func fetchContent(relativePath: String? = nil, repository: Repository,
                           reference: String? = nil) -> Observable<Content> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/contents/\(relativePath ?? "")"

      if let reference = reference {
        $0.parameters["ref"] = reference
      }
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches the readme of a `repository`.
  //
  // repository - The repository for which the readme should be fetched.
  //
  // Returns a signal which will send zero or one OCTContent.
  public func fetchReadme(repository: Repository, reference: String? = nil) -> Observable<Content> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/readme"

      if let reference = reference {
        $0.parameters["ref"] = reference
      }
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches a specific repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTRepository.
  public func fetchRepository(name name: String, owner: String) -> Observable<Repository> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(owner)/\(name)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches all branches of a specific repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTBranch.
  public func fetchBranches(repositoryName: String, owner: String) -> Observable<Branch> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(owner)/\(repositoryName)/branches"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches all open pull requests (returned as issues) of a specific
  // repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTPullRequest.
  public func fetchOpenPullRequests(repositoryName: String, owner: String) -> Observable<PullRequest> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(owner)/\(repositoryName)/pulls"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Fetches all closed pull requests (returned as issues) of a specific
  // repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTPullRequest.
  public func fetchClosedPullRequests(repositoryName: String, owner: String) -> Observable<PullRequest> {
    let requestDescriptor = RequestDescriptor().then {
      $0.path = "repos/\(owner)/\(repositoryName)/pulls"
      $0.parameters["state"] = "closed"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }
}
