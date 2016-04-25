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
import Construction

public extension Client {
  
  // Fetches the repositories of the current `user`.
  //
  // Returns a signal which sends zero or more OCTRepository objects. Private
  // repositories will only be included if the client is `authenticated`. If no
  // `user` is set, the signal will error immediately.
  public func fetchUserRepositories() -> Observable<[Repository]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "/repos"
    }
    
    return enqueueUser(requestDescriptor).map {
      return Parser.all($0)
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

    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "/users/\(user.login)/repos"
      $0.offset = offset
      $0.perPage = perPage
    }
    
    return enqueue(requestDescriptor).map {
      return Parser.all($0)
    }
  }

  // Fetches the starred repositories of the current `user`.
  //
  // Returns a signal which sends zero or more OCTRepository objects. Private
  // repositories will only be included if the client is `authenticated`. If no
  // `user` is set, the signal will error immediately.
  public func fetchUserStarredRepositories() -> Observable<[Repository]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "starred"
    }
    
    return enqueueUser(requestDescriptor).map {
      return Parser.all($0)
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
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "/users/\(user.login)/starred"
      $0.offset = offset
      $0.perPage = perPage
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0)
    }
  }

  // Fetches the specified organization's repositories.
  //
  // Returns a signal which sends zero or more OCTRepository objects. Private
  // repositories will only be included if the client is `authenticated` and the
  // `user` has permission to see them.
  public func fetchRepositories(organization: Organization) -> Observable<[Repository]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "orgs/\(organization.login)/repos"
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0)
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

    let requestDescriptor: RequestDescriptor = construct {
      $0.method = .POST

      if let organization = organization {
        $0.path = "orgs/\(organization.login)/repos"
      } else {
        $0.path = "user/repos"
      }

      $0.parameters = ([
        "name": name,
        "private": isPrivate,
        "description": description,
        "team_id": team?.objectID
      ] as [String: AnyObject?]).dropNils()
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
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
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/contents/\(relativePath ?? "")"

      if let reference = reference {
        $0.parameters["ref"] = reference
      }
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
    }
  }

  // Fetches the readme of a `repository`.
  //
  // repository - The repository for which the readme should be fetched.
  //
  // Returns a signal which will send zero or one OCTContent.
  public func fetchReadme(repository: Repository, reference: String? = nil) -> Observable<Content> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/readme"

      if let reference = reference {
        $0.parameters["ref"] = reference
      }
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
    }
  }

  // Fetches a specific repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTRepository.
  public func fetchRepository(name name: String, owner: String) -> Observable<Repository> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(owner)/\(name)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
    }
  }

  // Fetches all branches of a specific repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTBranch.
  public func fetchBranches(repositoryName: String, owner: String) -> Observable<[Branch]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(owner)/\(repositoryName)/branches"
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0)
    }
  }

  // Fetches all open pull requests (returned as issues) of a specific
  // repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTPullRequest.
  public func fetchOpenPullRequests(repositoryName: String, owner: String) -> Observable<[PullRequest]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(owner)/\(repositoryName)/pulls"
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0)
    }
  }

  // Fetches all closed pull requests (returned as issues) of a specific
  // repository owned by the given `owner` and named `name`.
  //
  // name  - The name of the repository, must be a non-empty string.
  // owner - The owner of the repository, must be a non-empty string.
  //
  // Returns a signal of zero or one OCTPullRequest.
  public func fetchClosedPullRequests(repositoryName: String, owner: String) -> Observable<[PullRequest]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(owner)/\(repositoryName)/pulls"
      $0.parameters["state"] = "closed"
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0)
    }
  }

  // Fetches a single pull request on a specific repository owned by the
  // given `owner` and named `name` and with the pull request number 'number'.
  //
  // name   - The name of the repository, must be a non-empty string.
  // owner  - The owner of the repository, must be a non-empty string.
  // number - The pull request number on the repository, must be integer
  //
  // Returns a signal of zero or one OCTPullRequest.
  public func fetchPullRequest(repositoryName: String, owner: String, number: Int) -> Observable<Repository> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(owner)/\(repositoryName)/pulls/\(number)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
    }
  }

  /// Create a pull request in the repository.
  ///
  /// repository - The repository on which the pull request will be created.
  ///              Cannot be nil.
  /// title      - The title for the pull request. Cannot be nil.
  /// body       - The body for the pull request. May be nil.
  /// baseBranch - The name of the branch into which the changes will be merged.
  ///              Cannot be nil.
  /// headBranch - The name of the branch which will be brought into `baseBranch`.
  ///              Cannot be nil.
  ///
  /// Returns a signal of an OCTPullRequest.
  public func createPullRequest(repository: Repository, title: String,
                                body: String? = nil, baseBranch: String, headBranch: String) -> Observable<PullRequest> {

    let requestDescriptor: RequestDescriptor = construct {
      $0.method = .POST
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/pulls"
      $0.parameters = ([
        "title": title,
        "head": headBranch,
        "base": baseBranch,
        "body": body
      ] as [String: AnyObject?]).dropNils()
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
    }
  }

  // Fetches commits of the given `repository` filtered by `SHA`.
  // If no SHA is given, the commit history of all branches is returned.
  //
  // repository  - The repository to fetch from.
  // SHA         - SHA or branch to start listing commits from.
  //
  // Returns a signal of zero or one OCTGitCommit.
  public func fetchCommits(repository: Repository, SHA: String) -> Observable<[GitCommit]> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/commits"
      $0.parameters["sha"] = SHA
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0)
    }
  }

  // Fetches a single commit specified by the `SHA` from a `repository`.
  //
  // repository  - The repository to fetch from.
  // SHA         - The SHA of the commit.
  //
  // Returns a signal of zero or one OCTGitCommit.
  public func fetchCommit(repository: Repository, SHA: String) -> Observable<GitCommit> {
    let requestDescriptor: RequestDescriptor = construct {
      $0.path = "repos/\(repository.ownerLogin)/\(repository.name)/commits/\(SHA)"
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0)
    }
  }
}
