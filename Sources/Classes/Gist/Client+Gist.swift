//
//  Client+Gist.swift
//  GithubSwift
//
//  Created by Khoa Pham on 20/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import RxSwift

public extension Client {

  // Fetches the gists since the date for the current user.
  //
  // since - If not nil, only gists updated at or after this time are returned.
  //         If nil, all the gists are returned.
  //
  // Returns a signal which will send zero or more OCTGists and complete. If the client
  // is not `authenticated`, the signal will error immediately.
  public func fetchGists(updatedSince: NSDate? = nil) -> Observable<[Gist]> {
    if !isAuthenticated {
      return Observable<[Gist]>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.path = "gists"

      if let since = updatedSince {
        $0.parameters["since"] = Formatter.string(date: since)
      }
    }

    return enqueue(requestDescriptor).map {
      return Parser.all($0.jsonArray)
    }
  }

  // Creates a gist using the given changes.
  //
  // edit - The changes to use for creating the gist. This must not be nil.
  //
  // Returns a signal which will send the created OCTGist and complete. If the client
  // is not `authenticated`, the signal will error immediately.
  public func createGist(edit: GistEdit) -> Observable<Gist> {
    if !isAuthenticated {
      return Observable<Gist>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .POST
      $0.path = "gists"
      $0.parameters = edit.toJSON()
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }

  // Edits one or more files within a gist.
  //
  // edit - The changes to make to the gist. This must not be nil.
  // gist - The gist to modify. This must not be nil.
  //
  // Returns a signal which will send the updated OCTGist and complete. If the client
  // is not `authenticated`, the signal will error immediately.
  public func apply(edit: GistEdit, gist: Gist) -> Observable<Gist> {
    if !isAuthenticated {
      return Observable<Gist>.error(Error.authenticationRequiredError())
    }

    let requestDescriptor = RequestDescriptor().then {
      $0.method = .PATCH
      $0.path = "gists/\(gist.objectID)"
      $0.parameters = edit.toJSON()
    }

    return enqueue(requestDescriptor).map {
      return Parser.one($0.jsonArray)
    }
  }
}
